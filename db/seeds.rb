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

puts 'CREATING TIMINGS SLOTS'
@start_range = DateTime.parse("08:30")
@end_range = DateTime.parse("15:10")
@slots = Array.new

%w(Monday Tuesday Wednesday Thursday).each do |day|
	Range.new(@start_range.to_i, @end_range.to_i).step(50.minutes) do |hour|
		start_time = hour
		end_time = hour + 50.minutes
		
		puts "#{day} ---> Start Time: #{Time.zone.at(start_time)} <---> End Time: #{Time.zone.at(end_time)}"

	  TimeSlot.find_or_create_by!(start_time: Time.zone.at(start_time), end_time: Time.zone.at(end_time), week_day: day)
	end
end
%w(Friday).each do |day|
	Range.new(@start_range.to_i, @end_range.to_i).step(45.minutes) do |hour|
		start_time = hour
		end_time = hour + 45.minutes

		# Mid Break in University Timings
		if Time.zone.at(start_time) >= Time.zone.at("13:00".to_datetime.to_i)
			hour += (1.hour + 30.minutes)
			start_time = hour
			end_time = hour + 45.minutes
		end

		puts "#{day} ---> Start Time: #{Time.zone.at(start_time)} <---> End Time: #{Time.zone.at(end_time)}"

	  TimeSlot.find_or_create_by!(start_time: Time.zone.at(start_time), end_time: Time.zone.at(end_time), week_day: day)
	end
end

puts "CREATING COURSES"

def generate_credit_hours!(hours)
	case hours
	when "4"
		"2 2".split(" ")
	when "3"
		"2 1".split(" ")
	when "2"
		"1 1".split(" ")
	when "1"
		"1 0".split(" ")
	end
end

def create_by_lab_or_theory!(course_name, code, semester, lab_names = [])
	if lab_names.include?(course_name[0])
		for lab_name in lab_names
			if lab_name == course_name[0]
				# Creating Lab
				Course.find_or_create_by!(:name => course_name[0].split("_").join(" ")) do |course|
					course.code = "#{course_name[0].slice(0,2)}-#{'%03d' % code}"
					course.semester_id = semester.id
					course.lab = true
					course.credit_hours = generate_credit_hours!(course_name[1]).second

					# Creating Theory
					Course.create(:name => course_name[0].split("_").join(" ")) do |course|
						course.code = "#{course_name[0].slice(0,2)}-#{'%03d' % (code + 1)}"
						course.semester_id = semester.id
						course.credit_hours = generate_credit_hours!(course_name[1]).first
					end
				end
			end
		end
	else
		# Creating Theory
		Course.find_or_create_by!(:name => course_name[0].split("_").join(" ")) do |course|
			course.code = "#{course_name[0].slice(0,2)}-#{'%03d' % code}"
			course.semester_id = semester.id
			course.credit_hours = course_name[1]
		end
	end
end

puts "First semester"
%w(Physics 2 Calculas 3 Communication_Skills 3 ITCS 4).in_groups(4).each_with_index do |course_name, code|
	code += 1
	labs = ["Physics", "ITCS"]
	create_by_lab_or_theory!(course_name, code, Semester.first_semester, labs)
end

puts "Second semester"
%w(Web_Engineering 4 Islamiat 1 Programming_Fundamentals 3).in_groups(3).each_with_index do |course_name, code|
	code += 1
	labs = ["Programming_Fundamentals", "Web_Engineering"]
	create_by_lab_or_theory!(course_name, code, Semester.second_semester, labs)
end

puts "Third semester"
%w(OOP 3 LDST 2 Data_Structures 3 Stats 2).in_groups(4).each_with_index do |course_name, code|
	code += 1
	labs = ["OOP", "LDST", "Data_Structures"]
	create_by_lab_or_theory!(course_name, code, Semester.third_semester, labs)
end

puts "Fourth semester"
%w(Operating_System 3 Auto_Meta 2 Computer_Archietecture 2).in_groups(3).each_with_index do |course_name, code|
	code += 1
	labs = ["Operating_System", "LDST"]
	create_by_lab_or_theory!(course_name, code, Semester.fourth_semester, labs)
