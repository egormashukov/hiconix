<%- if @content_image.new_record? %>
alert("Failed to uploading")
<%-  else %>
$("#content_images").append("<%= j render(@content_image) %>")
<%-  end %>