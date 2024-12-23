class GameDataSaver
  def initialize(game_data, marketplace)
    @game_data = game_data
    @marketplace = marketplace
  end

  def process_and_save
    ActiveRecord::Base.transaction do
      game = save_game
      save_genres(game)
      save_game_marketplace(game)
    end
  end

  private

  def save_game
    game_attributes = {
      name: @game_data[:game][:name],
      description: @game_data[:game][:description],
      developer: @game_data[:game][:developer],
      publisher: @game_data[:game][:publisher],
      released_at: @game_data[:game][:released_at]
    }

    game = Game.find_or_initialize_by(name: game_attributes[:name])
    game.update!(game_attributes)
    game
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to save game: #{e.message}"
    raise
  end

  def save_genres(game)
    @game_data[:genres].each do |genre_name|
      genre = Genre.find_or_create_by!(name: genre_name)
      game.genres << genre unless game.genres.include?(genre)
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to save genres: #{e.message}"
    raise
  end

  def save_game_marketplace(game)
    game_marketplace = game.game_marketplaces.find_or_initialize_by(steam_id: @game_data[:steam_id])
    game_marketplace.update!(
      marketplace: @marketplace,
      price: @game_data[:price],
      steam_id: @game_data[:steam_id]
    )
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to save game marketplace: #{e.message}"
    raise
  end
end
