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

	def new_users_digest(admin)
		first_five_table = ''
		images = []
		notifications_array = admin.last_week_approval_notifications.to_a
		notifications_array.shift(5).each do |notification|
			first_five_table += "<tr>"
			first_five_table += "<th style='width: 14%; text-align: left;'>"
			first_five_table += "<img src='cid:user_avatar_#{notification.sender.id}' alt=' height='80px' width='80px' style='border-radius: 50%;'>"
			first_five_table += "</th>"
			first_five_table += "<th style='text-align: left; width: 40%;'>"
			first_five_table += "<span style='color: #464646; font-weight: 400; font-family: sans-serif; font-size: 15px;'>#{notification.sender.name.upcase}</span><br>"
			first_five_table += "<span style='color: #6e6e6e; font-family: sans-serif; font-weight: 100; font-size: 15px;'>"
			first_five_table += "<span>#{notification.sender.full_last_experience}</span> <br>"
			first_five_table += "<span>#{notification.sender.first_committee}</span> <br>"
			first_five_table += "<span>#{notification.sender.aiesec_location}</span>"
			first_five_table += "</span>"
			first_five_table += "</th>"
			first_five_table += "<th style='text-align: right; width: 40%;'>"
			first_five_table += "<a href='#{Settings.ui_endpoint}/#admin/users/#{notification.sender.id}' style='color: #FFF; padding: 10px 30px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>ACCEPT REQUEST</a>"
			first_five_table += "</th>"
			first_five_table += "</tr>"

			images << {"type"=>notification.sender.get_avatar_type, "name"=>"user_avatar_#{notification.sender.id}", "content"=>notification.sender.get_avatar_base64}
		end

		remaining_users_content = ''
		if notifications_array.size > 0
			remaining_users_content += "<div style='background-color: #f3f3f5; padding: 20px; width: 550px; margin: 0 auto; text-align: center;'>"
			remaining_users_content += "<span style='color: #696969; font-family: sans-serif; font-weight: 100; font-size: 15px;'>"
			remaining_users_content += "<span style='font-weight: 400; color: #464646; font-size: 18px;'>This is becoming faster and faster!</span><br><br>"
			remaining_users_content += "There are #{notifications_array.size} more people asking to be approved. <br><br>"
			remaining_users_content += "Please, verify them and encourage them to start interacting on AlumNet! <br><br>"
			remaining_users_content += "Finally, we can really be together in one space. <br><br>"
			remaining_users_content += "</span>"
			remaining_users_content += "<div style='margin: 20px auto; text-align: center;'>"
			notifications_array.each do |notification|
				remaining_users_content += "<a href='#{Settings.ui_endpoint}/#admin/users/#{notification.sender.id}'><img src='cid:user_avatar_#{notification.sender.id}' alt=' height='40px' width='40px' style='border-radius: 50%;'></a>"
				images << {"type"=>notification.sender.get_avatar_type, "name"=>"user_avatar_#{notification.sender.id}", "content"=>notification.sender.get_avatar_base64}
			end
			remaining_users_content += "</div>"
			remaining_users_content += "<div>"
			remaining_users_content += "<a href='#{Settings.ui_endpoint}/#admin/users' style='color: #FFF; padding: 10px 30px; text-decoration: none; font-family: sans-serif; font-size: 16px; background-color: #2099d0; font-weight: 100;'>VIEW REQUESTS</a>"
			remaining_users_content += "</div>"
			remaining_users_content += "</div>"
		end

		template_name = "USR044_new_user_registered"
    template_content = [
    	{"name"=>"alumnet_button", "content"=>"<a href='#{Settings.ui_endpoint}' style='color: #FFF; border: 1px solid #FFF; padding: 10px; text-decoration: none; font-family: sans-serif; font-size: 12px;'>GO TO ALUMNET</a>"},
    	{"name"=>"admin_name", "content"=>"#{admin.name}"},
    	{"name"=>"admin_last_experience", "content"=>admin.full_last_experience},
    	{"name"=>"time_range_string", "content"=>"This week"},
    	{"name"=>"registered_number", "content"=>admin.last_week_approval_notifications.count},
    	{"name"=>"first_five_users", "content"=>first_five_table},
    	{"name"=>"remaining_users", "content"=>remaining_users_content},
    	{"name"=>"manage_subscriptions_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{admin.id}/settings' style='text-decoration: underline; color: #3a3737; font-size: 11px; font-weight: 100;'>Manage Suscription</a>"}
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
			      "email"=>"#{admin.email}",
			      "name"=>"#{admin.name}"}],
			"from_name"=>"Aiesec Alumni International",
			"tracking_domain"=>nil,
			"subject"=>"Alumnet - New user registered",
			"signing_domain"=>nil,
			"auto_html"=>true,
			"track_opens"=>true,
			"from_email"=>"alumnet-noreply@aiesec-alumni.org",
			"auto_text"=>true,
			"images"=>images,
			"important"=>false}
    async = false
    result = @mandrill.messages.send_template template_name, template_content, message, async
    
		rescue Mandrill::Error => e
	    # Mandrill errors are thrown as exceptions
	    puts "A mandrill error occurred: #{e.class} - #{e.message}"
	    # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'
    raise
	end

	def registration_approvals_needed(user, users_list)
		suggested_users = ''
		images = []
		users_list.each do |suggested_user|
			suggested_users += "<tr>"
			suggested_users += "<th style='width: 14%; text-align: left;'>"
			suggested_users += "<img src='cid:user_avatar_#{suggested_user.id}' alt=' height='80px' width='80px' style='border-radius: 50%;'>"
			suggested_users += "</th>"
			suggested_users += "<th style='text-align: left; width: 40%;'>"
			suggested_users += "<span style='color: #464646; font-weight: 400; font-family: sans-serif; font-size: 15px;'>#{suggested_user.name.upcase}</span><br>"
			suggested_users += "<span style='color: #6e6e6e; font-family: sans-serif; font-weight: 100; font-size: 15px;'>"
			suggested_users += "<span>#{suggested_user.full_last_experience}</span> <br>"
			suggested_users += "<span>#{suggested_user.first_committee}</span> <br>"
			suggested_users += "<span>#{suggested_user.aiesec_location}</span>"
			suggested_users += "</span>"
			suggested_users += "</th>"
			suggested_users += "<th style='text-align: right; width: 40%;'>"
			suggested_users += "<a href='#{Settings.ui_endpoint}/#registration/completed' style='color: #FFF; padding: 10px 30px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>REQUEST APPROVAL</a>"
			suggested_users += "</th>"
			suggested_users += "</tr>"

			images << {"type"=>suggested_user.get_avatar_type, "name"=>"user_avatar_#{suggested_user.id}", "content"=>suggested_user.get_avatar_base64}
		end

		template_name = "USR038_approvals_needed"
    template_content = [
    	{"name"=>"alumnet_button", "content"=>"<a href='#{Settings.ui_endpoint}' style='color: #FFF; border: 1px solid #FFF; padding: 10px; text-decoration: none; font-family: sans-serif; font-size: 12px;'>GO TO ALUMNET</a>"},
    	{"name"=>"user_name", "content"=>"#{user.name}"},
    	{"name"=>"user_last_experience", "content"=>user.full_last_experience},
    	{"name"=>"suggested_users", "content"=>suggested_users},
    	{"name"=>"request_from_admin_link", "content"=>"<a href='#{Settings.ui_endpoint}/#registration/completed' style='color: #FFF; padding: 10px 30px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>Request from admin</a>"},
    	{"name"=>"manage_subscriptions_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{user.id}/settings' style='text-decoration: underline; color: #3a3737; font-size: 11px; font-weight: 100;'>Manage Suscription</a>"}
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
			      "email"=>"#{user.email}",
			      "name"=>"#{user.name}"}],
			"from_name"=>"Aiesec Alumni International",
			"tracking_domain"=>nil,
			"subject"=>"Alumnet - You need 3 approvals to complete registration",
			"signing_domain"=>nil,
			"auto_html"=>true,
			"track_opens"=>true,
			"from_email"=>"alumnet-noreply@aiesec-alumni.org",
			"auto_text"=>true,
			"images"=>images,
			"important"=>false}
    async = false
    result = @mandrill.messages.send_template template_name, template_content, message, async
    
		rescue Mandrill::Error => e
	    # Mandrill errors are thrown as exceptions
	    puts "A mandrill error occurred: #{e.class} - #{e.message}"
	    # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'
    raise
	end
end