class CwlPeopleController < ApplicationController

  def new
    @person = Person.find(params[:person_id])
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
    @person=Person.find(params[:person_id])
    #исправление поведения формы с Spira
    @competence=Competence.find(params[:competence_with_level][:competence])
    @level=CompetenceLevel.find(params[:competence_with_level][:level])
    #добавляем компетенцию к person
    @person.add_competence! @competence, @level #не учитывается валидация. Но ее и нет собственно.
    redirect_to @person, :notice => t('cwl_people.created')
  end

  def edit
    @person=Person.find(params[:person_id])
    @ccwl=CompetenceWithLevel.find(params[:id])
    @competences=Competence.all
    @levels=CompetenceLevel.all
    #небольшой хак для формы
    @ccwl.competence=@ccwl.competence.id
    @ccwl.level=@ccwl.level.id
  end

  def update
    @person=Person.find(params[:person_id])
    @ccwl=CompetenceWithLevel.find(params[:id])
    #исправление поведения формы с Spira
    @ccwl.competence=Competence.find(params[:competence_with_level][:competence])
    @ccwl.level=CompetenceLevel.find(params[:competence_with_level][:level])
    @ccwl.save
    redirect_to @person, :notice => t('cwl_people.updated')
  end

  def destroy
    @person=Person.find(params[:person_id])
    @ccwl=CompetenceWithLevel.find params[:id]
    #сохраняем целостность с person
    @person.remove_competence! @ccwl
    redirect_to @person, :notice => t('cwl_people.destroyed')
  end

end
