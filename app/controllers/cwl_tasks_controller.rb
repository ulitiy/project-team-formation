class CwlTasksController < ApplicationController

  def new
    @task = Task.find(params[:task_id])
    @project=@task.project
    @competences=Competence.all
    @levels=CompetenceLevel.all
    @ccwl=CompetenceWithLevel.new
  end

  def show
    @cwl = CompetenceWithLevel.find(params[:id])

    respond_to do |format|
      format.nt  { render :inline => @cwl.to_nt }
    end
  end

  def create
    @task=Task.find(params[:task_id])
    @project=@task.project
    #исправление поведения формы с Spira
    @competence=Competence.find(params[:competence_with_level][:competence])
    @level=CompetenceLevel.find(params[:competence_with_level][:level])
    #добавляем компетенцию к task
    @task.add_competence! @competence, @level #не учитывается валидация. Но ее и нет собственно.
    redirect_to [@project,@task], :notice => t('cwl_tasks.created')
  end

  def edit
    @task=Task.find(params[:task_id])
    @project=@task.project
    @ccwl=CompetenceWithLevel.find(params[:id])
    @competences=Competence.all
    @levels=CompetenceLevel.all
    #небольшой хак для формы
    @ccwl.competence=@ccwl.competence.id
    @ccwl.level=@ccwl.level.id
  end

  def update
    @task=Task.find(params[:task_id])
    @project=@task.project
    @ccwl=CompetenceWithLevel.find(params[:id])
    #исправление поведения формы с Spira
    @ccwl.competence=Competence.find(params[:competence_with_level][:competence])
    @ccwl.level=CompetenceLevel.find(params[:competence_with_level][:level])
    @ccwl.save
    redirect_to [@project,@task], :notice => t('cwl_tasks.updated')
  end

  def destroy
    @task=Task.find(params[:task_id])
    @project=@task.project
    @ccwl=CompetenceWithLevel.find params[:id]
    #сохраняем целостность с task
    @task.remove_competence! @ccwl
    redirect_to [@project,@task], :notice => t('cwl_tasks.destroyed')
  end

end
