class ChangeDaysToDueAt < ActiveRecord::Migration
  def up
  	rename_column :extensions, :days, :due_at
  end
end
