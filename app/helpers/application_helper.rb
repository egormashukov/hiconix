#encoding: utf-8

module ApplicationHelper


  def show_tree(items, typee)
    html = ""
    html << "<ol#{" class='sortable'"}>"

    items.select{|item| item.ancestry == nil}.each do |i|
      html << children(i, items, typee)
    end

    html << "</ol>"

    return raw(html)
  end


  def children(i, items, typee)
      html = ""
      html << "<li id=\"list_#{i.id}\">"
      html << "<div>"

      children_items = items.select{|cat| cat.ancestry.split('/').last.to_s == i.id.to_s if cat.ancestry.presence}.sort_by(&:position)

      if i.has_attribute?("visible")
        html << toggle_visible_link(i)
      end
      if typee == true
        html << "#{link_to i.title, [:edit, :admin, i], :class=>'title'}"
      end

      html << delete_link(i)
      html << "</div>"


      if children_items.presence
        html << "<ol>"
        children_items.each do |child|
          html << children(child, items, typee)
        end
        html << "</ol>"
      end
      html << "</li>"
      return html
  end

  def sort_tree(url, maxlevels)
    %Q{
      <script type="text/javascript">
        $(document).ready(function(){

          $('ol.sortable').nestedSortable({
            disableNesting: 'no-nest',
            forcePlaceholderSize: true,
            handle: 'div',
            helper: 'clone',
            items: 'li',
            maxLevels: #{maxlevels},
            opacity: .6,
            placeholder: 'placeholder',
            revert: 250,
            tabSize: 25,
            tolerance: 'pointer',
            toleranceElement: '> div',
            update: function(){
              var serialized = $('ol.sortable').nestedSortable('serialize');
              $.ajax({url: '#{url}', data: serialized, type: 'POST'});
            }
          });
        });
      </script>
    }.gsub(/[\n ]+/, ' ').strip.html_safe
  end

  def custom_multiple_sortable(obj_id, url)
    %Q{
      <script type="text/javascript">
        $(document).ready(function() {
          $("##{obj_id}").sortable( {
            placeholder: 'ui-sortable-placeholder',
            forcePlaceholderSize: true,
            dropOnEmpty: false,
            cursor: 'crosshair',
            opacity: 0.75,
            items: ".#{obj_id}-sort-item",
            handle: ".#{obj_id}-handler",
            scroll: true,
            update: function() {
              $.ajax( {
                type: 'post',
                data: $("##{obj_id}").sortable('serialize'),
                dataType: 'script',
                url: '#{url}'
                })
              }
            });
          });
      </script>
    }.gsub(/[\n ]+/, ' ').strip.html_safe
  end

  def new_toggle_visible_link(obj, field = :visible)
    link_to [:togglevisible, :admin, obj], class: 'togglevisible', remote: true, method: :patch do
      content_tag :i, '', class: "icon_large #{obj.try(field) == true ? 'icon-eye-open' : 'icon-eye-close not_work'}"
    end
  end

  def edit_header_with_path(title, pth)
    content_tag :div, class: 'row page_header' do
      content_tag(:div, link_to(t(:back), pth, class: 'btn-flat default'), class: 'col-md-2') + content_tag(:div, content_tag(:h2, title), class: 'col-md-10')
    end
  end

  def edit_header_with_back(title, _resource = nil)
    content_tag :div, class: 'row page_header' do
      content_tag(:div, link_to(t(:back), :back, class: 'btn-flat default'), class: 'col-md-2') + content_tag(:div, content_tag(:h2, title), class: 'col-md-10')
    end
  end

  def current_is_administrator?
    true
  end
end
