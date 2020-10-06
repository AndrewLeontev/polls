class Poll < ActiveRecord::Base
  belongs_to :author,
             class_name: 'User',
             foreign_key: :author_id
  has_many :answer,
           class_name: 'Answer',
           foreign_key: :poll_id,
           dependent: :destroy

  validates :question,
            uniqueness: { case_sensitive: false },
            presence: true,
            length: { minimum: 5 }

  before_create :add_author

  def voted? (id)
    self.answer.where(user_id: id).present?
  end

  private

  def add_author
    self.author = User.current
  end
end
