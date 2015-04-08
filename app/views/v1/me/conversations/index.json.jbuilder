json.array! @conversations, partial: 'v1/me/conversations/conversation', as: :conversation, current_user: @current_user
