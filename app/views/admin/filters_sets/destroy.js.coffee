$('#filters_set_<%= @filter.id %>').remove()
$('#filters_sets_form').html('<%= j render "admin/filters_sets/form", locals: { filters_sets: @filter, assoc: @assoc } %>')
$(".select2").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)