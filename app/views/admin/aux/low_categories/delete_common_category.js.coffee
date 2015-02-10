$('#nested_low_category_<%= @modify_low_category.id %>').remove()
$("#nested_low_categories_form").html('<%= j render partial: "admin/nested_low_categories/form" %>')
$(".select2#modify_low_category_id").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)

