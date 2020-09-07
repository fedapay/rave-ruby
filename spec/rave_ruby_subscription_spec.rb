# frozen_string_literal: true

require 'spec_helper'
require 'rave_ruby/rave_objects/subscription'

# test_public_key = "FLWPUBK-xxxxxxxxxxxxxxxxxxxxx-X"
# test_secret_key = "FLWSECK-xxxxxxxxxxxxxxxxxxxxx-X"

payload = {
  'amount' => 500,
  'name' => 'Ifunanya Ikemma',
  'interval' => '5',
  'duration' => 2
}

RSpec.describe Subscription do
  rave = RaveRuby.new(test_public_key, test_secret_key)
  subscription = Subscription.new(rave)

  context 'when a merchant tries to list subscriptions' do
    it 'should return a valid subscription object' do
      expect(subscription.nil?).to eq(false)
    end

    it 'should check if all subscription list is successfully fetched' do
      list_subscription_response = subscription.list_all_subscription
      expect(list_subscription_response['error']).to eq(false)
    end

    it 'should check if a subscription is successfully fetched by transaction id' do
      fetch_subscription_response = subscription.fetch_subscription(426_082)
      expect(fetch_subscription_response['error']).to eq(false)
    end

    it 'should check if a subscription is cancelled by transaction id' do
      cancel_subscription_response = subscription.cancel_subscription(426_082)
      expect(cancel_subscription_response['error']).to eq(false)
    end

    it 'should check if a subscription is successfully activated by transaction id' do
      activate_subscription_response = subscription.activate_subscription(426_082)
      expect(activate_subscription_response['error']).to eq(false)
    end
  end
end
