class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.string :name
      t.integer :course_id
      t.timestamp :start
      t.timestamp :end
    end
  end

  def self.down
    drop_table :sections
  end
end
