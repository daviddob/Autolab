class AddAssignCaToAssessment < ActiveRecord::Migration
    def up
        add_column :assessments, :assignCA, :boolean, default: false
    end
    
    def down
        remove_column :assessments, :assignCA
    end
end
