Spree::Admin::OptionTypesController.class_eval do

  protected

  def collection
    model_class.where(type: ['', nil])
  end

end
