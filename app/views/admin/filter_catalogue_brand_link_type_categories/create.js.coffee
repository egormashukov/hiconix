$("#filter_catalogue_brand_link_type_categories_table tbody").append('<%= j render partial: "filter_catalogue_brand_link_type_category", locals: { filter: @filter } %>')
$(".select2").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)
