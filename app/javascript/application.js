// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import { Turbo } from "@hotwired/turbo-rails"

// render turbo_stream: turbo_stream.action(:redirect, login_path)
Turbo.StreamActions.redirect = function () {
  Turbo.visit(this.target)
}
