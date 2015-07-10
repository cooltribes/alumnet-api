json.(history)

json.class history.class.name
json.history do
  if history.class.name == 'UserAction'
    json.user_action do
      json.id history.id
      json.value history.value
      json.generator_id history.generator_id
      json.generator_type history.generator_type
      json.created_at history.created_at
      json.updated_at history.updated_at
    end

    user = history.user
    json.user do
      json.id user.id
      json.name user.name
      json.avatar user.avatar.large.url
      json.last_experience user.last_experience.try(:name)
    end

    action = history.action
    json.action do
      json.id action.id
      json.name action.name
      json.description action.description
      json.status action.status
      json.value action.value
      json.created_at action.created_at
      json.updated_at action.updated_at
      json.key_name action.key_name
    end

    if action.key_name == 'accepted_invitation'
      invited_user = history.invited_user
      json.invited_user do
        json.id invited_user.id
        json.name invited_user.name
        json.avatar invited_user.avatar.large.url
        json.last_experience invited_user.last_experience.try(:name)
      end
    elsif action.key_name == 'request_approved'
      approved_user = history.approved_user
      json.approved_user do
        json.id approved_user.id
        json.name approved_user.name
        json.avatar approved_user.avatar.large.url
        json.last_experience approved_user.last_experience.try(:name)
      end
    end
  else
    json.user_prize do
      json.id history.id
      json.price history.price
      json.status history.status
      json.created_at history.created_at
      json.updated_at history.updated_at
      json.prize_type history.prize_type
      json.remaining_quantity history.remaining_quantity
    end

    user = history.user
    json.user do
      json.id user.id
      json.name user.name
      json.avatar user.avatar.large.url
      json.last_experience user.last_experience.try(:name)
    end

    prize = history.prize
    json.prize do
      json.id prize.id
      json.name prize.name
      json.description prize.description
      json.price prize.price
      json.status prize.status
      json.prize_type prize.prize_type
      json.created_at prize.created_at
      json.updated_at prize.updated_at
      json.quantity prize.quantity
    end
  end
end

