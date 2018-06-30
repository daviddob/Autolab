class Extension < ActiveRecord::Base
  belongs_to :assessment
  belongs_to :course_user_datum
  validate :days_or_infinite
  validates_uniqueness_of :course_user_datum_id, scope: :assessment_id, message: "already has an extension." , :allow_blank => true
  validates_uniqueness_of :section_id, scope: :assessment_id, message: "already has an extension.", :allow_blank => true


  after_save :invalidate_cgdubs_for_assessments_after
  after_destroy :invalidate_cgdubs_for_assessments_after,:after_destroy_log
  after_create :after_create_log

  def days_or_infinite
    if due_at.blank? && !infinite?
      errors.add(:base, "Please enter new due date of extension, or mark as infinite.")
    end
  end

  def invalidate_cgdubs_for_assessments_after
    if !course_user_datum_id.nil?
      assessment.aud_for(course_user_datum_id).invalidate_cgdubs_for_assessments_after
    end
  end

  def after_create_log
    if self.infinite?
      COURSE_LOGGER.log("Extension #{id}: CREATED for " \
      "#{(course_user_datum.nil?)? self.assessment.course.sections.find(self.section_id).name : course_user_datum.user.email} on" \
      " #{assessment.name} for unlimited days")
    else
      COURSE_LOGGER.log("Extension #{id}: CREATED for " \
      "#{(course_user_datum.nil?)? self.assessment.course.sections.find(self.section_id).name : course_user_datum.user.email} on" \
      " #{assessment.name} which is now due at #{due_at}")
    end
  end

  def after_destroy_log
    COURSE_LOGGER.log("Extension #{id}: DESTROYED for " \
    "#{(course_user_datum.nil?)? self.assessment.course.sections.find(self.section_id).name : course_user_datum.user.email} on" \
      " #{assessment.name}")
  end
end
