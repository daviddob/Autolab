class AddPersonNumberToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :person_number, :int
  end

  def self.down
    remove_column :users, :person_number
  end
end