$('#type_category_catalogue_brand_link_<%= @type_category_catalogue_brand_link.id %>').remove()
$("#type_category_catalogue_brand_links_table").before('<%= j notice_window(@notice) %>')
$('#type_category_catalogue_brand_links_form').html('<%= j render "admin/type_category_catalogue_brand_links/form", type_category: @type_category_catalogue_brand_link.type_category %>')
$(".select2").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)
setTimeout(
  -> $('.notice_window').slideUp()
  3000
)