module Nelou::SizeOptionTypeHelper

  def size_filter_options_for_types(option_types)
    options = Nelou::SizeOptionValue.where(option_type: option_types).reorder(name: :asc).map do |option_value|
      [option_value.presentation, option_value.id, current_filter_option?(option_value.id)]
    end

    options.sort_by(&:first).each do |option_value|
      concat content_tag :option, option_value[0], value: option_value[1], selected: option_value[2]
    end
  end

end
