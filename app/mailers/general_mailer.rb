require 'mandrill'
require 'base64'

class GeneralMailer
	def initialize
		@mandrill = Mandrill::API.new Settings.mandrill_api_key
		@subaccount = Settings.mandrill_subaccount
	end

	def approval_request_accepted(approver, requester)
		images = []
		images << {"type"=>approver.get_avatar_type, "name"=>"approver_avatar", "content"=>approver.get_avatar_base64}
		
		# build suggested friends if any suggestions
		suggested_friends = ''
		if requester.suggested_users.present?
			suggested_friends += "<span style='color: #464646; font-weight: 400; font-family: sans-serif; font-size: 18px;'>Suggested Friends</span><br><br>"
			suggested_friends += "<table>"
			suggested_friends += "<tr>"
			requester.suggested_users(3).each do |suggested_user|
				images << {"type"=>suggested_user.get_avatar_type, "name"=>"suggested_user_avatar_#{suggested_user.id}", "content"=>suggested_user.get_avatar_base64}

				#email html
				suggested_friends += "<th style='width: 33%;'>"
				suggested_friends += "<div style='margin-bottom: 35px;'>"
				suggested_friends += "<table>"
				suggested_friends += "<tr style='text-align: left;'>"
				suggested_friends += "<th>"
				suggested_friends += "<img src='cid:suggested_user_avatar_#{suggested_user.id}' alt=' height='50px' width='50px' style='border-radius: 50%;'>"
				suggested_friends += "</th>"
				suggested_friends += "<th style='text-align: left;'>"
				suggested_friends += "<span style='color: #464646; font-family: sans-serif; font-weight: 400; font-size: 14px;'>#{suggested_user.name}</span><br>"
				suggested_friends += "<span style='color: #696969; font-family: sans-serif; font-weight: 100; font-size: 12px;'>#{suggested_user.first_committee}</span>  "
				suggested_friends += "</th></tr></table></div></th>"
			end

			suggested_friends += "</tr>"
			suggested_friends += "</table>"
			suggested_friends += "<a href='#{Settings.ui_endpoint}/#alumni/discover' style='color: #FFF; padding: 12px 9px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>FIND THE PEOPLE THAT SHARE YOUR VALUES</a><br><br><br><br>"
		end

		#build groups suggestions if any
		suggested_groups = ''
		if requester.suggested_groups.present?
			suggested_groups += "<span style='color: #464646; font-weight: 400; font-family: sans-serif; font-size: 18px;'>Suggested Groups</span><br><br>"
			suggested_groups += "<table>"
			suggested_groups += "<tr>"
			requester.suggested_groups(3).each do |suggested_group|
				images << {"type"=>suggested_group.get_cover_type, "name"=>"suggested_group_cover_#{suggested_group.id}", "content"=>suggested_group.get_cover_base64}

				#email html
				suggested_groups += "<th style='width: 14%; text-align: left;'>"
				suggested_groups += "<span><img src='cid:suggested_group_cover_#{suggested_group.id}' alt=' height='80px' width='80px'></span>"
				suggested_groups += "<th>"
				suggested_groups += "<th style='text-align: left; width: 50%;'>"
				suggested_groups += "<span style='color: #464646; font-weight: 400; font-family: sans-serif; font-size: 15px;'>#{suggested_group.name}</span><br>"
				suggested_groups += "<span style='color: #6e6e6e; font-family: sans-serif; font-weight: 100; font-size: 13px;'>"
				suggested_groups += "<span>#{suggested_group.short_description}</span> <br>"
				suggested_groups += "<span>#{suggested_group.members.count} members</span> <br>"
				suggested_groups += "</span></th>"
				suggested_groups += "<th style='text-align: right; width: 30%;'>"
				suggested_groups += "<a href='#{Settings.ui_endpoint}/#groups/#{suggested_group.id}/about' style='color: #2099d0; padding: 10px 30px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #FFF; font-weight: 100; border: 1px solid #2099d0;'>JOIN GROUP</a>"
				suggested_groups += "</th></tr>"
			end

			suggested_groups += "</table>"
			suggested_groups += "<a href='#{Settings.ui_endpoint}/#groups/discover' style='color: #FFF; padding: 12px 30px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>FIND, JOIN AND SHARE ON THE TOPICS YOU CARE</a>"
		end

		template_name = "USR003_approval_request_accepted"
    template_content = [
    	{"name"=>"approver_name", "content"=>approver.name},
    	{"name"=>"welcome_link", "content"=>"<a href='#{Settings.ui_endpoint}/#posts' style='color: #FFF; padding: 12px 30px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>WELCOME ONBOARD!</a>"},
    	{"name"=>"join_us_link", "content"=>"<a href='#{Settings.ui_endpoint}/#posts' style='color: #FFF; padding: 12px 9px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>JOIN US IN THIS INCREDIBLE COMMUNITY</a>"},
    	{"name"=>"suggested_users_content", "content"=>suggested_friends},
    	{"name"=>"suggested_groups_content", "content"=>suggested_groups},
    	{"name"=>"manage_subscriptions_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{requester.id}/settings' style='text-decoration: underline; color: #3a3737; font-size: 11px; font-weight: 100;'>Manage Suscription</a>"},
    	{"name"=>"requester_name", "content"=>requester.name},
    	{"name"=>"requester_last_experience", "content"=>requester.full_last_experience}
    ]

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
			      "email"=>"#{requester.email}",
			      "name"=>"#{requester.name}"}],
			"from_name"=>"Aiesec Alumni International",
			"tracking_domain"=>nil,
			"subject"=>"#{approver.name} gave you an Alumni verification",
			"signing_domain"=>nil,
			"auto_html"=>true,
			"track_opens"=>true,
			"from_email"=>"alumnet-noreply@aiesec-alumni.org",
			"auto_text"=>true,
			"images"=>images,
			"important"=>false}
    async = false

    begin
    	result = @mandrill.messages.send_template template_name, template_content, message, async
    rescue Mandrill::Error => e
	    # Mandrill errors are thrown as exceptions
	    puts "A mandrill error occurred: #{e.class} - #{e.message}"
	  end
	end
	
	def friend_accept_friendship(friend, user)
		images = []
		images << {"type"=>user.get_avatar_type, "name"=>"user_avatar", "content"=>user.get_avatar_base64}

		# define user treatment based on gender
		user_his_her = 'his' 
		if user.profile.gender == 'F'
			user_his_her = 'her'
		end

		user_he_she = 'he\'s' 
		if user.profile.gender == 'F'
			user_he_she = 'she\'s'
		end

		# build suggested friends if any suggestions
		suggested_friends = ''
		if friend.suggested_users.present?
			suggested_user = friend.suggested_users.first
			images << {"type"=>suggested_user.get_avatar_type, "name"=>"suggested_user_avatar", "content"=>suggested_user.get_avatar_base64}

			#email html
			suggested_friends += "<div style='background-color: #f3f3f5; padding: 20px; width: 550px; margin: 0 auto; text-align: center;'>"
			suggested_friends += "<span style='color: #464646; font-weight: 400; font-family: sans-serif; font-size: 18px;'>Suggested Friends</span><br><br>"
			suggested_friends += "<span style='color: #6e6e6e; font-weight: 100; font-family: sans-serif; font-size: 15px;'>Lorem ipsum dolor sit amet, consectetur adipiscing elit</span>"
			suggested_friends += "<table style='margin-top: 25px; margin-bottom: 35px;'>"
			suggested_friends += "<tr>"
			suggested_friends += "<th style='width: 14%; text-align: left;'>"
			suggested_friends += "<span><img src='cid:suggested_user_avatar' alt='' height='80px' width='80px' style='border-radius: 50%;'></span>"
			suggested_friends += "</th>"
			suggested_friends += "<th style='text-align: left; width: 50%;'>"
			suggested_friends += "<span style='color: #464646; font-weight: 400; font-family: sans-serif; font-size: 15px;'>#{suggested_user.name}</span><br>"
			suggested_friends += "<span style='color: #6e6e6e; font-family: sans-serif; font-weight: 100; font-size: 15px;'>"
			suggested_friends += "#{suggested_user.full_last_experience} <br>"
			suggested_friends += "#{suggested_user.first_committee} <br>"
			suggested_friends += "#{suggested_user.aiesec_location}"
			suggested_friends += "</span>"
			suggested_friends += "</th>"
			suggested_friends += "<th style='text-align: right; width: 30%;'>"
			suggested_friends += "<a href='#{Settings.ui_endpoint}/#users/#{suggested_user.id}/about' style='color: #2099d0; padding: 10px 30px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #f3f3f5; font-weight: 100; border: 1px solid #2099d0;'>VIEW PROFILE</a>"
			suggested_friends += "</th>"
			suggested_friends += "</tr>"
			suggested_friends += "</table>"
			suggested_friends += "</div>"
		end

		template_name = "USR006_accept_friendship_invitation"
    template_content = [
    	{"name"=>"alumnet_button", "content"=>"<a href='#{Settings.ui_endpoint}' style='color: #FFF; border: 1px solid #FFF; padding: 10px; text-decoration: none; font-family: sans-serif; font-size: 12px;'>GO TO ALUMNET</a>"},
    	{"name"=>"friend_name", "content"=>friend.name},
    	{"name"=>"user_name", "content"=>user.name},
    	{"name"=>"user_his_her", "content"=>user_his_her},
    	{"name"=>"user_he_she", "content"=>user_he_she},
    	{"name"=>"profile_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{user.id}/about' style='color: #FFF; padding: 12px 30px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>VIEW #{user.name} PROFILE</a>"},
    	{"name"=>"suggested_friends", "content"=>suggested_friends},
    	{"name"=>"manage_subscriptions_link", "content"=>"<a href='#' style='text-decoration: underline; color: #3a3737; font-size: 11px; font-weight: 100;'> Manage Suscription </a>"},
    	{"name"=>"friend_last_experience", "content"=>friend.full_last_experience},
    	{"name"=>"manage_subscriptions_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{friend.id}/settings' style='text-decoration: underline; color: #3a3737; font-size: 11px; font-weight: 100;'>Manage Suscription</a>"}
    ]

    message = {
			"inline_css"=>true,
			"subaccount"=>@subaccount,
			"return_path_domain"=>nil,
			"url_strip_qs"=>nil,
			"track_clicks"=>nil,
			"headers"=>{"Reply-To"=>"info@aiesec-alumni.org"},
			"view_content_link"=>nil,
			"to"=>
			  [{"type"=>"to",
			      "email"=>"#{friend.email}",
			      "name"=>"#{friend.name}"}],
			"from_name"=>"Aiesec Alumni International",
			"tracking_domain"=>nil,
			"subject"=>"#{user.name} accepted your friend request",
			"signing_domain"=>nil,
			"auto_html"=>true,
			"track_opens"=>true,
			"from_email"=>"alumnet-noreply@aiesec-alumni.org",
			"auto_text"=>true,
			"images"=>images,
			"important"=>false}
    async = false

    begin
    	result = @mandrill.messages.send_template template_name, template_content, message, async
    rescue Mandrill::Error => e
	    # Mandrill errors are thrown as exceptions
	    puts "A mandrill error occurred: #{e.class} - #{e.message}"
	  end
	end

	def invitation_to_alumnet(email, guest_name, user, token)
		images = []
		images << {"type"=>user.get_avatar_type, "name"=>"user_avatar", "content"=>user.get_avatar_base64}

		template_name = "USR039_invitation_to_alumnet"
    template_content = [
    	{"name"=>"alumnet_button", "content"=>"<a href='#{Settings.ui_endpoint}' style='color: #FFF; border: 1px solid #FFF; padding: 10px; text-decoration: none; font-family: sans-serif; font-size: 12px;'>GO TO ALUMNET</a>"},
    	{"name"=>"user_name", "content"=>user.name},
    	{"name"=>"reconnect_link", "content"=>"<a href='#{Settings.ui_endpoint}/home/?invitation_token=#{token}' style='color: #FFF; padding: 15px 40px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>RECONNECT WITH AIESEC ALUMNI</a>"},
    	{"name"=>"reconnect_link_footer", "content"=>"<a href='#{Settings.ui_endpoint}/home/?invitation_token=#{token}' style='color: #FFF; padding: 15px 40px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>REGISTER</a>"}
    ]

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
			      "email"=>"#{email}",
			      "name"=>"#{guest_name}"}],
			"from_name"=>"Aiesec Alumni International",
			"tracking_domain"=>nil,
			"subject"=>"You’re invited to join AIESEC AlumNet",
			"signing_domain"=>nil,
			"auto_html"=>true,
			"track_opens"=>true,
			"from_email"=>"alumnet-noreply@aiesec-alumni.org",
			"auto_text"=>true,
			"images"=>images,
			"important"=>false}
    async = false

    begin
    	result = @mandrill.messages.send_template template_name, template_content, message, async
    rescue Mandrill::Error => e
	    # Mandrill errors are thrown as exceptions
	    puts "A mandrill error occurred: #{e.class} - #{e.message}"
	  end
	end

	def user_request_approval(approver, requester)
		images = []
		images << {"type"=>requester.get_avatar_type, "name"=>"user_avatar", "content"=>requester.get_avatar_base64}

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
			      "email"=>"#{approver.email}",
			      "name"=>"#{approver.name}"}],
			"from_name"=>"Aiesec Alumni International",
			"tracking_domain"=>nil,
			"subject"=>"Is #{requester.name} an AIESEC Alum you know?",
			"signing_domain"=>nil,
			"auto_html"=>true,
			"track_opens"=>true,
			"from_email"=>"alumnet-noreply@aiesec-alumni.org",
			"auto_text"=>true,
			"images"=>images,
			"important"=>false}
    async = false

    begin
    	result = @mandrill.messages.send_template template_name, template_content, message, async
    rescue Mandrill::Error => e
	    # Mandrill errors are thrown as exceptions
	    puts "A mandrill error occurred: #{e.class} - #{e.message}"
	  end
	end

	def user_request_friendship(user, friend)
		images = []
		images << {"type"=>user.get_avatar_type, "name"=>"user_avatar", "content"=>user.get_avatar_base64}

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

    message = {
			"inline_css"=>true,
			"subaccount"=>@subaccount,
			"return_path_domain"=>nil,
			"url_strip_qs"=>nil,
			"track_clicks"=>nil,
			"headers"=>{"Reply-To"=>"info@aiesec-alumni.org"},
			"view_content_link"=>nil,
			"to"=>
			  [{"type"=>"to",
			      "email"=>"#{friend.email}",
			      "name"=>"#{friend.name}"}],
			"from_name"=>"Aiesec Alumni International",
			"tracking_domain"=>nil,
			"subject"=>"New friendship request from #{user.name}",
			"signing_domain"=>nil,
			"auto_html"=>true,
			"track_opens"=>true,
			"from_email"=>"alumnet-noreply@aiesec-alumni.org",
			"auto_text"=>true,
			"images"=>images,
			"important"=>false}
    async = false

    begin
    	result = @mandrill.messages.send_template template_name, template_content, message, async
    rescue Mandrill::Error => e
	    # Mandrill errors are thrown as exceptions
	    puts "A mandrill error occurred: #{e.class} - #{e.message}"
	  end
	end
end