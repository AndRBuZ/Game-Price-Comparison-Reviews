# README

- **What is the purpose of this application?**
  This application is designed to track and display the prices of video games across various platforms like Steam and Xbox. It fetches game details and prices from their respective APIs and stores them in a database.

- **How does the price update mechanism work?**
  The application uses background jobs scheduled with Clockwork to periodically fetch and update game prices. These jobs call the respective API services (e.g., `SteamApiService`, `XboxApiService`) to retrieve the latest price information.

- **What are the main components of the application?**
    - **Models:** Represent the data structure of the application, such as `Game`, `Marketplace`, `GameMarketplace`, `Genre`, `User`.
    - **Services:** Handle the logic for interacting with external APIs (e.g., `SteamApiService`, `XboxApiService`) and processing the data.
    - **Jobs:** Manage background tasks, such as updating game prices (`SteamUpdatePricesJob`).
    - **Controllers:** Handle user requests.
    - **Views:** Display the data to the user.
    - **Database:** Stores the game and price information.

- **How to add a new game?**
  Currently, adding new games by using the `rails console` command. Use API Services to get the game details and add it to the database.

- **How to run tests?**
  To run tests inside the Docker container:
  ```bash
  docker compose run --rm web RAILS_ENV=test rspec
  ```

- **Installation**
  1. Build the Docker image:
     ```bash
     docker compose build
     ```
  2. Start the Docker containers:
     ```bash
     docker compose up
     ```
  3. Inside the running `web` container, run the following commands:
     ```bash
     bundle install
     rails db:migrate
     rails db:seed
     ```

- **How to run the server?**
  ```bash
  docker compose up
  ```
  inside the running `web` container, run the following command to start the server, and tailwind. Server will be available at `http://localhost:3000`:
  ```bash
  rails s -b 0.0.0.0
  rails tailwind:watch
  ```
  You can also run the server with `foreman start -f Procfile.dev` to start the server and tailwind. This will start the server at `http://localhost:5000`

- **Architecture**
    - **Rails 8:** The application is built using the Ruby on Rails framework, which provides a robust structure for web development.
    - **Docker:** The application is containerized using Docker, ensuring consistent deployment across different environments.
    - **Clockwork:** Used for scheduling background jobs to update game prices periodically.
    - **PostgreSQL:** The database used to store game and price information.
    - **HTML/Slim:** Slim is used as the templating engine for generating HTML views.
    - **TailwindCSS:** A utility-first CSS framework used for styling the application.
    - **RSpec:** Used for writing and running tests.
