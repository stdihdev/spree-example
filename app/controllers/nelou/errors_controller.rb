module Nelou
  class ErrorsController < Spree::StoreController
    def not_found
      render(:status => 404)
    end
  end
end
