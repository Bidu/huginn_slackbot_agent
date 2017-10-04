require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::SlackbotAgent do
  before(:each) do
    @valid_options = Agents::SlackbotAgent.new.default_options
    @checker = Agents::SlackbotAgent.new(:name => "SlackbotAgent", :options => @valid_options)
    @checker.user = users(:bob)
    @checker.save!
  end

  pending "add specs here"
end
