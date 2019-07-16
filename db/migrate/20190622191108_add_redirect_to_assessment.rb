class AddRedirectToAssessment < ActiveRecord::Migration
  def change
  	 add_column :assessments, :handin_redirect, :boolean
  end
end
