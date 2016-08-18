module Nelou::SocialHelper
  def facebook_app_id
    Rails.configuration.x.social['facebook_app_id']
  end

  def facebook_sharer_path(url)
    params = {
      u: url
    }
    "https://www.facebook.com/sharer/sharer.php?#{params.to_query}"
  end

  def twitter_sharer_path(name, url)
    params = {
      status: "#{name} - #{url}"
    }
    "https://twitter.com/home?#{params.to_query}"
  end

  def pinterest_share_path(product)
    params = {
      url: spree.product_url(product),
      description: strip_tags(product.description)
    }

    params[:media] = asset_url(product.images.first.attachment.url(:original)) if product.images.any?

    "https://de.pinterest.com/pin/create/button/?#{params.to_query}"
  end
end
