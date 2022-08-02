class User < ApplicationRecord
    # has_many :orders
    has_many :reviews
    has_many :restaurants, through: :reviews
end
