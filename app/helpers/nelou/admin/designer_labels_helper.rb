module Nelou::Admin::DesignerLabelsHelper

  def bootstrap_boolean(value)
    tag :i, class: "glyphicon glyphicon-#{value ? 'ok' : 'remove'}"
  end

end
