require 'mandrill'
require 'base64'

class GeneralMailer
	def initialize
		@mandrill = Mandrill::API.new Settings.mandrill_api_key
		@subaccount = Settings.mandrill_subaccount
	end
	
	def friend_accept_friendship(user, friend)
		images = []
		user_avatar_url = URI.parse("#{user.avatar.url}")
		user_avatar_type = MIME::Types.type_for("#{user.avatar.url}").first.try(:content_type)
		begin
			user_avatar = {"type"=>user_avatar_type, "name"=>"user_avatar", "content"=>Base64.encode64(open(user_avatar_url) { |io| io.read })}
			images << user_avatar
		rescue Net::ReadTimeout
		  nil
		end

		template_name = "friend_accept_friendship"
    template_content = [
    	{"name"=>"alumnet_button", "content"=>"<a href='#{Settings.ui_endpoint}' style='color: #FFF; border: 1px solid #FFF; padding: 10px; text-decoration: none; font-family: sans-serif; font-size: 12px;'>GO TO ALUMNET</a>"},
    	{"name"=>"friend_name", "content"=>user.name},
    	{"name"=>"user_name", "content"=>friend.name},
    	{"name"=>"profile_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{friend.id}/about' style='color: #FFF; padding: 15px 40px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>VIEW PROFILE</a>"}
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
			"subject"=>"#{friend.name} accepted your friend request",
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

		template_name = "user_request_friendship"
    template_content = [
    	{"name"=>"alumnet_button", "content"=>"<a href='#{Settings.ui_endpoint}' style='color: #FFF; border: 1px solid #FFF; padding: 10px; text-decoration: none; font-family: sans-serif; font-size: 12px;'>GO TO ALUMNET</a>"},
    	{"name"=>"friend_name", "content"=>friend.name},
    	{"name"=>"user_name", "content"=>user.name},
    	{"name"=>"profile_link", "content"=>"<a href='#{Settings.ui_endpoint}/#users/#{user.id}/about' style='color: #FFF; padding: 15px 40px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>VIEW PROFILE</a>"}
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
    result = @mandrill.messages.send_template template_name, template_content, message, async
    
		rescue Mandrill::Error => e
	    # Mandrill errors are thrown as exceptions
	    puts "A mandrill error occurred: #{e.class} - #{e.message}"
	    # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'
    raise
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

		template_name = "invitation_to_alumnet"
    template_content = [
    	{"name"=>"alumnet_button", "content"=>"<a href='#{Settings.ui_endpoint}' style='color: #FFF; border: 1px solid #FFF; padding: 10px; text-decoration: none; font-family: sans-serif; font-size: 12px;'>GO TO ALUMNET</a>"},
    	{"name"=>"user_name", "content"=>user.name},
    	{"name"=>"reconnect_link", "content"=>"<a href='#{Settings.ui_endpoint}/home/?invitation_token=#{token}' style='color: #FFF; padding: 15px 40px; text-decoration: none; font-family: sans-serif; font-size: 15px; background-color: #2099d0; font-weight: 100;'>RECONNECT WITH AIESEC ALUMNI</a>"}
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
    result = @mandrill.messages.send_template template_name, template_content, message, async
    
		rescue Mandrill::Error => e
	    # Mandrill errors are thrown as exceptions
	    puts "A mandrill error occurred: #{e.class} - #{e.message}"
	    # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'
    raise
	end
end