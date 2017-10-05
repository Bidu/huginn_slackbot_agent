require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::SlackbotAgent do
  before(:each) do
    @valid_options = Agents::SlackbotAgent.new.default_options
    @checker = Agents::SlackbotAgent.new(:name => "SlackbotAgent", :options => @valid_options)
    @checker.user = users(:bob)
    @checker.save!

    @event = Event.new
    @event.agent = agents(:bob_weather_agent)
    @event.payload = {
      'somekey' => 'Somevalue',
      'some_date' => 'May 23'
    }

    @expected_token = 'abc123'
    @credential = UserCredential.create(
      credential_name: 'slack_bot_token',
      user: users(:bob),
      credential_value: @expected_token,
      mode: 'text'
    )

    @sent_requests = Array.new

    stub_request(:post, 'https://slack.com/api/chat.postMessage').to_return do |request|
      response_body = {
        ok: true,
        channel: 'G694SPM35',
        ts: '1507236820.000421',
        message: {
          type: 'message',
          user: 'U0CEL68F3',
          text: 'teste',
          bot_id: 'B349SNYN9',
          ts: '1507236820.000421'
        }
      }

      @sent_requests << request

      { status: 200, body: ActiveSupport::JSON.encode(response_body), headers: { "Content-type" => "application/json" } }
    end
  end

  describe '#working?' do
    it 'checks if events have error' do
      @checker.error 'something got wrong'
      expect(@checker.reload).not_to be_working # There is a recent error
    end
  end

  describe '#receive' do
    it 'call slack api when receive an event' do
	    @checker.receive([@event])
      expect(@sent_requests.length).to eq(1)
	  end

    it 'should include configured token into request' do
      @checker.receive([@event])
      expect(@sent_requests.first.body.include? "token=#{@expected_token}").to be_truthy
    end
  end
end
