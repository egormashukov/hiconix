$('#install_feature_category_<%= @install_feature_category.id %>').remove()
$("#install_feature_categories_table").before('<%= j notice_window(@notice) %>')
$('#install_feature_categories_form').html('<%= j render "admin/install_feature_categories/form", category: @install_feature_category.category %>')
$(".select2").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)
setTimeout(
  -> $('.notice_window').slideUp()
  3000
)