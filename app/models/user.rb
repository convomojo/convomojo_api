class User < ApplicationRecord
  has_secure_token
  has_secure_password
  before_validation :downcase_email

  has_many :conversation_users, dependent: :delete_all
  has_many :conversations,      through:   :conversation_users
  has_many :messages,           dependent: :delete_all

  validates :password, presence:   true 

  validates :username, uniqueness: { case_sensitive: false },
                       presence:   true
                       
  validates :email,    format:     { with: URI::MailTo::EMAIL_REGEXP } ,
                       uniqueness: { case_sensitive: false },
                       presence:   true

  def current_conversation 
    self.conversations.where( ended_at: nil )
  end

  private; def downcase_email
    self.email = self.email.downcase if self.email.present?
  end

end
