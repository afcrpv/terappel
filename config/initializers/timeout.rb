Rack::Timeout.unregister_state_change_observer(:logger) if Rails.env.development?
Rack::Timeout.timeout = Rails.env.test? ? 0 : 20
