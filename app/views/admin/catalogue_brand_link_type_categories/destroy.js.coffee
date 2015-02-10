$('#catalogue_brand_link_type_category_<%= @catalogue_brand_link_type_category.id %>').remove()
$("#catalogue_brand_link_type_categories_table").before('<%= j notice_window(@notice) %>')
$('#catalogue_brand_link_type_categories_form').html('<%= j render "admin/catalogue_brand_link_type_categories/form", brand: @catalogue_brand_link_type_category.catalogue_brand_link %>')
$(".select2").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)
setTimeout(
  -> $('.notice_window').slideUp()
  3000
)