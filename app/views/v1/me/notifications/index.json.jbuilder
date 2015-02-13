json.array! @notifications, partial: 'v1/me/notifications/notification', as: :notification, current_user: @current_user
