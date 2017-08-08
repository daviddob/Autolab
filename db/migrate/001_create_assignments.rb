class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.timestamp :due_date
      t.timestamp :submit_until
      t.timestamp :visable_until
      t.timestamp :available_date
      t.string :name
      t.text :description
      t.timestamps
    end
    self.sectionsAdditions
  end

  def self.down
    drop_table :assignments
  end

  def self.sectionsAdditions
    add_column :assessments, :base_section_day, :date, default: nil
    add_column :assessments, :start_offset, :integer, default: 0
    add_column :assessments, :end_offset, :integer, default: 0
    add_column :assessments, :on_day, :boolean, default: false
    add_column :assessments, :lecture, :boolean, default: false
  end
end
