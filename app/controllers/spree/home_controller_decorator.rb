Spree::HomeController.class_eval do
  def index
    @products = Spree::Product.at_random(12)
    @taxonomies = Spree::Taxonomy.includes(root: :children)
    @designer_labels = Nelou::DesignerLabel.for_slider
  end
end
