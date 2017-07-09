class RailsGirl < ApplicationRecord

  validates :name, presence: true
  validates :message, presence: true, uniqueness: { scope: :name }

  after_create :_broadcast_message

  private

  def _broadcast_message
    ActionCable.server.broadcast "messages", name: name, message: message
  end
end
