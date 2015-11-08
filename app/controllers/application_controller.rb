class ApplicationController < ActionController::Base
  include Pundit

  before_filter :configure_permitted_parameters, if: :devise_controller?

  after_action :verify_authorized, except: [:index], unless: :devise_controller?
  after_action :verify_policy_scoped, only: [:index], unless: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :fullname
    devise_parameter_sanitizer.for(:sign_up) << :username
  end

  # Used by Devise
  def after_sign_in_path_for(user)
    # return the path based on resource
    if user.admin?
      admin_root_path
    elsif user.worker?
      worker_root_path
    elsif user.customer?
      customer_root_path
    else
      root_path
    end
  end

  private

    def not_authorized
      redirect_to root_path, alert: "Sorry, but you are not allowed to do that."
    end
end
