class Order < ApplicationRecord
    belongs_to :user
    has_many :products , through: :user
end
