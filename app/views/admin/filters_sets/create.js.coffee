$("#filter_catalogue_brand_link_type_category_table tbody").append('<%= j render partial: "filter_catalogue_brand_link_type_category", locals: { filter_set: @filter_set, assoc: @assoc } %>')
$('#filters_sets_form').html('<%= j render "admin/filters_sets/form", locals: { filters_sets: @filter_set, assoc: @assoc } %>')
$(".select2").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)
