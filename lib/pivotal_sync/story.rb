module PivotalSync
  class Story
    include HappyMapper
    
    class << self
      
      def all(project_id)
        @all ||= {}
        @all[project_id] ||= parse(Client.connection["projects/#{project_id}/stories"].get)
      end
      
      def find(id)
        if @all
          @all.detect { |story| story.id == id}
        else
          parse(Client.connection["stories/#{id}"].get)
        end
      end
      
    end
    
    element :id, Integer
    element :project_id, Integer
    element :story_type, String
    element :url, String
    element :estimate_type, Float
    element :current_state, String
    element :description, String
    element :name, String
    element :requested_by, String
    element :owned_by, String
    element :created_at, DateTime
    element :accepted_at, DateTime
    element :labels, String
    has_many :attachments, Attachment
    
    def project
      Project.find(project_id)
    end
    
    def comments
      @comments ||= {}
      @comments[id] ||= Comment.all(project_id, id)
    end
    
    def tasks
      @tasks ||= {}
      @tasks[id] ||= Task.all(project_id, id)
    end
    
  end
end