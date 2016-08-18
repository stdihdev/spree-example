module Nelou
  module ProductSorting
    extend ActiveSupport::Concern

    included do
      helper_method :sorting_param
      helper_method :current_sorting?
    end

    def sorting_param
      params[:sorting].try(:to_sym) || default_sorting
    end

    def current_sorting?(key)
      sorting_param == key.to_sym
    end

    private

    def sorting_scope
      allowed_sortings.include?(sorting_param) ? sorting_param : default_sorting
    end

    def sorting_param
      params[:sorting].try(:to_sym) || default_sorting
    end

    def default_sorting
      :descend_by_available_on
    end

    def allowed_sortings
      [:descend_by_available_on, :ascend_by_available_on]
    end
  end
end
