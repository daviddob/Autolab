class SectionsController < ApplicationController

	@@days_lookup = {"0" => '2016-05-01',"1" => '2016-05-02',"2" => '2016-05-03',"3" => '2016-05-04',"4" => '2016-05-05',"5" => '2016-05-06',"6" => '2016-05-07'}
  def index
  end

  action_auth_level :show, :instructor
  def show
  	
  end

   def create
    # check for permission
    unless current_user.administrator?
      flash[:error] = "Permission denied."
      redirect_to(course_assessments_path) && return
    end
    data = params["sections"]
    if(Sections.where("course_id = ? && name = ?", @course.id, data["name"]).exists?)
    	 flash[:error] = "not implemented"
    	 redirect_to(course_sections_path) && return
    end
    @new_section = Sections.new
    @new_section.name = data["name"]
    @new_section.course_id = @course.id
    @new_section.start = @@days_lookup[data["day"]] + " " + data["start time"] + ":00"
    @new_section.end = @@days_lookup[data["day"]] + " " + data["end time"] + ":00"
    @new_section.save





    flash[:success] = "saved"
    redirect_to(course_sections_path) && return
	end

	def manage
	end

end
