module Nelou
  class FetchBlogService

    def initialize
      @url = "http://blog.nelou.com/#{I18n.locale}?feed=json"
    end

    def fetch
      Rails.cache.fetch("#{cache_key}/#{I18n.locale}/blog_contents", expires_in: 12.hours) do
        JSON.parse fetch_resource(@url)
      end
    rescue ArgumentError
      return []
    end

    private

    def fetch_resource(uri_str, limit = 10)
      raise ArgumentError, 'too many HTTP redirects' if limit == 0

      response = Net::HTTP.get_response(URI(uri_str))

      case response
      when Net::HTTPSuccess then
        response.body
      when Net::HTTPRedirection then
        location = response['location']
        warn "redirected to #{location}"
        fetch_resource(location, limit - 1)
      else
        raise ArgumentError, response.value
      end
    end


    def cache_key
      'nelou_blog_preview'
    end

  end
end
