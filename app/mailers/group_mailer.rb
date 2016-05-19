require 'mandrill'

class GroupMailer
	def initialize
		@mandrill = Mandrill::API.new '_6giUhWWZOU6r2YgCmuf-Q'
	end
	
	def send_digest(user_membership, digest_posts)
		main_content = ''
		digest_posts.each do |post|
      main_content += "User: #{post.user.name}<br>#{post.likes.count} likes<br>#{post.comments.count} comments<br><br>#{post.body}<br><br><br>"
  	end
		template_name = "group_digest"
    template_content = [
    	{"name"=>"user_name", "content"=>"#{user_membership.user.name}"},
    	{"name"=>"main", "content"=>main_content}
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
			#    [{"type"=>"image/png", "content"=>"ZXhhbXBsZSBmaWxl", "name"=>"IMAGECID"}],
			# "recipient_metadata"=>
			#    [{"rcpt"=>"recipient.email@example.com", "values"=>{"user_id"=>123456}}],
			# "metadata"=>{"website"=>"www.example.com"},
			# "merge_language"=>"mailchimp",
			# "inline_css"=>nil,
			# "subaccount"=>"customer-123",
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
			"auto_html"=>nil,
			"track_opens"=>true,
			"track_clicks"=>true,
			"from_email"=>"alumnet-noreply@aiesec-alumni.org",
			"auto_text"=>nil,
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