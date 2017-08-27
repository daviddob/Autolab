class AddGraderToSubmission < ActiveRecord::Migration
    def up
        add_column :submissions, :grader, :string, default: "Unassigned"
    end
    
    def down
        remove_column :submissions, :grader
    end
end
