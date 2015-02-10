$("#content_<%=@content.id%>").find(".togglevisible i").first().toggleClass("not_work icon-eye-close").toggleClass("icon-eye-open")

$('#content_<%= @content.id %>').remove()
$("#contents_table").before('<%= j notice_window(@notice) %>')

setTimeout(
  -> $('.notice_window').slideUp()
  3000
)