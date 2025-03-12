module Liked
  extend ActiveSupport::Concern

  included do
    before_action :set_likeable, :set_reaction, only: [ :like, :dislike ]
  end

  def like
    process_reaction(:like)
  end

  def dislike
    process_reaction(:dislike)
  end

  private

  def set_likeable
    @likeable = controller_name.classify.constantize.find(params[:id])
  end

  def set_reaction
    @reaction = @likeable.likes.find_by(user: current_user)
  end

  def process_reaction(reaction)
    if !@reaction.present?
      create_reaction(reaction)
    elsif @reaction.reaction == "#{reaction}"
      remove_reaction
    else
      update_reaction(reaction)
    end
  end

  def create_reaction(reaction)
    @reaction = Like.new(user: current_user, likeable: @likeable, reaction: reaction)
    render_reaction_update if @reaction.save
  end

  def remove_reaction
    @reaction.destroy
    render_reaction_update
  end

  def update_reaction(reaction)
    @reaction.update(reaction: reaction)
    render_reaction_update
  end

  def render_reaction_update
    render turbo_stream: turbo_stream.update("#{model_key}-#{@likeable.id}", partial: model_partial_path, locals: { "#{model_key}": @likeable })
  end

  def model_key
    @likeable.model_name.param_key
  end

  def model_partial_path
    "#{model_key}s/#{model_key}"
  end
end
