module Nelou
  module Admin
    class SizeOptionValuesController < Spree::Admin::OptionValuesController

      protected

      def model_class
        Nelou::SizeOptionValue
      end

      def object_name
        :size_option_value
      end

    end
  end
end
