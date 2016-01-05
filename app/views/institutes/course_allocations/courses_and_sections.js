<% if params[:batch_id].present? %>
	<% if params[:only_sections] == "true" %>
		$(".allocation_sections").hide().html("<%= escape_javascript(render 'listing_sections') %>").fadeIn(300);
	<% else %>
		var legend = "<small class=\"legend\"></small>"
		if(!$("#allocation_semester_name").find(".legend").length) {
			$("#allocation_semester_name").append(legend)
		}
		if(!$("#allocation_batch_name").find(".legend").length) {
			$("#allocation_batch_name").append(legend)
		}
		$(".legend").html("<%= @semester.name %> (<%= @batch.name %>)")

		$(".allocation_courses").hide().html("<%= escape_javascript(render 'courses') %>").fadeIn(500);
		$(".allocation_sections").hide().html("<%= escape_javascript(render 'listing_sections') %>").fadeIn(300);
	<% end %>

	// List Items Checkbox
	check_box_list();

	<% if @teacher.course_allocations.present? %>
		$("#remove_teacher_allocations").html("<a href='javascript:void(0);' class='btn btn-danger btn-sm' onclick='removeTeacherAllocations(<%= @teacher.id %>)'>Remove <%= @teacher.full_name %>'s Allocation</a>")
	<% end %>

	<% @sections.each do |section| %>
		var $list = $("ul[data-type='sections']").find("li[data-section-id='<%= section[:id] %>']")
		<% if section[:has_section] == true %>
			$list.addClass("list-group-item-primary list-active")
			$list.find("span").removeClass("glyphicon-unchecked")
			$list.find("span").addClass("glyphicon-check")
			$list.find("input[type='checkbox']").attr("checked", "checked")
		<% end %>
		<% if section[:is_already_assigned_section] == true %>
			$list.removeClass("list-active")
			$list.addClass("list-already-active")
			$list.attr("disabled", "disabled").off('click');
			$list.find("strong").append("(<%= section[:is_already_assigned_teacher] %>)")
		<% end %>
	<% end %>

<% end %>