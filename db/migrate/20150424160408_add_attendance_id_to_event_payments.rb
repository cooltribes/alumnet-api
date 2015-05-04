class AddAttendanceIdToEventPayments < ActiveRecord::Migration
  def change
    add_reference :event_payments, :attendance, index: true
  end
end
