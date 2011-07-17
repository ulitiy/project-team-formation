class PeopleController < ApplicationController
  load_and_authorize_resource

  def index
    @people=Person.all #сделать пейджинг
  end

  def show
#в айдишнике получаем локальный адрес ресурса, который преобразуется к его обычному адресу и достается из БЗ
    @person=Person.find params[:id]
    respond_to do |format|
      format.html
      format.nt {render :inline=>@person.to_nt(:except=>:account_id)} #исключаем из отображения идентификатор аккаунта
    end
  end

  def edit
    @person=Person.find params[:id]
  end

  def update
    @person=Person.find params[:id]
    @person.email=params[:person][:email]
    if @person.update! params[:person]
      redirect_to(@person, :notice => t("people.updated"))
    else
      render :action => "edit"
    end
  end

  def create
    @person=Person.new_subject
    @person.email=params[:person][:email]
    if @person=@person.update!(params[:person])
      redirect_to(@person, :notice => t("people.created"))
    else
      render :action => "new"
    end
  end

end

