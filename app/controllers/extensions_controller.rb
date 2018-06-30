##
# Extensions can be for a finite amount of time or infinite.
#
class ExtensionsController < ApplicationController
  # inherited from ApplicationController
  before_action :set_assessment
    rescue_from ActionView::MissingTemplate do |exception|
      redirect_to("/home/error_404")
  end

  # TODO
  action_auth_level :index, :instructor
  def index
    @extensions = @assessment.extensions.includes(:course_user_datum)
    @users = {}
    @course.course_user_data.each do |cud|
      @users[cud.email] = cud.id
    end
    @new_extension = @assessment.extensions.new
  end

  action_auth_level :create, :instructor
  def create
    if !extension_params[:section_id].empty? && !extension_params[:course_user_datum_id].empty?
      flash[:error] = "Please select section or student but not both"
      redirect_to(action: :index) && return
    end
    # Do some verifications to make sure an instructor of one course is not
    # giving themselves an extension in another course!
    if extension_params[:section_id].empty?

      begin
        @course.course_user_data.find(extension_params[:course_user_datum_id])
      rescue
        flash[:error] = "No student with id #{extension_params[:course_user_datum_id]}
          was found for this course."
        redirect_to(action: :index) && return
      end

    end

    # Verify that the section id blongs to the current course.
    if extension_params[:course_user_datum_id].empty?
      begin
        @course.sections.find(extension_params[:section_id])
      rescue
        flash[:error] = "No section with id #{extension_params[:section_id]}
          was found for this course."
        redirect_to(action: :index) && return
      end
    end

    e_params = extension_params
    e_params[:due_at] = DateTime.parse(e_params[:due_at]).strftime("%s")
    ext = @assessment.extensions.create(e_params)
    if ext.errors.messages.blank?
      redirect_to(action: :index) && return
    else
      redirect_to(action: :index, errors: ext.errors.full_messages) && return
    end
  end

  action_auth_level :destroy, :instructor
  def destroy
    extension = @assessment.extensions.find(params[:id])
    extension.destroy
    redirect_to(action: :index) && return
  end

private

  def extension_params
    params.require(:extension).permit(:course_user_datum_id, :due_at, :infinite,
                                      :commit, :course_id, :assessment_id, :section_id)
  end
end
