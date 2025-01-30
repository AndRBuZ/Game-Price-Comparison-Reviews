class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [ :create ]
  before_action :set_game, only: [ :create ]
  before_action :set_review, only: [ :destroy, :update, :edit ]

  def create
    @review = @game.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      render turbo_stream: turbo_stream.append("reviews", partial: "reviews/review", locals: { review: @review })
    else
      render turbo_stream: turbo_stream.replace("errors", partial: "shared/errors", locals: { resource: @review })
    end
  end

  def update
    if @review.update(review_params)
      render turbo_stream: turbo_stream.replace("edit-review-#{@review.id}", partial: "reviews/review", locals: { review: @review })
    else
      render turbo_stream: turbo_stream.replace("errors", partial: "shared/errors", locals: { resource: @review })
    end
  end

  def edit
    render turbo_stream: turbo_stream.replace("review-#{@review.id}", partial: "reviews/edit", locals: { review: @review })
  end

  def destroy
    render turbo_stream: turbo_stream.remove("review-#{@review.id}") if @review.destroy
  end

  private

  def review_params
    params.require(:review).permit(:body, :game_id, :user_id)
  end

  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end
end
