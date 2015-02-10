<%- if @install_feature_category.errors.any? %>
$("#install_feature_categories_table").before('<%= j error_window(@error_message) %> ')
<%- else %>
$("#install_feature_categories_table tbody").append('<%= j render @install_feature_category %>')
$("#install_feature_categories_table").before('<%= j notice_window(@notice) %>')
<%- end %>
$('#install_feature_categories_form').html('<%= j render 'admin/install_feature_categories/form', category: @install_feature_category.category %>')
$(".select2").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)
setTimeout(
  -> $('.notice_window').slideUp()
  3000
)
