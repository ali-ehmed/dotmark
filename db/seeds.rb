# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = Administrations::AdminService.new.call
puts 'CREATED SUPER ADMIN USER: ' << admin.email

puts 'CREATING BATCHES'
current_year = Date.today.year
last_five_years = current_year - 5

(last_five_years..current_year).each do |batch|
	first_year = batch
	final_year = first_year + 3
	Batch.find_or_create_by!(:name => "#{first_year.to_s}-#{final_year.to_s}") do |batch|
		batch.start_date = "#{first_year.to_s}-01-01"
		batch.end_date = "#{final_year.to_s}-12-25"
	end
	first_year = 0
end

puts 'CREATING CLASSROOMS & CREATING SEMESTERS'

(1..8).each do |number|
	Classroom.find_or_create_by!(:name => "HS-#{'%02d' % number}") do |classroom|
		if classroom == 5
			classroom.strength = "60"
			classroom.type_of_room = "Lab"
		elsif classroom == 6
			classroom.strength = "60"
			classroom.type_of_room = "Lab"
		else
			classroom.strength = "45"
			classroom.type_of_room = "Classroom"	
		end
	end
	Semester.find_or_create_by!(name: "#{number.ordinalize} Semester")
end

puts 'CREATING WEEKDAYS'
%w(Monday Tuesday Wednesday Thursday Friday).each do |day|
	WeekDay.find_or_create_by!(name: "#{day}")
end

puts 'CREATING TIMINGS FOR NORMAL DAYS'
Timing.find_or_create_by!(start_time: "08:30", end_time: "09:20", week_day_type: "Normal Day")
Timing.find_or_create_by!(start_time: "09:20", end_time: "10:10", week_day_type: "Normal Day")
Timing.find_or_create_by!(start_time: "10:10", end_time: "11:00", week_day_type: "Normal Day")
Timing.find_or_create_by!(start_time: "11:00", end_time: "11:50", week_day_type: "Normal Day")
Timing.find_or_create_by!(start_time: "13:40", end_time: "14:30", week_day_type: "Normal Day")
Timing.find_or_create_by!(start_time: "14:30", end_time: "15:20", week_day_type: "Normal Day")
Timing.find_or_create_by!(start_time: "15:20", end_time: "16:10", week_day_type: "Normal Day")
Timing.find_or_create_by!(start_time: "16:10", end_time: "17:00", week_day_type: "Normal Day")

puts 'CREATING TIMINGS FOR FRIDAYs'
Timing.find_or_create_by!(start_time: "08:30", end_time: "09:10", week_day_type: "FriDay")
Timing.find_or_create_by!(start_time: "09:10", end_time: "10:00", week_day_type: "FriDay")
Timing.find_or_create_by!(start_time: "10:00", end_time: "10:50", week_day_type: "FriDay")
Timing.find_or_create_by!(start_time: "10:50", end_time: "11:40", week_day_type: "FriDay")
Timing.find_or_create_by!(start_time: "11:40", end_time: "13:30", week_day_type: "FriDay")
Timing.find_or_create_by!(start_time: "14:30", end_time: "15:00", week_day_type: "FriDay")
Timing.find_or_create_by!(start_time: "15:00", end_time: "16:00", week_day_type: "FriDay")
Timing.find_or_create_by!(start_time: "16:00", end_time: "16:50", week_day_type: "FriDay")

puts "CREATING COURSES"

def create_by_lab_or_theory!(course_name, code, semester, lab_names = [])
	if lab_names.include?(course_name)
		# Creating Lab or Theory
		lab_names.each do |lab_name|
			if lab_name == course_name
				Course.find_or_create_by!(:name => course_name.split("_").join(" ")) do |course|
					course.code = "#{course_name.slice(0,2)}-#{'%03d' % code}"
					course.semester_id = semester.id
					course.lab = true
					Course.create(:name => course_name.split("_").join(" ")) do |course|
						course.code = "#{course_name.slice(0,2)}-#{'%03d' % (code + 1)}"
						course.semester_id = semester.id
					end
				end
			end
		end
	else
		# Creating Theory
		Course.find_or_create_by!(:name => course_name.split("_").join(" ")) do |course|
			course.code = "#{course_name.slice(0,2)}-#{'%03d' % code}"
			course.semester_id = semester.id
		end
	end
end

puts "First semester"
%w(Physics Calculas Communication_Skills ITCS).each_with_index do |course_name, code|
	code += 1
	create_by_lab_or_theory!(course_name, code, Semester.first_semester, ["ITCS"])
end

puts "Second semester"
%w(Web_Engineering Islamiat Programming_Fundamentals).each_with_index do |course_name, code|
	code += 1
	labs = ["Programming_Fundamentals", "Web_Engineering"]
	create_by_lab_or_theory!(course_name, code, Semester.second_semester, labs)
end

puts "Third semester"
%w(OOP LDST Data_Structures Stats).each_with_index do |course_name, code|
	code += 1
	labs = ["OOP", "LDST", "Data_Structures"]
	create_by_lab_or_theory!(course_name, code, Semester.third_semester, labs)
end

puts "Fourth semester"
%w(Operating_System Auto_Meta Computer_Archietecture).each_with_index do |course_name, code|
	code += 1
	labs = ["Operating_System", "LDST"]
	create_by_lab_or_theory!(course_name, code, Semester.fourth_semester, labs)
end

puts "Fifth semester"
%w(MIPS Computer_Networking Compiler_Construction RDBMS).each_with_index do |course_name, code|
	code += 1
	labs = ["Computer_Networking"]
	create_by_lab_or_theory!(course_name, code, Semester.fifth_semester, labs)
end

puts "Sixth semester"
%w(OR SW Computer_Security).each_with_index do |course_name, code|
	code += 1
	labs = ["Computer_Security"]
	create_by_lab_or_theory!(course_name, code, Semester.sixth_semester, labs)
end

