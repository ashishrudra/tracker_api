module ErrorHandler
  class << self
    def respond(error, code = nil, explicit_data = {})
      presenter = TA::API::V1::Presenters::ErrorPresenter.new(error, code)
      Rack::Response.new([presenter.present.merge(explicit_data).to_json], presenter.code, { "Content-Type" => "application/json" }).finish
    end
  end
end
