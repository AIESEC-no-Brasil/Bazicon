class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :local_committee, presence: true

  enum local_committee: {
    curitiba: 0,
    brasilia: 1,
    limeira: 2,
    porto_alegre: 3,
    uberlandia: 4
  }
end
