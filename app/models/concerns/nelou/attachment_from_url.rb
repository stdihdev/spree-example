module Nelou
  module AttachmentFromUrl
    extend ActiveSupport::Concern

    module ClassMethods
      def allow_from_url(*args)
        args.each do |attribute|
          define_method "#{attribute}_from_url" do |url|
            if check_url(url)
              send "#{attribute}=", URI.parse(url)
            else
              send "#{attribute}=", nil
            end
          end
        end
      end
    end

    private

    def check_url(url)
      uri = URI(url)
      request = Net::HTTP.new uri.host
      response = request.request_head uri.path
      response.code.to_i == 200
    end
  end
end
