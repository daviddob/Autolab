class SectionUserDatum < ActiveRecord::Base
  belongs_to :section
  validates_presence_of :section_id, :course_user_datum_id
 
end
