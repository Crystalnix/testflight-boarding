require 'spaceship'


class BoardingService

  attr_accessor :app
  attr_accessor :tester_group_name

  def initialize
    spaceship = Spaceship::Tunes.login(ENV['ITC_USER'], @password = ENV['ITC_PASSWORD'])
    spaceship.select_team
    @app = Spaceship::Tunes::Application.find(ENV['ITC_APP_ID'])

    init_tester_group(ENV['ITC_APP_TESTER_GROUP'])
  end

  def init_tester_group(group_id)
    ids = get_groups.map { |group| group }.to_a
    group = ids.find { |group| group.id == group_id }

    if group === nil
      raise "Group with id #{group_id} not found."
    end

    @tester_group_name = group.name
  end

  def get_tester(email)
    Spaceship::TestFlight::Tester.find(app_id: @app.apple_id, email: email)
  end

  def add_tester(email, first_name, last_name)
    tester = create_tester(
        email,
        first_name,
        last_name
    )
    begin
      Spaceship::TestFlight::Group.add_tester_to_groups!(
          tester: tester,
          app: @app,
          groups: [@tester_group_name]
      )
    rescue => ex
      Rails.logger.error "Could not add #{tester.email} to app: #{app.name}"
      raise ex
    end
  end

  private
  def create_tester(email, first_name, last_name)
      Spaceship::TestFlight::Tester.create_app_level_tester(
          app_id: @app.apple_id,
          first_name: first_name,
          last_name: last_name,
          email: email
      )

      Spaceship::TestFlight::Tester.find(app_id: app.apple_id, email: email)
  end

  def get_groups
    Spaceship::TestFlight::Group.filter_groups(app_id: @app.apple_id)
  end
end
