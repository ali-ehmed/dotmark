module ApplicationHelper
	def get_color object, event = false
    show_modal = if event == true then "$('#edit-color_#{object.id}').modal('show')" else "" end
		content_tag :span, id: "object_color_span_#{object.id}", onclick: show_modal, :style => "padding: 5px 22px 0px 0px;background-color: #{object.color};border-radius: 18px;" do
      if object.color.blank?
        content_tag :a, :href => "#" do
          "-"
        end
      end
		end
	end

  def navbar_image(resource)
    if resource.avatar.nil?
      $redis.del("user_avatar_#{resource.avatar.updated_at}")
    else
      image = $redis.get("user_avatar_#{resource.avatar.updated_at}")
      if image.nil?
        if resource.avatar.present? and resource.avatar.image.present?
          image = resource.avatar.image.url(:thumb).to_json
        else
          image = "user-avatar.png".to_json
        end
        $redis.set("user_avatar_#{resource.avatar.updated_at}", image)
      end
    end
    JSON.load image
  end

  def semesters_select_tag(semesters)
    select_tag :semester_courses, options_for_select(semesters.map{|m| [m.name, m.name]}), class: "form-control"
  end

  def batches_select_tag(batches, options = "")
    select_tag :batch_id, options_for_select(batches.map{|m| [m[:name], m[:id]]}), class: "form-control input-sm", prompt: "Choose Batch", onchange: "#{options}"
  end

  def courses_select_tag(courses, options = "")
    select_tag :course_id, options_for_select(courses.map{|m| [m.name, m.id]}), class: "form-control", prompt: "Choose Course", onchange: "#{options}"
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

  def grouped_batches_options batches
    batches.map do |batch|
      grouped_options = if batches.count > 1
                          ["#{batch["name"]}",
                            [["#{batch["semester"]}","#{batch["id"]}"]]
                          ]
                        else
                          ["#{batch}",
                            []
                          ]
                        end
    end
  end

  def head_title
    if current_resource_name.to_s == "admin"
      "Admin Panel"
    else
      @account["resource"]["username"]
    end
  end
end
