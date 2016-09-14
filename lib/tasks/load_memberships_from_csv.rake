require 'rake'
namespace :data_fixture do
  desc "load subscriptions from given csv file to given database 'rake load_data_from_csv file=db/data/file.csv'"
  task load_memberships_from_csv: :environment do
    file = ENV['file']
    if file
      file = File.open(file)
      options = { col_sep: ","}
      SmarterCSV.process(file, options) do |array|
        user = User.find_by(email: array[0][:email_address])
        if user.present?
          user.validate_subscription
          if user.member ==  0
            product = array[0][:membership_expiration_date] == 'LTM' ? 
              Product.active.includes(:product_characteristics).includes(:characteristics).includes(:categories).where(:product_characteristics => {value: ""}).where(:characteristics => {name: "Duration"}).where(:categories => {name: "Memberships"}).first : 
              Product.active.includes(:product_characteristics).includes(:characteristics).includes(:categories).where(:product_characteristics => {value: 12}).where(:characteristics => {name: "Duration"}).where(:categories => {name: "Memberships"}).first
            if product.present?
              end_date = array[0][:membership_expiration_date] == 'LTM' ? nil : DateTime.parse(array[0][:membership_expiration_date])
              user_member = array[0][:membership_expiration_date] == 'LTM' ? 3 : 1
              user_product = UserProduct.new({
                start_date: DateTime.now,
                end_date: end_date,
                status: 1,
                quantity: nil,
                transaction_type: 1,
                user_id: user.id,
                product_id: product.id,
                feature: 'subscription',
                total_price: product.total_price
                })
              if user_product.save
                user.update(member: user_member)
                end_date = user_product.end_date.present? ? user_product.end_date.strftime("%Y-%m-%d %I:%M%P") : 'LTM'
                product_name = product.present? ? product.name : 'No name available'
                puts 'Membership saved, user: ' + array[0][:email_address] + ' | Product: ' + product_name  + ' | End date: ' + end_date
              else
                puts 'Error saving membership, user: ' + array[0][:email_address]
              end
            else
              puts 'Unable to find right product to assign'
            end
          else
            user_product = UserProduct.find_by(feature: 'subscription', status: 1, user_id: user.id)
            end_date = array[0][:membership_expiration_date] == 'LTM' ? nil : DateTime.parse(array[0][:membership_expiration_date])
            end_date_text = array[0][:membership_expiration_date] == 'LTM' ? 'LTM' : DateTime.parse(array[0][:membership_expiration_date]).to_s
            product_name = user_product.product.present? ? user_product.product.name : 'No name available'
            user_product.update(end_date: end_date) if user_product.present?
            puts 'User has membership already: ' + array[0][:email_address] + ' | Product: ' + product_name  + ' | End date: ' + end_date_text
          end
        else
          puts 'User not found: ' + array[0][:email_address]
        end
      end
      file.close
    else
      puts "You must set file 'rake load_data_from_csv file=db/data/file.csv'"
    end
  end
end