<% if params[:batch_id].present? %>
	var legend = "<small class=\"legend\"></small>"
	if(!$("#allocation_semester_name").find(".legend").length) {
		$("#allocation_semester_name").append(legend)
	}
	if(!$("#allocation_batch_name").find(".legend").length) {
		$("#allocation_batch_name").append(legend)
	}
	$(".legend").html("<%= @courses.first[:semester] %> (<%= @courses.first[:batch] %>)")

	$(".allocation_courses").hide().html("<%= escape_javascript(render 'courses') %>").fadeIn(500)

	$(".allocation_sections").hide().html("<%= escape_javascript(render 'listing_sections') %>").fadeIn(300);

	// List Items Checkbox
	check_box_list();

	<% @sections.each do |section| %>
		<% if section[:has_section] == true %>
			var $list = $("ul[data-type='sections']").find("li[data-section-id='<%= section[:id] %>']")
			$list.addClass("list-group-item-primary list-active")
			$list.find("span").removeClass("glyphicon-unchecked")
			$list.find("span").addClass("glyphicon-check")
			$list.find("input[type='checkbox']").attr("checked", "checked")
		<% end %>
	<% end %>

<% end %>