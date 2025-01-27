class ReviewsController < ApplicationController
  before_action :set_game, only: [ :create ]
  before_action :authenticate_user!, only: [ :create ]

  def create
    @review = @game.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      render turbo_stream: turbo_stream.append("reviews", partial: "reviews/review", locals: { review: @review })
    else
      render turbo_stream: turbo_stream.replace("errors", partial: "shared/errors", locals: { resource: @review })
    end
  end

  private

  def review_params
    params.require(:review).permit(:body, :game_id, :user_id)
  end

  def set_game
    @game = Game.find(params[:game_id])
  end
end
