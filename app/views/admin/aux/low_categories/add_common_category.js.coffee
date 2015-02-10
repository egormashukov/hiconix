$("#nested_low_categories_table tbody").append('<%= j render partial: "admin/nested_low_categories/nested_low_category", locals: { modify_low_category: @modify_low_category } %>')
$("#nested_low_categories_form").html('<%= j render partial: "admin/nested_low_categories/form" %>')
$(".select2#modify_low_category_id").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)
