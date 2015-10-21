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
        if user
          if user.member ==  0
            end_date = nil
            user_member = 1
            quantity = nil
            product = Product.where(feature: 'subscription', quantity: nil).first
            if array[0][:membership_expiration_date] != 'LTM'
              end_date = DateTime.parse(array[0][:membership_expiration_date])
              user_member = 3
              quantity = (end_date.year * 12 + end_date.month) - (DateTime.now.year * 12 + DateTime.now.month)
              product = Product.where(feature: 'subscription', quantity: 12).first
            end
            user_product = UserProduct.new({
              start_date: DateTime.now,
              end_date: end_date,
              quantity: quantity,
              transaction_type: 1,
              user_id: user.id,
              product_id: product.present? ? product.id : nil,
              feature: 'subscription'
              })
            if user_product.save
              user.update(member: user_member)
            end
            puts 'Membership saved, user: ' + array[0][:email_address]
          else
            puts 'User has membership already: ' + array[0][:email_address]
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