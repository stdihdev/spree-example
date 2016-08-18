Spree::Admin::ProductsController.class_eval do

  before_action :load_designer_label_data, except: :index
  before_action :set_designer_label, only: [:create, :update]

  protected

  def collection
    return @collection if @collection.present?
    params[:q] ||= {}
    params[:q][:deleted_at_null] ||= "1"

    params[:q][:s] ||= "name asc"
    @collection = super
    # Don't delete params[:q][:deleted_at_null] here because it is used in view to check the
    # checkbox for 'q[deleted_at_null]'. This also messed with pagination when deleted_at_null is checked.
    @collection = @collection.with_deleted if params[:q][:deleted_at_null] == '0'

    # Only show orders for the current designer
    @collection = @collection.by_designer(spree_current_user.designer_label) if spree_current_user.designer?

    # @search needs to be defined as this is passed to search_form_for
    # Temporarily remove params[:q][:deleted_at_null] from params[:q] to ransack products.
    # This is to include all products and not just deleted products.
    @search = @collection.ransack(params[:q].reject { |k, _v| k.to_s == 'deleted_at_null' })
    @collection = @search.result
          .distinct_by_product_ids(params[:q][:s])
          .includes(product_includes)
          .page(params[:page])
          .per(params[:per_page] || Spree::Config[:admin_products_per_page])
    @collection
  end

  def load_designer_label_data
    @designer_labels = Nelou::DesignerLabel.all.order(:name)
  end

  def set_designer_label
    if spree_current_user.designer?
      params[:product][:designer_label_id] = spree_current_user.designer_label.id
    end
  end

end
