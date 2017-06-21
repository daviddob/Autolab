class SectionsController < ApplicationController
  def index
  end

  action_auth_level :show, :student
  def show
  end

   def create
    # check for permission
    unless current_user.administrator?
      flash[:error] = "Permission denied."
      redirect_to(root_path) && return
    end

    @new_section = Section.new(new_section_params)
	end

	def manage
	end

end
