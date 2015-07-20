module PaymentableMethods

  def self.included(base)
    base.has_many :payments, as: :paymentable, dependent: :destroy
  end

  # def add_like_by(user)
  #   likes.create(user: user)
  # end

  def has_payment_for?(user)
    payments.exists?(user: user)
  end
end