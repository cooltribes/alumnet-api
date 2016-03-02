json.users @users, partial: 'user', as: :user, current_user: @current_user
json.totalRecords @users.total_count
