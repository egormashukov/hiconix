$('#install_feature_product_<%= @install_feature_product.id %>').remove()
$("#install_feature_products_table").before('<%= j notice_window(@notice) %>')
$('#install_feature_products_form').html('<%= j render "admin/install_feature_products/form", product: @install_feature_product.product %>')
$(".select2").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)
setTimeout(
  -> $('.notice_window').slideUp()
  3000
)