$('#page_block_<%= @page_block.id %>').remove()
$("#page_blocks_table").before('<%= j notice_window(@notice) %>')
$('#page_blocks_form').html('<%= j render "admin/page_blocks/form", page: @page_block.page %>')
$(".select2").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)
setTimeout(
  -> $('.notice_window').slideUp()
  3000
)