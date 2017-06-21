class SectionsController < ApplicationController
  def index
  end

  action_auth_level :show, :student
  def show
  end
end
