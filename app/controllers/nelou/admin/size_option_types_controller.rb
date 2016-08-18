module Nelou
  module Admin
    class SizeOptionTypesController < Spree::Admin::OptionTypesController

      before_action :load_option_types, only: :index
      before_action :load_option_type, only: [ :edit, :update, :new, :create ]
      before_action :setup_new_size_option_value, only: :edit

      skip_before_action :setup_new_option_value

      protected

      def model_class
        Nelou::SizeOptionType
      end

      def object_name
        :nelou_size_option_type
      end

      def new_object_url
        main_app.new_admin_nelou_size_option_type_url
      end

      def collection_url
        main_app.admin_nelou_size_option_types_url
      end

      def load_option_types
        @option_types = @collection
      end

      def load_option_type
        @option_type = @nelou_size_option_type
      end

      def location_after_save
        if @option_type.created_at == @option_type.updated_at
          edit_admin_nelou_size_option_type_url(@option_type)
        else
          admin_nelou_size_option_types_url
        end
      end

      def collection
        model_class.where(nil)
      end

      def setup_new_size_option_value
        @nelou_size_option_type.size_option_values.build if @nelou_size_option_type.size_option_values.empty?
      end

    end
  end
end
