json.array! @employees, partial: 'employee', as: :user, locals: { company: @company, current_user: @current_user }
