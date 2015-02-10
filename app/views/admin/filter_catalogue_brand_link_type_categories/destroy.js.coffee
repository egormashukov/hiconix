$('#type_category_low_category_<%= @type_category_low_category.id %>').remove()
$("#type_category_low_categories_table").before('<%= j notice_window(@notice) %>')
$('#type_category_low_categories_form').html('<%= j render "admin/type_category_low_categories/form", low_category: @type_category_low_category.low_category %>')
$(".select2").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)
setTimeout(
  -> $('.notice_window').slideUp()
  3000
)