class PositionsController < ApplicationController
  def index
    render json: Position.all
  end
end