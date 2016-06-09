require 'mandrill'
require 'base64'

class MembershipMailer
	include ActionView::Helpers::NumberHelper
	
	def initialize
		@mandrill = Mandrill::API.new Settings.mandrill_api_key
		@subaccount = Settings.mandrill_subaccount
	end
	
	def send_purchase_email(user_product, payment)
		#date = DateTime.parse(payment.created_at)
		formatted_date = payment.created_at.strftime('%d %m %Y')
		template_name = "membership_purchase"
    template_content = [
    	{"name"=>"alumnet_button", "content"=>"<a href='#{Settings.ui_endpoint}' style='color: #FFF; border: 1px solid #FFF; padding: 10px; text-decoration: none; font-family: sans-serif; font-size: 12px;'>GO TO ALUMNET</a>"},
    	{"name"=>"product_name", "content"=>user_product.product.name},
    	{"name"=>"invoice_number", "content"=>'A-'+payment.id.to_s},
    	{"name"=>"invoice_date", "content"=>formatted_date},
    	{"name"=>"user_name", "content"=>user_product.user.name},
    	{"name"=>"product_price", "content"=>number_to_currency(user_product.product.total_price, :unit => "€")},
    	{"name"=>"product_total", "content"=>number_to_currency(user_product.product.total_price, :unit => "€")},
    	{"name"=>"subtotal", "content"=>number_to_currency(user_product.product.total_price, :unit => "€")},
    	{"name"=>"total", "content"=>number_to_currency(user_product.product.total_price, :unit => "€")},
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
			      "email"=>"#{user_product.user.email}",
			      "name"=>"#{user_product.user.name}"}],
			"from_name"=>"Aiesec Alumni International",
			"tracking_domain"=>nil,
			"subject"=>"Your purchase on Alumnet",
			"signing_domain"=>nil,
			"auto_html"=>true,
			"track_opens"=>true,
			"from_email"=>"alumnet-noreply@aiesec-alumni.org",
			"auto_text"=>true,
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