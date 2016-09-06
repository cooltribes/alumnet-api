class UserProduct < ActiveRecord::Base
	###Relations
	belongs_to :user
	belongs_to :product

	### Validations
  	validates_presence_of :transaction_type, :user_id

  	def set_membership_dates
  		feature = 'subscription'
	    if product.categories.present?
	      category = product.categories.find_by(name: "Donations")
	      feature = 'donation' if category.present?
	    end

	    self.transaction_type = 1
	    self.feature = feature
	    self.total_price = product.total_price
	    characteristic = product.characteristics.find_by(name: 'Duration')
	    product_characteristic = characteristic.present? ? product.product_characteristics.find_by(characteristic_id: characteristic.id) : nil

  		if(user.member == 0)
	      self.start_date = DateTime.now
	      if product_characteristic.present?
	        self.end_date = DateTime.now + product_characteristic.value.to_i.months
	        self.quantity = product_characteristic.value.to_i
	        user.member = 1
	      else
	        user.member = 3
	      end
	    else
	      #@active_subscription = UserProduct.where(user_id: @user.id, feature: 'subscription', status: 1).last
	      active_subscription = UserProduct.where("user_id=? AND status=1 AND (feature='subscription' OR feature='donation')", user.id).last
	      if active_subscription
	        self.start_date = active_subscription.end_date.present? ? active_subscription.end_date : DateTime.now
	        if product_characteristic.present? && active_subscription.end_date.present?
	          self.end_date = active_subscription.end_date + product_characteristic.value.to_i.months
	          self.quantity = product_characteristic.value.to_i
	          user.member = 1
	        else
	          user.member = 3
	        end
	      else
	        self.start_date = DateTime.now
	        if product_characteristic.present? && active_subscription.end_date.present?
	          self.end_date = DateTime.now + product_characteristic.value.to_i.months
	          self.quantity = product_characteristic.value.to_i
	          user.member = 1
	        else
	          user.member = 3
	        end
	      end

	    end
	    if self.save
	    	user.save
	    	if feature == 'donation'
	    		add_user_to_donations_group
	    	end
	    	true
	    else
	    	false
	    end
  	end

  	def add_user_to_donations_group
  		if Rails.env.production?
  			group = Group.find(283)
  			if group.present?
	  			membership = group.build_membership_for(user, true)
	    		membership.save
	    	end
  		end
  	end
end
