class Conversation < ApplicationRecord
  has_many :conversation_users, dependent: :delete_all 
  has_many :messages,           dependent: :delete_all

  has_many :users,              through:   :conversation_users

  scope :match, -> (){ joins( :conversation_users ).where( ended_at: nil ).group( "conversations.id" ).having( 'count(user_id) < 2' ).order( "Random()" ).first }

  def other_user( current_user )
    self.users.where.not( id: current_user.id ).first
  end
end
