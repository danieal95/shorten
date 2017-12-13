class Short < ApplicationRecord
  has_many :logs
  validates :url, presence: true
  validates :shortcode, presence: true
end
