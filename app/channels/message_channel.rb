class MessageChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "messages"
  end

  def unsubscribed
    stop_all_streams
    # Any cleanup needed when channel is unsubscribed
  end

  def show
  end
end
