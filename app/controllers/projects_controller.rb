class ProjectsController < ApplicationController
  load_and_authorize_resource
  def index
    @projects = Project.all
  end

  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.nt  { render :inline => @project.to_nt }
    end
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    if @project=Project.create(params[:project])
      redirect_to(@project, :notice => t("projects.created"))
    else
      render :action => "new"
    end
  end

  def update
    @project = Project.find(params[:id])

    if @project.update! params[:project]
      redirect_to(@project, :notice => t("projects.updated"))
    else
      render :action => "edit"
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to(projects_url, :notice => t("projects.deleted"))
  end
end

