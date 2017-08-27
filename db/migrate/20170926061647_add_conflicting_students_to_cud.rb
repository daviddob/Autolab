class AddConflictingStudentsToCud < ActiveRecord::Migration
    def up
        add_column :course_user_data, :conflictingstudents, :text
    end
    
    def down
        remove_column :course_user_data, :conflictingstudents
    end
end
