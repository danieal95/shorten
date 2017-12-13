class Log < ApplicationRecord
  belongs_to :short
  validates :seen, presence: true
end
