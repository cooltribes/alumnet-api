json.array! @user_subscriptions, partial: 'v1/shared/subscription', as: :user_subscription, current_user: @current_user