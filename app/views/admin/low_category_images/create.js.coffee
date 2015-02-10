<%- if @low_category_image.new_record? %>
alert("Failed to uploading")
<%-  else %>
$("#low_category_images").append("<%= j render(@low_category_image) %>")
<%-  end %>