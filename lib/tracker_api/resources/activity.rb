module TrackerApi
  module Resources
    class Activity
      include Virtus.model
      include Equalizer.new(:guid)

      attribute :client

      attribute :kind, String
      attribute :guid, String
      attribute :project_version, Integer
      attribute :message, String
      attribute :highlight, String
      attribute :changes, Shared::Collection[Change]
      attribute :primary_resources, Shared::Collection[PrimaryResource]
      attribute :project, Project
      attribute :performed_by, Person
      attribute :occurred_at, DateTime

      def project=(data)
        super.client = client
      end
    end
  end
end
