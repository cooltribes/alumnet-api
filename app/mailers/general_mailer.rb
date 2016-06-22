require 'mandrill'
require 'base64'

class GeneralMailer
	def initialize
		@mandrill = Mandrill::API.new Settings.mandrill_api_key
		@subaccount = Settings.mandrill_subaccount
	end
	
	def friend_accept_friendship(friend, user)
		images = []
		user_avatar_url = URI.parse("#{user.avatar.url}")
		user_avatar_type = MIME::Types.type_for("#{user.avatar.url}").first.try(:content_type)
		begin
			user_avatar = {"type"=>user_avatar_type, "name"=>"user_avatar", "content"=>Base64.encode64(open(user_avatar_url) { |io| io.read })}
			images << user_avatar
		rescue Net::ReadTimeout
		  nil
		end

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
			#avatar
			suggested_user_avatar_url = URI.parse("#{suggested_user.avatar.url}")
			suggested_user_avatar_type = MIME::Types.type_for("#{suggested_user.avatar.url}").first.try(:content_type)
			begin
				suggested_user_avatar = {"type"=>suggested_user_avatar_type, "name"=>"suggested_user_avatar", "content"=>Base64.encode64(open(suggested_user_avatar_url) { |io| io.read })}
				images << suggested_user_avatar
			rescue Net::ReadTimeout
			  nil
			end

			last_experience = ''
			last_experience = suggested_user.last_experience.name if suggested_user.last_experience.present?
			last_experience += " at " + suggested_user.last_experience.organization_name if suggested_user.last_experience.present? && suggested_user.last_experience.organization_name.present?

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
			suggested_friends += "#{last_experience} <br>"
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

		friend_last_experience = ''
		friend_last_experience = friend.last_experience.name if friend.last_experience.present?
		friend_last_experience += " at " + friend.last_experience.organization_name if friend.last_experience.present? && friend.last_experience.organization_name.present?

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
    	{"name"=>"friend_last_experience", "content"=>friend_last_experience},
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

	def user_request_friendship(user, friend)
		images = []
		user_avatar_url = URI.parse("#{user.avatar.url}")
		user_avatar_type = MIME::Types.type_for("#{user.avatar.url}").first.try(:content_type)
		begin
			user_avatar = {"type"=>user_avatar_type, "name"=>"user_avatar", "content"=>Base64.encode64(open(user_avatar_url) { |io| io.read })}
			images << user_avatar
		rescue Net::ReadTimeout
		  nil
		end

		last_experience = ''
		last_experience = user.last_experience.name if user.last_experience.present?
		last_experience += " at " + user.last_experience.organization_name if user.last_experience.present? && user.last_experience.organization_name.present?

		friend_last_experience = ''
		friend_last_experience = friend.last_experience.name if friend.last_experience.present?
		friend_last_experience += " at " + friend.last_experience.organization_name if friend.last_experience.present? && friend.last_experience.organization_name.present?

		template_name = "USR005_friendship_invitation"
    template_content = [
    	{"name"=>"alumnet_button", "content"=>"<a href='#{Settings.ui_endpoint}' style='color: #FFF; border: 1px solid #FFF; padding: 10px; text-decoration: none; font-family: sans-serif; font-size: 12px;'>GO TO ALUMNET</a>"},
    	{"name"=>"friend_name", "content"=>friend.name},
    	{"name"=>"user_name", "content"=>user.name},
    	{"name"=>"user_last_experience", "content"=>last_experience},
    	{"name"=>"user_location", "content"=>user.first_committee},
    	{"name"=>"user_country", "content"=>user.aiesec_location},
    	{"name"=>"profile_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{user.id}/about' style='color: #2099d0; padding: 15px 20px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #FFF; font-weight: 100; border: 1px solid #2099d0;'>VIEW PROFILE</a>"},
    	{"name"=>"accept_link", "content"=>"<a href='#{Settings.ui_endpoint}/#alumni/received' style='color: #FFF; padding: 15px 40px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>ACCEPT</a>"},
    	{"name"=>"friend_last_experience", "content"=>friend_last_experience},
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

	def invitation_to_alumnet(email, guest_name, user, token)
		images = []
		user_avatar_url = URI.parse("#{user.avatar.url}")
		user_avatar_type = MIME::Types.type_for("#{user.avatar.url}").first.try(:content_type)
		begin
			user_avatar = {"type"=>user_avatar_type, "name"=>"user_avatar", "content"=>Base64.encode64(open(user_avatar_url) { |io| io.read })}
			images << user_avatar
		rescue Net::ReadTimeout
		  nil
		end

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
		user_avatar_url = URI.parse("#{requester.avatar.url}")
		user_avatar_type = MIME::Types.type_for("#{requester.avatar.url}").first.try(:content_type)
		begin
			user_avatar = {"type"=>user_avatar_type, "name"=>"user_avatar", "content"=>Base64.encode64(open(user_avatar_url) { |io| io.read })}
			images << user_avatar
		rescue Net::ReadTimeout
		  nil
		end

		last_experience = ''
		last_experience = requester.last_experience.name if requester.last_experience.present?
		last_experience += " at " + requester.last_experience.organization_name if requester.last_experience.present? && requester.last_experience.organization_name.present?

		friend_last_experience = ''
		friend_last_experience = friend.last_experience.name if friend.last_experience.present?
		friend_last_experience += " at " + friend.last_experience.organization_name if friend.last_experience.present? && friend.last_experience.organization_name.present?

		template_name = "USR002_request_approval"
    template_content = [
    	{"name"=>"friend_name", "content"=>approver.name},
    	{"name"=>"user_name", "content"=>requester.name},
    	{"name"=>"user_last_experience", "content"=>last_experience},
    	{"name"=>"user_location", "content"=>requester.first_committee},
    	{"name"=>"user_country", "content"=>requester.aiesec_location},
    	{"name"=>"profile_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{requester.id}/about' style='color: #2099d0; padding: 14px 20px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #FFF; font-weight: 100; border: 1px solid #2099d0;'>VIEW PROFILE</a>"},
    	{"name"=>"approve_link", "content"=>"<a href='#{Settings.ui_endpoint}/#alumni/approval' style='color: #FFF; padding: 15px 20px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>APPROVE REQUEST</a>"},
    	{"name"=>"friend_last_experience", "content"=>friend_last_experience},
    	{"name"=>"manage_subscriptions_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{friend.id}/settings' style='text-decoration: underline; color: #3a3737; font-size: 11px; font-weight: 100;'>Manage Suscription</a>"}
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
end