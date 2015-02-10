class AdminAddonFormBuilder < AdminFormBuilder
  delegate :render, to: :@template
  # def redactor(name, *args)
  #   content_tag :div, class: 'field-box' do
  #     content_tag(:div, label(name, class: 'control-label'), class: 'col-md-2') + content_tag(:br) + content_tag(:div, text_area(name, new_args_with_class('redactor', *args)), class: 'col-md-12')
  #   end
  # end
  def select_two(name, *args)
    content_tag :div, class: 'field-box' do
      content_tag(:div, label(name, class: 'control-label'), class: 'col-md-2') + content_tag(:div, select(name, args_with_class(*args, 'select2')), class: 'col-md-10')
    end
  end

  def number_field_inline(name, *args)
    content_tag :div, class: 'field-box' do
      content_tag(:div, label(name, class: 'control-label'), class: 'col-md-2') + content_tag(:div, number_field(name, args_with_form_field_class(*args)), class: 'col-md-10')
    end
  end

  def fields_for_nested(association, parent)
    new_object = object.send(association).build
    id = new_object.object_id
    fields = fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + '_fields', f: builder, parent: parent)
    end
    fields
  end

  def args_with_class(*args, klass)
    new_l = args.extract_options!
    class_from_args = args.extract_options![:class]
    new_l.merge!(class: "#{klass} #{class_from_args}")
  end

  def redactor(name, *args)
    content_tag :div, class: 'field-box' do
      content_tag(:div, label(name, class: 'control-label'), class: 'col-md-2') + content_tag(:br) + content_tag(:div, text_area(name, args_with_class(*args, 'js-redactor')), class: 'col-md-12')
    end
  end

  def textfielded_select(name, options)
    content_tag :div, class: 'field-box' do
      content_tag(:div, label(name, class: 'control-label'), class: 'col-md-2') + content_tag(:div, hidden_field(name, class: 'js-textfielded-select', data: { valuesarray: options }), class: 'col-md-10')
    end
  end

end
