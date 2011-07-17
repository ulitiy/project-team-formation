class TasksController < ApplicationController

  def show
    @task = Task.find(params[:id])
    @project=@task.project
    @candidates=@task.find_candidates
    return
    respond_to do |format|
      format.html
      format.nt  { render :inline => @task.to_nt }
    end
  end

  def new
    @project=Project.find(params[:project_id])
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
    @project=@task.project
  end

  def create
    Task.lock
    @task=Task.new_subject
    #приписываем проект к данному заданию
    @task.project=Project.find params[:project_id]
    @project=@task.project
    @task.update!(params[:task])
    if @task.save
      redirect_to(project_task_url(@project,@task), :notice => t('tasks.created'))
    else
      render :action => "new"
    end
    Task.unlock
  end

  def update
    @task = Task.find(params[:id])

    @project=@task.project
    if @task.update!(params[:task])
      redirect_to(project_task_url(@project,@task), :notice => t('tasks.updated'))
    else
      render :action => "edit"
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @project=@task.project
    @task.destroy
    redirect_to(@project, :notice => t('tasks.destroyed'))
  end

end