end

puts "Fifth semester"
%w(MIPS 3 Computer_Networking 3 Compiler_Construction 2 RDBMS 4).in_groups(4).each_with_index do |course_name, code|
	code += 1
	labs = ["Computer_Networking"]
	create_by_lab_or_theory!(course_name, code, Semester.fifth_semester, labs)
end

puts "Sixth semester"
%w(OR 3 SW 4 Computer_Security 3).in_groups(3).each_with_index do |course_name, code|
	code += 1
	labs = ["Computer_Security"]
	create_by_lab_or_theory!(course_name, code, Semester.sixth_semester, labs)
end



module UrlSeed
  if Rails.env.development?
		Rails.application.routes.default_url_options[:host] = 'lvh.me:3000'
	end
end

class TeacherSeed
  prepend UrlSeed
  @@teachers = Array.new

  def create
    puts "Creating Teachers #{dummy_teachers.length}"

    @@teachers.each do |attribute|
			Teacher.find_or_create_by!(:email => attribute[:email]) do |teacher|
				teacher.full_name = attribute[:name]
		    teacher.gender = attribute[:gender]
		    teacher.date_of_birth = attribute[:date_of_birth]
		    teacher.joining_date = attribute[:joining_date]
		  	teacher.username = attribute[:email].split("@").first if teacher.username.blank?
				teacher.confirm!
		  end

			teacher = Teacher.find_by(email: attribute[:email])
		  teacher.password = "aliahmed"
			teacher.password_confirmation = "aliahmed"
			teacher.save!
		end
  end

  private

  def dummy_teachers
		@@teachers = [{
		  name: "Uzair Ishaq", email: "uishaq@gmail.com", gender: "Male", date_of_birth: "Jan 15, 2016", joining_date: "Jan 12, 2016"
		}, {
			name: "Faisal Iqbal", email: "fiqbal@gmail.com", gender: "Male", date_of_birth: "Jan 15, 2016", joining_date: "Jan 12, 2016"
		}, {
			name: "Waleej Haider", email: "whaider@gmail.com", gender: "Male", date_of_birth: "Jan 15, 2016", joining_date: "Jan 12, 2016"
		}, {
			name: "Junaid Hasan", email: "jhasan@gmail.com", gender: "Male", date_of_birth: "Jan 15, 2016", joining_date: "Jan 12, 2016"
		}, {
			name: "Sana Sohail", email: "ssohail@gmail.com", gender: "Female", date_of_birth: "Jan 15, 2016", joining_date: "Jan 12, 2016"
		}, {
			name: "Aqsa Siddique", email: "asiddique@gmail.com", gender: "Female", date_of_birth: "Jan 15, 2016", joining_date: "Jan 12, 2016"
		}, {
			name: "Seher Jawaid", email: "sjawaid@gmail.com", gender: "Female", date_of_birth: "Jan 15, 2016", joining_date: "Jan 12, 2016"
		}, {
			name: "Sallar Khan", email: "skhan@gmail.com", gender: "Male", date_of_birth: "Jan 15, 2016", joining_date: "Jan 12, 2016"
		}, {
			name: "Sabeen Khan", email: "sabeenkhan@gmail.com", gender: "Female", date_of_birth: "Jan 15, 2016", joining_date: "Jan 12, 2016"
		}, {
			name: "Asif Ahmed", email: "aahmed@gmail.com", gender: "Male", date_of_birth: "Jan 15, 2016", joining_date: "Jan 12, 2016"
		}, {
			name: "Kashan Ajmal", email: "kajmal@gmail.com", gender: "Male", date_of_birth: "Jan 15, 2016", joining_date: "Jan 12, 2016"
		}, {
			name: "Sarmad Sabih", email: "ssabih@gmail.com", gender: "Male", date_of_birth: "Jan 15, 2016", joining_date: "Jan 12, 2016"
		}]
  end
end

TeacherSeed.new.create()

