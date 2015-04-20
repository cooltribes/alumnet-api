class V1::AdminController < ApplicationController
  before_action :check_admin_user
  before_action :set_admin_location

  private
    def check_admin_user
      unless current_user.is_admin?
        head :no_content, status: 204
      end
    end

    def set_admin_location
      if current_user.is_nacional_admin? || current_user.is_regional_admin?
        @admin_location = current_user.admin_location
      end
    end
end
