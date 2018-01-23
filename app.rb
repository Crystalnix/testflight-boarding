require 'sinatra/base'
require 'dry-validation'
require 'json'
require 'securerandom'

require_relative './boarding_service'

class BoardingApp < Sinatra::Base
  post '/tester/' do
    content_type :json
    request_schema = Dry::Validation.Form do
      required(:apple_id).filled(:str?)
      required(:first_name).filled(:str?)
      required(:last_name).filled(:str?)
    end

    request_data = JSON.parse(request.body.read)
    validated = request_schema.(request_data)

    unless validated.success?
      status 400
      return validated.messages.to_json
    end

    begin
      service = BoardingService.new

      unless service.get_tester(request_data['apple_id']).nil?
        status 400
        return {
            :apple_id => ['Beta tester with that Apple ID already exists.']
        }.to_json
      end

      service.add_tester(
          request_data['apple_id'],
          request_data['first_name'],
          request_data['last_name']
      )
    rescue Exception => exception
      status 424
      Raven.capture_message(
          "Unable to register #{request_data['apple_id']} in TestFlight",
          :tags => {:apple_id => request_data['apple_id']},
          :user => {:email => request_data['apple_id']},
          :fingerprint => [SecureRandom.uuid.to_s],
          :extra => {:exception => exception.message}
      )

      return
    end

    status 201
    {}.to_json
  end
end
