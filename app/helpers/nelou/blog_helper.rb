module Nelou
  module BlogHelper

    def fetch_blog_entries
      Nelou::FetchBlogService.new.fetch
    end

  end
end
