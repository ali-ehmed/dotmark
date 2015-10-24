module SectionsHelper
	def get_color color
		content_tag :span, :style => "padding: 9px 50px 9px 0px;background-color: #{color};" do
			unless color.present?
				"No Color"
			end
		end
	end	
end