require 'sinatra'
require 'dry-validation'
require 'json'

require_relative './boarding_service'

class BoardingApp < Sinatra::Base
  post '/tester/' do
    content_type :json
    request_schema = Dry::Validation.Form do
      required(:email).filled(:str?)
      required(:first_name).filled(:str?)
      required(:last_name).filled(:str?)
    end

    request_data = JSON.parse(request.body.read)
    validated = request_schema.(request_data)

    unless validated.success?
      status 400
      return validated.messages.to_json
    end

    service = BoardingService.new

    unless service.get_tester(request_data['email']).nil?
      status 400
      return { :email => 'Tester with that email already exists.' }.to_json
    end

    service.add_tester(
        request_data['email'],
        request_data['first_name'],
        request_data['last_name']
    )

    status 201
  end
end
