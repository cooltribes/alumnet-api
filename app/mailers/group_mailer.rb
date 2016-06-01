require 'mandrill'
require 'base64'

class GroupMailer
	def initialize
		@mandrill = Mandrill::API.new Settings.mandrill_api_key
		@subaccount = Settings.mandrill_subaccount
	end

	def join_group(user, sender, group)
		template_name = "group_join"
    template_content = [
    	{"name"=>"alumnet_url", "content"=>"<a href='#{Settings.ui_endpoint}"},
    	{"name"=>"user_name", "content"=>"#{user.name}"},
    	{"name"=>"sender_name", "content"=>"#{sender.name}"},
    	{"name"=>"group_name", "content"=>"#{group.name}"},
    	{"name"=>"group_url", "content"=>"<a href='#{Settings.ui_endpoint}/#groups/#{group.id}/posts'>here</a>"}
    ]

    message = {
			"subaccount"=>@subaccount,
			"return_path_domain"=>nil,
			"url_strip_qs"=>nil,
			"track_clicks"=>true,
			"headers"=>{"Reply-To"=>"info@aiesec-alumni.org"},
			"view_content_link"=>nil,
			"to"=>
			  [{"type"=>"to",
			      "email"=>"#{user.email}",
			      "name"=>"#{user.name}"}],
			"from_name"=>"Aiesec Alumni International",
			"tracking_domain"=>nil,
			"subject"=>"You've joined the Group #{group.name}!",
			"signing_domain"=>nil,
			"auto_html"=>nil,
			"track_opens"=>true,
			"from_email"=>"alumnet-noreply@aiesec-alumni.org",
			"auto_text"=>nil,
			"important"=>false}
    async = false
    result = @mandrill.messages.send_template template_name, template_content, message, async
    
		rescue Mandrill::Error => e
	    # Mandrill errors are thrown as exceptions
	    puts "A mandrill error occurred: #{e.class} - #{e.message}"
	    # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'
    raise
	end
	
	def send_digest(user_membership, digest_posts)
		main_content = ''
		images = []
		digest_posts.each do |post|
			body = post.body
			if post.body.length > 400
				body = post.body.truncate(400, omission: "... <a href='#{Settings.ui_endpoint}/#groups/#{user_membership.group.id}/posts/#{post.id}' style='color: #2099d0; text-decoration: none;'>(read more)</a>")
			end
			main_content += '<div style="display: inline-block; width: 50px; text-align: left;">'
			main_content += "<a href='#{Settings.ui_endpoint}/#users/#{post.user.id}/posts'><img src='cid:avatar_user_#{post.user.id}' alt='#{post.user.name}' height='40px' style='margin-right: 10px;'></a>"
			main_content += '</div>'
			main_content += '<div style="width: 200px; display: inline-block; top: 0; padding: 5px;">'
			main_content += "<span style='font-family: sans-serif; font-size: 12px; color: #838385; font-weight: 100;'>By: <a href='#{Settings.ui_endpoint}/#users/#{post.user.id}/posts' style='color: #2099d0; text-decoration: none;'>#{post.user.name}</a></span><br>"
			main_content += "<span style='font-family: sans-serif; font-size: 13px; color: #838385; font-weight: 100;'>#{post.created_at.strftime('%b %e %Y')}</span>"
			main_content += '</div>'
			main_content += '<div style="margin-top: 10px;">'
			main_content += "<span style='font-family: sans-serif; font-size: 13px; color: #838385; font-weight: 100; text-decoration: none; line-height: 20px;'>#{body}</span><br><br>"
			if post.pictures.first
				main_content += '<div style="text-align: center; margin-bottom: 20px">'
				main_content += "<img src='cid:post_image_#{post.id}' alt='' width='500px'>"
				main_content += '</div>'
				post_image_type = MIME::Types.type_for("#{post.pictures.first.picture.url}").first.try(:content_type)
				post_image = {"type"=>post_image_type, "name"=>"post_image_#{post.id}", "content"=>Base64.encode64(open("#{post.pictures.first.picture.url}") { |io| io.read })}
				images << post_image
			end
			if post.likes.count > 0
				main_content += "<a href='#{Settings.ui_endpoint}/#groups/#{user_membership.group.id}/posts/#{post.id}' style='color: #2099d0; text-decoration: none; font-family: sans-serif; margin-right:10px; font-size: 14px; font-weight: 100;'><span>#{post.likes.count} Likes</span></a>"
			end
			if post.comments.count > 0
				main_content += "<a href='#{Settings.ui_endpoint}/#groups/#{user_membership.group.id}/posts/#{post.id}' style='color: #2099d0; text-decoration: none; font-family: sans-serif; font-size: 14px; font-weight: 100;'><span>#{post.comments.count} Comments</span></a>"
			end
			main_content += '</div><br><br>'
			mime_type = MIME::Types.type_for("#{post.user.avatar.medium.url}").first.try(:content_type)
			user_avatar = {"type"=>mime_type, "name"=>"avatar_user_#{post.user.id}", "content"=>Base64.encode64(open("#{post.user.avatar.medium.url}") { |io| io.read })}
			images << user_avatar
  	end

  	main_content += '<div style="margin: 20px; text-align: center">'
  	main_content += "<a href='#{Settings.ui_endpoint}/#groups/#{user_membership.group.id}/posts' style='color: #FFF; padding: 15px 40px; text-decoration: none; font-family: sans-serif; font-size: 12px; background-color: #2099d0'>GO TO GROUP</a>"
  	main_content += '</div>'

		template_name = "group_digest"
    template_content = [
    	{"name"=>"alumnet_button", "content"=>"<a href='#{Settings.ui_endpoint}' style='color: #FFF; border: 1px solid #FFF; padding: 10px; text-decoration: none; font-family: sans-serif; font-size: 12px;'>GO TO ALUMNET</a>"},
    	{"name"=>"user_name", "content"=>"#{user_membership.user.name}"},
    	{"name"=>"group_name", "content"=>"#{user_membership.group.name}"},
    	{"name"=>"group_url", "content"=>"<a href='#{Settings.ui_endpoint}/#groups/#{user_membership.group.id}/posts'>here</a>"},
    	{"name"=>"digest_content", "content"=>main_content}
    ]

    message = {
			# "google_analytics_campaign"=>"message.from_email@example.com",
			# "tags"=>["password-resets"],
			# "merge_vars"=>
			#    [{"vars"=>[{"content"=>"merge2 content", "name"=>"merge2"}],
			#        "rcpt"=>"recipient.email@example.com"}],
			# "bcc_address"=>"message.bcc_address@example.com",
			# "preserve_recipients"=>nil,
			# "images"=>
			#   [
			#   	{"type"=>"image/gif", "content"=>"data:image/gif;base64,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", "name"=>"avatar_user_5"},
			#   	{"type"=>"image/gif", "content"=>"data:image/gif;base64,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", "name"=>"avatar_user_4"},
			#   	{"type"=>"image/gif", "content"=>"data:image/gif;base64,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", "name"=>"avatar_user_4"}
			#   ],
			  	# "recipient_metadata"=>
			#    [{"rcpt"=>"recipient.email@example.com", "values"=>{"user_id"=>123456}}],
			# "metadata"=>{"website"=>"www.example.com"},
			# "merge_language"=>"mailchimp",
			"inline_css"=>true,
			"subaccount"=>@subaccount,
			# "merge"=>true,
			"return_path_domain"=>nil,
			"url_strip_qs"=>nil,
			# "global_merge_vars"=>[{"content"=>"merge1 content", "name"=>"merge1"}],
			"track_clicks"=>nil,
			"headers"=>{"Reply-To"=>"info@aiesec-alumni.org"},
			"view_content_link"=>nil,
			"to"=>
			  [{"type"=>"to",
			      "email"=>"#{user_membership.user.email}",
			      "name"=>"#{user_membership.user.name}"}],
			# "html"=>"<p>Example HTML content</p>",
			# google_analytics_domains"=>["example.com"],
			"from_name"=>"Aiesec Alumni International",
			# "text"=>"Example text content",
			# "attachments"=>
			#    [{"type"=>"text/plain",
			#        "content"=>"ZXhhbXBsZSBmaWxl",
			#        "name"=>"myfile.txt"}],
			"tracking_domain"=>nil,
			"subject"=>"AlumNet Digest - #{user_membership.group.name}",
			"signing_domain"=>nil,
			"auto_html"=>true,
			"track_opens"=>true,
			"from_email"=>"alumnet-noreply@aiesec-alumni.org",
			"auto_text"=>true,
			"images"=>images,
			"important"=>false}
    async = false
    #ip_pool = "Main Pool"
    #send_at = "example send_at"
    result = @mandrill.messages.send_template template_name, template_content, message, async
        # [{"status"=>"sent",
        #     "reject_reason"=>"hard-bounce",
        #     "email"=>"recipient.email@example.com",
        #     "_id"=>"abc123abc123abc123abc123abc123"}]
    
		rescue Mandrill::Error => e
	    # Mandrill errors are thrown as exceptions
	    puts "A mandrill error occurred: #{e.class} - #{e.message}"
	    # A mandrill error occurred: Mandrill::UnknownSubaccountError - No subaccount exists with the id 'customer-123'
    raise
	end
end