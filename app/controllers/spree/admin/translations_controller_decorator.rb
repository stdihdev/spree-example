Spree::Admin::TranslationsController.class_eval do
  def slugged_models
    ['SpreeProduct', 'NelouDesignerLabel']
  end

  private

  # Necessary hack, as this controller assumes to always operate within the Spree module
  def klass
    tmp = params[:resource].classify

    if tmp == 'DesignerLabel'
      @klass ||= "Nelou::#{tmp}".constantize
    else
      @klass ||= "Spree::#{tmp}".constantize
    end
  end

  alias_method :orig_resource_name, :resource_name
  def resource_name
    name = orig_resource_name
    if name == 'designer_label'
      'nelou_designer_label'
    else
      name
    end
  end
end
