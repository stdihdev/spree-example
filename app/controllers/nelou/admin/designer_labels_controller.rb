module Nelou
  module Admin
    class DesignerLabelsController < Spree::Admin::ResourceController
      protected

      def model_class
        Nelou::DesignerLabel
      end

      def object_name
        :nelou_designer_label
      end

      def location_after_save
        main_app.edit_admin_nelou_designer_label_url(@object)
      end

      def collection_url
        main_app.admin_nelou_designer_labels_url.group(:id)
      end

      def permitted_resource_params
        if spree_current_user.present? && spree_current_user.designer?
          params.require(resource.object_name).permit(:name, :profile, :short_description, :logo, :profile_image, :teaser_image, :photo_credits, :green, :paypal, :website, :vat, translations_attributes: [])
        else
          super
        end
      end

      def collection
        return @collection if @collection
        params[:q] ||= {}

        params[:q][:active_eq] = '1' unless params[:q].has_key?(:active_eq)
        params[:q][:accepted_eq] = '1' unless params[:q].has_key?(:accepted_eq)

        @search = Nelou::DesignerLabel.ransack(params[:q])

        @collection = @search.result(distinct: true)
          .joins(:user)
          .includes(:user)
          .select("#{Nelou::DesignerLabel.quoted_table_name}.*, #{Spree.user_class.quoted_table_name}.*")
          .order("#{Spree.user_class.quoted_table_name}.last_sign_in_at DESC NULLS LAST")
          .uniq
          .page(params[:page])
      end
    end
  end
end
