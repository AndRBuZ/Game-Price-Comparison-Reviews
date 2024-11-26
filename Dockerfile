# Dockerfile
FROM ruby:3.2.3

WORKDIR /app

# Install postgres-client
RUN apt-get update && apt-get install -y postgresql-client

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Install the dependencies
RUN bundle install

# Copy the application code into the container
COPY . .

# Set up environment
ENV RAILS_ENV=development

# Expose the port for the Rails server
EXPOSE 3000

# Run the command to start the Rails server when the container starts
CMD ["rails", "s", "-p", "3000", "-b", "0.0.0.0"]
