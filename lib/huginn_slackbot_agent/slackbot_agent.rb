require 'slack'

module Agents
  class SlackbotAgent < Agent
    gem_dependency_check { defined?(Slack) }

    cannot_be_scheduled!

    description <<-MD
      This agent instanciate a slack bot and send messages.

      Generate a slack bot token [here](https://my.slack.com/services/new/bot), and put into a credential called `slack_bot_token`

      To send messages, just fill the options as a documented [here](https://api.slack.com/methods/chat.postMessage)

      The bot needs to be in channel to send messages in it.
    MD

    def default_options
      {
        'channel' => '',
        'text' => '',
        'as_user' => true,
        'attachments' => []
      }
    end

    def validate_options
      errors.add(:base, 'you need to specify the channel or user name') unless options['channel'].present?
      errors.add(:base, 'you need to specify the text or attachments list') unless options['text'].present? || options['attachments'].any?
    end

    def working?
      received_event_without_error?
    end

    def receive(incoming_events)
      incoming_events.each do |event|
        interpolate_with(event) do
          options = {
            channel: interpolated['channel'],
            as_user: interpolated['as_user']
          }

          options[:text] = interpolated['text'] if interpolated['text'].present?
          options[:attachments] = interpolated['attachments'] if interpolated['attachments'].present? && interpolated['attachments'].any?

          client.chat_postMessage(options)
        end
      end
    end

    private

    def client
      return @client if @client.present?

      Slack.configure do |config|
        config.token = credential('slack_bot_token')
      end

      @client = Slack::Web::Client.new
    end
  end
end
