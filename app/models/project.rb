class Project < ApplicationRecord
  enum :status, { draft: 0, in_progress: 1, completed: 2 }

  has_many :comments

  validates :name, presence: true
  validates :status, presence: true
end
