<%- if @type_category_catalogue_brand_link.errors.any? %>
$("#type_category_catalogue_brand_links_table").before('<%= j error_window(@error_message) %> ')
<%- else %>
$("#type_category_catalogue_brand_links_table tbody").append('<%= j render @type_category_catalogue_brand_link %>')
$("#type_category_catalogue_brand_links_table").before('<%= j notice_window(@notice) %>')
<%- end %>
$('#type_category_catalogue_brand_links_form').html('<%= j render 'admin/type_category_catalogue_brand_links/form', type_category: @type_category_catalogue_brand_link.type_category %>')
$(".select2").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)
setTimeout(
  -> $('.notice_window').slideUp()
  3000
)
