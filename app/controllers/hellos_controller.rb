class HellosController < ApplicationController
  def show
    @railsgirls = RailsGirl.order(created_at: :desc)
  end
end
