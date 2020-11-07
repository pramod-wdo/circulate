require "active_support/testing/time_helpers"

module Admin
  class BaseController < ApplicationController
    include ActiveSupport::Testing::TimeHelpers

    before_action :authenticate_user!
    before_action :require_staff
    around_action :override_time_in_development, if: -> { Rails.env.development? }

    layout "admin"

    private

    def override_time_in_development(&block)
      if session[:time_override]
        travel_to session[:time_override] do
          yield
        end
      else
        yield
      end
    end

    def require_staff
      unless current_user.roles.include?(:staff)
        redirect_to root_url, warning: "You do not have access to that page."
      end
    end

    def require_admin
      unless current_user.roles.include?(:admin)
        redirect_to root_url, warning: "You do not have access to that page."
      end
    end
  end
end
