class AddSectionToCourseAllocations < ActiveRecord::Migration
  def change
    add_column :course_allocations, :section_id, :integer

    # Rails::Generators.invoke("annotate", "--exclude fixtures")
  end
end
