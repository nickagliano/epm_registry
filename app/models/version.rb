class Version < ApplicationRecord
  belongs_to :package

  validates :version, presence: true
  validates :git_url, presence: true
  validates :commit_sha, presence: true
  validates :manifest_hash, presence: true
  validates :version, uniqueness: { scope: :package_id }

  scope :not_yanked, -> { where(yanked: false) }
end
