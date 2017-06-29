class CreateSectionUserData < ActiveRecord::Migration
  def self.up
    create_table :section_user_data do |t|
      t.integer :section_id
      t.integer :course_user_datum_id
      t.integer :assessment_id
      t.timestamp :due_date
    end
  end

  def self.down
    drop_table :section_user_data
  end
end
