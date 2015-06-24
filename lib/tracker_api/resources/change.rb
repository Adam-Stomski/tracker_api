module TrackerApi
  module Resources
    class Change
      include Resources::Base

      attribute :change_type, String
      attribute :kind, String
      attribute :name, String
      attribute :new_values, Hash
      attribute :original_values, Hash
      attribute :story_type, String
    end
  end
end
