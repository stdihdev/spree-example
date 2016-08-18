Spree::Admin::NavigationHelper.class_eval do
  def link_to_clone(resource, options={})
    options[:data] = { action: 'clone' }
    options[:class] = "btn btn-primary btn-sm"
    link_to_with_icon('duplicate', Spree.t(:clone), clone_object_url(resource), options)
  end
end
