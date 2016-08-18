module Nelou
  module Admin
    class ChangelogController < Spree::Admin::BaseController

      before_action :load_commits, only: [ :index ]

      def index
      end

      private

      def load_commits
        @git = Git.open(Rails.root, repository: Rails.application.config.x.changelog_repo)
        @commits = @git.log(30).object(Rails.application.config.x.changelog_branch)
      end

    end
  end
end
