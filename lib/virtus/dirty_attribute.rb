require_relative 'dirty_attribute/session'

# @source: https://github.com/ahawkins/virtus-dirty_attribute
#
# The above gem works great for the majority of Virtus use cases, but is
# not activly maintained.
#
# Here is a diff of the changes that have been made.
# https://gist.github.com/forest/40d3244acb00bb7a0322
#
# We use instance_variable_get instead of the attribute getter
# method to get the original value. This is because in TrackerApi we
# often override the attribute getter to implement lazy loading of
# associated data from the API (e.g. Project#epics). Making an API
# request just get the original value is not what we want. Another thing
# that must be done is being careful to mark the Resource as clean
# when new data is loaded from the server (e.g. Endpoints::Epic#update).
module Virtus
  # == Dirty Tracking
  #
  # Dirty Tracking is an optional module that you include only if you need it.
  module DirtyAttribute
    module ClassMethods
      def attribute(name, type, options = {})
        _create_writer_with_dirty_tracking(name)
        super
      end

      private
      def _create_writer_with_dirty_tracking(name)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}=(new_regular_object)
            prev_object = instance_variable_get(:@#{name})
            new_virtus_object = super

            if attribute_dirty?(:#{name}) && original_attributes[:#{name}] == new_virtus_object
              attribute_clean!(:#{name})
            elsif prev_object != new_virtus_object
              unless original_attributes.key?(:#{name})
                original_attributes[:#{name}] = prev_object
              end

              attribute_dirty!(:#{name}, new_regular_object)
            end

            new_virtus_object
          end
        RUBY
      end
    end

    module InitiallyClean
      def initialize(*args)
        super(*args)
        clean!
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end

    def dirty?
      dirty_session.dirty?
    end

    def clean?
      !dirty?
    end

    def attribute_dirty?(name, options = {})
      result = dirty_session.dirty?(name)
      result &&= options[:to] == dirty_attributes[name] if options.key?(:to)
      result &&= options[:from] == original_attributes[name] if options.key?(:from)
      result
    end

    def clean!
      dirty_session.clean!
    end

    def dirty_attributes
      dirty_session.dirty_attributes
    end

    def original_attributes
      dirty_session.original_attributes
    end

    def attribute_dirty!(name, value)
      dirty_session.dirty!(name, value)
    end

    def attribute_clean!(name)
      dirty_session.attribute_clean!(name)
    end

    private

    def dirty_session
      @_dirty_session ||= Session.new(self)
    end
  end
end
