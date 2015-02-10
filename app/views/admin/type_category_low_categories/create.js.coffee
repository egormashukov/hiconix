<%- if @type_category_low_category.errors.any? %>
$("#type_category_low_categories_table").before('<%= j error_window(@error_message) %> ')
<%- else %>
$("#type_category_low_categories_table tbody").append('<%= j render @type_category_low_category %>')
$("#type_category_low_categories_table").before('<%= j notice_window(@notice) %>')
<%- end %>
$('#type_category_low_categories_form').html('<%= j render 'admin/type_category_low_categories/form', low_category: @type_category_low_category.low_category %>')
$(".select2").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)
setTimeout(
  -> $('.notice_window').slideUp()
  3000
)
