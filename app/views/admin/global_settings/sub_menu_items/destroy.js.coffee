$('#sub_menu_item_<%= @sub_menu_item.id %>').remove()
$("#sub_menu_items_table").before('<%= j notice_window(@notice) %>')

setTimeout(
  -> $('.notice_window').slideUp()
  3000
)