module ApplicationHelper
	def get_color color
		content_tag :span, :style => "padding: 9px 50px 9px 0px;background-color: #{color};" do
			unless color.present?
				"No Color"
			end
		end
	end

  def semesters_select_tag(semesters)
    select_tag :semester_courses, options_for_select(semesters.map{|m| [m.name, m.name]}), class: "form-control"
  end

	def validation_errors_notifications(object)
    return '' if object.errors.empty?

    messages = object.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
      <div class="alert alert-danger alert-block"> <button type="button"
      class="close" data-dismiss="alert">x</button>
      #{messages}
      </div>
    HTML

    html.html_safe
  end
end
