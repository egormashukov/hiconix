$("#attachment_join_<%=@attachment_join.id %>").remove();
$('#attachment_joins_form').html("<%= j render 'admin/attachment_joins/form', attachment_joins: @attachment_joins, attachmentable: @attachmentable %>");
$("#attachment_join_attachment_id").select2(
  width: '100%'
  placeholder: 'add attachment'
  allowClear: true
)
