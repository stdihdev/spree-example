module Nelou
  module ProductFiltering
    extend ActiveSupport::Concern

    included do
      helper_method :filter_params
      helper_method :current_filter_option?
    end

    def filter_params
      return @filter_params if @filter_params.present?

      @filter_params = params[:filter].present? ? params[:filter].reject(&:nil?).reject(&:blank?) : []

      @filter_params
    end

    def current_filter_option?(key)
      if filter_params.present?
        filter_params.include?(key.to_s)
      else
        false
      end
    end

    private

    def apply_filter_scope(products)
      if filter_params.present? && filter_params.any?
        products.where(id: Spree::Product.option_all(filter_params).select(:id))
      else
        products
      end
    end
  end
end
