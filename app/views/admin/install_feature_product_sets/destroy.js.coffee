$('#install_feature_product_set_<%= @install_feature_product_set.id %>').remove()
$("#install_feature_product_sets_table").before('<%= j notice_window(@notice) %>')
$('#install_feature_product_sets_form').html('<%= j render "admin/install_feature_product_sets/form", product_set: @install_feature_product_set.product_set %>')
$(".select2").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)
setTimeout(
  -> $('.notice_window').slideUp()
  3000
)