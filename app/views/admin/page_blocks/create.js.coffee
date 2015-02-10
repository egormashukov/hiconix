<%- if @page_block.errors.any? %>
$("#page_blocks_table").before('<%= j error_window(@error_message) %> ')
<%- else %>
$("#page_blocks_table tbody").append('<%= j render @page_block %>')
$("#page_blocks_table").before('<%= j notice_window(@notice) %>')
<%- end %>
$('#page_blocks_form').html('<%= j render 'admin/page_blocks/form', page: @page_block.page %>')
$(".select2").select2(
  width: '100%'
  placeholder: 'выберите'
  allowClear: true
)
setTimeout(
  -> $('.notice_window').slideUp()
  3000
)
