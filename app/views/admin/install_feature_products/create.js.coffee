<%- if @install_feature_product.errors.any? %>
$("#install_feature_products_table").before('<%= j error_window(@error_message) %> ')
<%- else %>
$("#install_feature_products_table tbody").append('<%= j render @install_feature_product %>')
$("#install_feature_products_table").before('<%= j notice_window(@notice) %>')
<%- end %>
$('#install_feature_products_form').html('<%= j render 'admin/install_feature_products/form', product: @install_feature_product.product %>')
$(".select2").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)
setTimeout(
  -> $('.notice_window').slideUp()
  3000
)
