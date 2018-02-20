class Payment < ApplicationRecord
	before_create :set_slug

  validates :customer_name, presence: true
  validates :customer_email, presence: true, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
  validates :local_committee, presence: true
  validates :application_id, presence: true
  validates :program, presence: true
  validates :opportunity_name, presence: true
  validates :slug, uniqueness: true
  validates :value, presence: true

  validate :minimum_value

  belongs_to :local_committee

  enum program: { gv: 0, ge: 1, gt: 2 }
  enum status: {
    processing: 0,
    authorized: 1,
    paid: 2,
    refunded: 3,
    waiting_payment: 4,
    pending_refund: 5,
    refused: 6,
    chargedback: 7,
    created: 8
  }

  enum payment_method: {
    credit_card: 0,
    boleto: 1
  }

  def minimum_value
    errors.add(:value, 'must be bigger than program fee') unless value.to_i > program_fee
  end

  def program_fee
    case program&.to_sym
    when :gv
      return 54738
    when :ge
      return 65101
    when :gt
      return 109245
    else
      return 0
    end
  end

	def to_param
		slug
	end

  private

  def set_slug
    loop do
      self.slug = SecureRandom.hex(8)
      break unless Payment.where(slug: slug).exists?
    end
  end
end
