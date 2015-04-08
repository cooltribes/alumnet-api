class V1::AdminController < ApplicationController
  before_action :check_admin_user

  private
    def check_admin_user
      unless current_user.is_system_admin? || current_user.is_alumnet_admin?
        head :no_content, status: 204
      end
    end
end
