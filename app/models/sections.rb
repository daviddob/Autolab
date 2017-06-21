class Sections < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :name, :course_id,:start, :end 
 
end
