class CompetencesController < ApplicationController
  load_and_authorize_resource
  def index
    @competences = Competence.all

    respond_to do |format|
      format.html # index.html.erb
      format.nt  { render :inline => @competences.to_nt }
    end
  end

  def show
    @competence = Competence.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.nt  { render :inline => @competence.to_nt }
    end
  end

  def new
    @competence = Competence.new
  end

  def edit
    @competence = Competence.find(params[:id])
  end

  def create
    respond_to do |format|
      if @competence=Competence.create(params[:competence])
        format.html { redirect_to(@competence, :notice => t("competences.created")) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @competence = Competence.find(params[:id])

    respond_to do |format|
      if @competence.update! params[:competence]
        format.html { redirect_to(@competence, :notice => t("competences.updated")) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @competence = Competence.find(params[:id])
    @competence.destroy
    redirect_to(competences_url, :notice => t("competences.destroyed"))
  end
end

