module ApplicationHelper
	def get_color color
		content_tag :span, :style => "padding: 5px 22px 0px 0px;background-color: #{color};border-radius: 18px;" do
		end
	end

  def semesters_select_tag(semesters)
    select_tag :semester_courses, options_for_select(semesters.map{|m| [m.name, m.name]}), class: "form-control"
  end

  def batches_select_tag(batches, options = "")
    select_tag :batch_id, options_for_select(batches.map{|m| [m[:name], m[:id]]}), class: "form-control input-sm", prompt: "Choose Batch", onchange: "#{options}"
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

  def ordinalize_word value
    case value.ordinalize
    when "1st"
      "FIRST"
    when "2nd"
      "SECOND"
    when "3rd"
      "THIRD"
    when "4th"
      "FOURTH"
    when "5th"
      "FIFTH"
    when "6th"
      "SIXTH"
    when "7th"
      "SEVENTH"
    when "8th"
      "EIGTH"
    when "9th"
      "NINTH"
    when "10th"
      "TENTH"
    end
  end
end
