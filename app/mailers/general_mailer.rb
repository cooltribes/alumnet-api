require 'mandrill'
require 'base64'

class GeneralMailer
	def initialize
		@mandrill = Mandrill::API.new Settings.mandrill_api_key
		@subaccount = Settings.mandrill_subaccount

		@view = ActionView::Base.new('app/views/general_mailer', {},  ActionController::Base.new)
	end

	def approval_request_accepted(approver, requester)
		suggested_users = requester.suggested_users(3)
		suggested_groups = requester.suggested_groups(3)
		images = []
		images << {"type"=>approver.get_avatar_type, "name"=>"approver_avatar", "content"=>approver.get_avatar_base64}

		subject = "#{approver.name} gave you an Alumni verification"

		# build suggested friends if any suggestions
		main_content_html = @view.render(
			file: 'approval_request_accepted.html.erb', 
			locals: { 
				suggested_users: suggested_users,
				suggested_groups: suggested_groups
			}
		)
		suggested_users.each do |suggested_user|
			images << {"type"=>suggested_user.get_avatar_type, "name"=>"suggested_user_avatar_#{suggested_user.id}", "content"=>suggested_user.get_avatar_base64}
		end

		suggested_groups.each do |suggested_group|
			images << {"type"=>suggested_group.get_cover_type, "name"=>"suggested_group_cover_#{suggested_group.id}", "content"=>suggested_group.get_cover_base64}
		end

		template_name = "USR003_approval_request_accepted"
    template_content = [
    	{"name"=>"approver_name", "content"=>approver.name},
    	{"name"=>"welcome_link", "content"=>"<a href='#{Settings.ui_endpoint}/#posts' style='color: #FFF; padding: 12px 30px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>WELCOME ONBOARD!</a>"},
    	{"name"=>"join_us_link", "content"=>"<a href='#{Settings.ui_endpoint}/#posts' style='color: #FFF; padding: 12px 9px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>JOIN US IN THIS INCREDIBLE COMMUNITY</a>"},
    	{"name"=>"main_content", "content"=>main_content_html},
    	{"name"=>"manage_subscriptions_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{requester.id}/settings' style='text-decoration: underline; color: #3a3737; font-size: 11px; font-weight: 100;'>Manage Suscription</a>"},
    	{"name"=>"requester_name", "content"=>requester.name},
    	{"name"=>"requester_last_experience", "content"=>requester.full_last_experience}
    ]

    send_email(requester.email, requester.name, subject, images, template_name, template_content)
	end
	
	def friend_accept_friendship(friend, user)
		images = []
		images << {"type"=>user.get_avatar_type, "name"=>"user_avatar", "content"=>user.get_avatar_base64}

		subject = "#{user.name} accepted your friend request"
		suggested_users = friend.suggested_users(3)

		main_content_html = @view.render(
			file: 'friend_accept_friendship.html.erb', 
			locals: { 
				suggested_users: suggested_users
			}
		)

		if suggested_users.present?
			suggested_users.each do |suggested_user|
				images << {"type"=>suggested_user.get_avatar_type, "name"=>"suggested_user_avatar_#{suggested_user.id}", "content"=>suggested_user.get_avatar_base64}
			end
		end

		template_name = "USR006_accept_friendship_invitation"
    template_content = [
    	{"name"=>"alumnet_button", "content"=>"<a href='#{Settings.ui_endpoint}' style='color: #FFF; border: 1px solid #FFF; padding: 10px; text-decoration: none; font-family: sans-serif; font-size: 12px;'>GO TO ALUMNET</a>"},
    	{"name"=>"friend_name", "content"=>friend.name},
    	{"name"=>"user_name", "content"=>user.name},
    	{"name"=>"user_his_her", "content"=>user.profile.pronoun},
    	{"name"=>"user_he_she", "content"=>user.he_or_she},
    	{"name"=>"profile_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{user.id}/about' style='color: #FFF; padding: 12px 30px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>VIEW #{user.profile.first_name.upcase}\'S PROFILE</a>"},
    	{"name"=>"suggested_friends", "content"=>main_content_html},
    	{"name"=>"manage_subscriptions_link", "content"=>"<a href='#' style='text-decoration: underline; color: #3a3737; font-size: 11px; font-weight: 100;'> Manage Suscription </a>"},
    	{"name"=>"friend_last_experience", "content"=>friend.full_last_experience},
    	{"name"=>"manage_subscriptions_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{friend.id}/settings' style='text-decoration: underline; color: #3a3737; font-size: 11px; font-weight: 100;'>Manage Suscription</a>"}
    ]

    send_email(friend.email, friend.name, subject, images, template_name, template_content)
	end

	def invitation_to_alumnet(email, guest_name, user, token)
		images = []
		images << {"type"=>user.get_avatar_type, "name"=>"user_avatar", "content"=>user.get_avatar_base64}

		subject = "You’re invited to join AIESEC AlumNet"

		template_name = "USR039_invitation_to_alumnet"
    template_content = [
    	{"name"=>"alumnet_button", "content"=>"<a href='#{Settings.ui_endpoint}' style='color: #FFF; border: 1px solid #FFF; padding: 10px; text-decoration: none; font-family: sans-serif; font-size: 12px;'>GO TO ALUMNET</a>"},
    	{"name"=>"user_name", "content"=>user.name},
    	{"name"=>"reconnect_link", "content"=>"<a href='#{Settings.ui_endpoint}/home/?invitation_token=#{token}' style='color: #FFF; padding: 15px 40px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>RECONNECT WITH AIESEC ALUMNI</a>"},
    	{"name"=>"reconnect_link_footer", "content"=>"<a href='#{Settings.ui_endpoint}/home/?invitation_token=#{token}' style='color: #FFF; padding: 15px 40px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>REGISTER</a>"}
    ]

    send_email(email, guest_name, subject, images, template_name, template_content)
	end

	def user_request_approval(approver, requester)
		images = []
		images << {"type"=>requester.get_avatar_type, "name"=>"user_avatar", "content"=>requester.get_avatar_base64}
		subject = "Is #{requester.name} an AIESEC Alum you know?"

		template_name = "USR002_request_approval"
    template_content = [
    	{"name"=>"friend_name", "content"=>approver.name},
    	{"name"=>"user_name", "content"=>requester.name},
    	{"name"=>"user_last_experience", "content"=>requester.full_last_experience},
    	{"name"=>"user_location", "content"=>requester.first_committee},
    	{"name"=>"user_country", "content"=>requester.aiesec_location},
    	{"name"=>"profile_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{requester.id}/about' style='color: #2099d0; padding: 14px 20px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #FFF; font-weight: 100; border: 1px solid #2099d0;'>VIEW PROFILE</a>"},
    	{"name"=>"approve_link", "content"=>"<a href='#{Settings.ui_endpoint}/#alumni/approval' style='color: #FFF; padding: 15px 20px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>APPROVE REQUEST</a>"},
    	{"name"=>"friend_last_experience", "content"=>approver.full_last_experience},
    	{"name"=>"manage_subscriptions_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{approver.id}/settings' style='text-decoration: underline; color: #3a3737; font-size: 11px; font-weight: 100;'>Manage Suscription</a>"}
    ]

    send_email(approver.email, approver.name, subject, images, template_name, template_content)
	end

	def user_request_friendship(user, friend)
		images = []
		images << {"type"=>user.get_avatar_type, "name"=>"user_avatar", "content"=>user.get_avatar_base64}

		subject = "New friendship request from #{user.name}"

		template_name = "USR005_friendship_invitation"
    template_content = [
    	{"name"=>"alumnet_button", "content"=>"<a href='#{Settings.ui_endpoint}' style='color: #FFF; border: 1px solid #FFF; padding: 10px; text-decoration: none; font-family: sans-serif; font-size: 12px;'>GO TO ALUMNET</a>"},
    	{"name"=>"friend_name", "content"=>friend.name},
    	{"name"=>"user_name", "content"=>user.name},
    	{"name"=>"user_last_experience", "content"=>user.full_last_experience},
    	{"name"=>"user_location", "content"=>user.first_committee},
    	{"name"=>"user_country", "content"=>user.aiesec_location},
    	{"name"=>"profile_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{user.id}/about' style='color: #2099d0; padding: 15px 20px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #FFF; font-weight: 100; border: 1px solid #2099d0;'>VIEW PROFILE</a>"},
    	{"name"=>"accept_link", "content"=>"<a href='#{Settings.ui_endpoint}/#alumni/received' style='color: #FFF; padding: 15px 40px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>ACCEPT</a>"},
    	{"name"=>"friend_last_experience", "content"=>friend.full_last_experience},
    	{"name"=>"manage_subscriptions_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{friend.id}/settings' style='text-decoration: underline; color: #3a3737; font-size: 11px; font-weight: 100;'>Manage Suscription</a>"}
    ]

    send_email(friend.email, friend.name, subject, images, template_name, template_content)
	end

	def new_users_digest(admin)
		first_five_table = ''
		images = []
		subject = "Alumnet - New users registered"
		notifications_array = admin.last_week_approval_notifications.to_a

		main_content_html = @view.render(
			file: 'new_users_digest.html.erb', 
			locals: { 
				notifications: notifications_array,
				admin: admin,
				time_range_string: 'This week'
			}
		)

		notifications_array.each do |notification|
			images << {"type"=>notification.sender.get_avatar_type, "name"=>"user_avatar_#{notification.sender.id}", "content"=>notification.sender.get_avatar_base64}
		end

		template_name = "USR044_new_user_registered"
    template_content = [
    	{"name"=>"alumnet_button", "content"=>"<a href='#{Settings.ui_endpoint}' style='color: #FFF; border: 1px solid #FFF; padding: 10px; text-decoration: none; font-family: sans-serif; font-size: 12px;'>GO TO ALUMNET</a>"},
    	{"name"=>"admin_name", "content"=>"#{admin.name}"},
    	{"name"=>"admin_last_experience", "content"=>admin.full_last_experience},
    	{"name"=>"main_content_html", "content"=>main_content_html},
    	{"name"=>"manage_subscriptions_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{admin.id}/settings' style='text-decoration: underline; color: #3a3737; font-size: 11px; font-weight: 100;'>Manage Suscription</a>"}
    ]

    send_email(admin.email, admin.name, subject, images, template_name, template_content)
	end

	def registration_approvals_needed(user, users_list)
		images = []
		subject = "Alumnet - You need 3 approvals to complete registration"

		main_content_html = @view.render(
			file: 'registration_approvals_needed.html.erb', 
			locals: { 
				suggested_users: users_list
			}
		)

		users_list.each do |suggested_user|
			images << {"type"=>suggested_user.get_avatar_type, "name"=>"user_avatar_#{suggested_user.id}", "content"=>suggested_user.get_avatar_base64}
		end

		template_name = "USR038_approvals_needed"
    template_content = [
    	{"name"=>"alumnet_button", "content"=>"<a href='#{Settings.ui_endpoint}' style='color: #FFF; border: 1px solid #FFF; padding: 10px; text-decoration: none; font-family: sans-serif; font-size: 12px;'>GO TO ALUMNET</a>"},
    	{"name"=>"user_name", "content"=>"#{user.name}"},
    	{"name"=>"user_last_experience", "content"=>user.full_last_experience},
    	{"name"=>"suggested_users", "content"=>main_content_html},
    	{"name"=>"request_from_admin_link", "content"=>"<a href='#{Settings.ui_endpoint}/#registration/completed' style='color: #FFF; padding: 10px 30px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>Request from admin</a>"},
    	{"name"=>"manage_subscriptions_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{user.id}/settings' style='text-decoration: underline; color: #3a3737; font-size: 11px; font-weight: 100;'>Manage Suscription</a>"}
    ]

    send_email(user.email, user.name, subject, images, template_name, template_content)
	end

	def send_email(email_to, name_to, subject, images = [], template_name, template_content)
		message = {
			"inline_css"=>true,
			"subaccount"=>@subaccount,
			"return_path_domain"=>nil,
			"url_strip_qs"=>nil,
			"track_clicks"=>true,
			"headers"=>{"Reply-To"=>"info@aiesec-alumni.org"},
			"view_content_link"=>nil,
			"to"=>
			  [{"type"=>"to",
		      "email"=>email_to,
		      "name"=>name_to
			  }],
			"from_name"=>"Aiesec Alumni International",
			"tracking_domain"=>nil,
			"subject"=>subject,
			"signing_domain"=>nil,
			"auto_html"=>true,
			"track_opens"=>true,
			"from_email"=>"alumnet-noreply@aiesec-alumni.org",
			"auto_text"=>true,
			"images"=>images,
			"important"=>false}

    begin
    	result = @mandrill.messages.send_template template_name, template_content, message, false
    rescue Mandrill::Error => e
	    # Mandrill errors are thrown as exceptions
	    puts "A mandrill error occurred: #{e.class} - #{e.message}"
	  end
	end
end