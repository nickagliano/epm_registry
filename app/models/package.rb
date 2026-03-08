class Package < ApplicationRecord
  has_many :versions, dependent: :destroy

  validates :name, presence: true, uniqueness: true,
                   format: { with: /\A[a-z][a-z0-9_]{1,63}\z/,
                             message: "must be lowercase letters, digits, or underscores, starting with a letter" }
  validates :description, presence: true
  validates :license, presence: true
  validates :repository, presence: true

  scope :by_name, -> { order(:name) }
  scope :search, ->(q) { where("name ILIKE ? OR description ILIKE ?", "%#{q}%", "%#{q}%") }
end
