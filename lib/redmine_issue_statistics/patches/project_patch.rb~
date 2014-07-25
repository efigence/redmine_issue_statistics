require_dependency 'project'

module RedmineDefaultIssues
  module Patches
    module ProjectPatch
      def self.included(base) # :nodoc:
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          has_many :default_issues, :dependent => :destroy
        end
      end
    end
  end
end

unless Project.included_modules.include?(RedmineDefaultIssues::Patches::ProjectPatch)
  Project.send(:include, RedmineDefaultIssues::Patches::ProjectPatch)
end
