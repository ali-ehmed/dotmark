# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = Admins::AdminService.new.call
puts 'CREATED ADMIN USER: ' << admin.email

puts 'CREATING BATCHES'
Batch.find_or_create_by!(:name => "2010-2013") do |batch|
	batch.start_date = "2010-01-01"
	batch.end_date = "2013-12-25"
end
Batch.find_or_create_by!(:name => "2011-2014") do |batch|
	batch.start_date = "2011-01-01"
	batch.end_date = "2014-12-25"
end
Batch.find_or_create_by!(:name => "2012-2015") do |batch|
	batch.start_date = "2012-01-01"
	batch.end_date = "2015-12-25"
end
Batch.find_or_create_by!(:name => "2013-2016") do |batch|
	batch.start_date = "2013-01-01"
	batch.end_date = "2016-12-25"
end

puts 'CREATING CLASSROOMS'
Classroom.find_or_create_by!(:name => "HS-01") do |classroom|
	classroom.strength = "45"
	classroom.type_of_room = "Classroom"
end
Classroom.find_or_create_by!(:name => "HS-02") do |classroom|
	classroom.strength = "45"
	classroom.type_of_room = "Classroom"
end
Classroom.find_or_create_by!(:name => "HS-03") do |classroom|
	classroom.strength = "45"
	classroom.type_of_room = "Classroom"
end
Classroom.find_or_create_by!(:name => "HS-04") do |classroom|
	classroom.strength = "45"
	classroom.type_of_room = "Classroom"
end
Classroom.find_or_create_by!(:name => "HS-05") do |classroom|
	classroom.strength = "45"
	classroom.type_of_room = "Classroom"
end
Classroom.find_or_create_by!(:name => "HS-06") do |classroom|
	classroom.strength = "45"
	classroom.type_of_room = "Classroom"
end
Classroom.find_or_create_by!(:name => "HS-07") do |classroom|
	classroom.strength = "60"
	classroom.type_of_room = "Lab"
end
Classroom.find_or_create_by!(:name => "HS-08") do |classroom|
	classroom.strength = "60"
	classroom.type_of_room = "Lab"
end

puts 'CREATING SEMESTERS'
Semester.find_or_create_by!(name: "1st Semester")
Semester.find_or_create_by!(name: "2nd Semester")
Semester.find_or_create_by!(name: "3rd Semester")
Semester.find_or_create_by!(name: "4th Semester")
Semester.find_or_create_by!(name: "5th Semester")
Semester.find_or_create_by!(name: "6th Semester")
Semester.find_or_create_by!(name: "7th Semester")
Semester.find_or_create_by!(name: "8th Semester")