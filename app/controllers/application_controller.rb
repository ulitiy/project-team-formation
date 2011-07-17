class ApplicationController < ActionController::Base
  protect_from_forgery

#если доступ запрещен
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = t "access_denied"
    if account_signed_in?
      redirect_to root_url
    else
      redirect_to new_account_session_url(:return_to=>request.path)
    end
  end

#возврат на ту страницу которую хотел посетить
  def after_sign_in_path_for resource
    params[:return_to] ? request.protocol+request.host_with_port+request.params[:return_to] : root_url
  end

  private

#переопределяем стандартное поведение Cancan
  def current_ability
    @current_ability ||= Ability.new(current_account)
  end
end

