class AddSectionToExtension < ActiveRecord::Migration
  def self.up
    add_column :extensions, :section_id, :int,:default => nil, :null => true
  end

  def self.down
    remove_column :extensions, :section_id
  end
end
