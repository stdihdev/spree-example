Spree::TaxonsController.class_eval do
  include Nelou::ProductSorting
  include Nelou::ProductFiltering

  before_action :load_taxonomies, only: Nelou::SPECIAL_CATEGORIES
  before_action :load_special_categories, only: Nelou::SPECIAL_CATEGORIES
  before_action :paginate_products, only: Nelou::SPECIAL_CATEGORIES

  Nelou::SPECIAL_CATEGORIES.each do |name|
    define_method name do
      render :show
    end
  end

  alias_method :old_show, :show
  def show
    old_show # Like calling super: http://stackoverflow.com/a/13806783/73673
    @products = apply_filter_scope(@products.reorder('').send(sorting_scope))
  end

  private

  def load_taxonomies
    @taxonomies = Spree::Taxonomy.includes(root: :children)
  end

  def load_special_categories
    @products = Spree::Product.active.send(params[:action]).send(sorting_scope)
  end

  def paginate_products
    @products = @products.page(curr_page).per(per_page)
  end

  def curr_page
    if params[:page].respond_to?(:to_i)
      (params[:page].to_i <= 0) ? 1 : params[:page].to_i
    else
      1
    end
  end

  def per_page
    if params[:per_page].respond_to?(:to_i)
      (params[:per_page].to_i <= 0) ? Spree::Config[:products_per_page] : params[:per_page].to_i
    else
      Spree::Config[:products_per_page]
    end
  end
end
