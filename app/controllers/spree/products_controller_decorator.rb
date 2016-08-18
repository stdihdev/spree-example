Spree::ProductsController.class_eval do
  include Nelou::ProductSorting
  include Nelou::ProductFiltering

  before_action :load_product, only: [ :images, :show ]

  alias_method :old_index, :index

  def index
    old_index # Like calling super: http://stackoverflow.com/a/13806783/73673
    @products = apply_filter_scope(@products.reorder('').send(sorting_scope))
    if params[:keywords].present?
      @designers = Nelou::DesignerLabel.active.with_name_like(params[:keywords]).distinct
    end
  end

  def images
  end

  private


  def load_product
    if try_spree_current_user.try(:has_spree_role?, "admin")
      @products = Spree::Product.with_deleted
    else
      @products = Spree::Product.active_with_sold_out(current_currency)
    end
    @product = @products.friendly.find(params[:id])
  end

end
