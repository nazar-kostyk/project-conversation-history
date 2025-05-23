class Project < ApplicationRecord
  enum :status, { draft: 0, in_progress: 1, completed: 2 }

  validates :name, presence: true
  validates :status, presence: true
end
