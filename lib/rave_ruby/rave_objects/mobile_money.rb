# frozen_string_literal: true

require_relative 'base/mobile_money_base.rb'
require 'json'

module RaveRuby
  class MobileMoney < MobileMoneyBase
    # method to initiate mobile money transaction
    def initiate_charge(data)
      base_url = rave_object.base_url
      hashed_secret_key = rave_object.encryption_key
      public_key = rave_object.public_key

      # only update the payload with the transaction reference if it isn't already added to the payload
      data.merge!({'txRef' => Util.transaction_reference_generator}) unless data.key?('txRef')

      # only update the payload with the order reference if it isn't already added to the payload
      data.merge!({'orderRef' => Util.transaction_reference_generator}) unless data.key?('orderRef')

      data.merge!({'PBFPubKey' => public_key, 'payment_type' => 'mobilemoneygh', 'country' => 'GH', 'is_mobile_money_gh' => 1, 'currency' => 'GHS'})

      required_parameters = %w[amount email phonenumber network]
      check_passed_parameters(required_parameters, data)

      encrypt_data = Util.encrypt(hashed_secret_key, data)

      payload = {
        'PBFPubKey' => public_key,
        'client' => encrypt_data,
        'alg' => '3DES-24'
      }

      payload = payload.to_json
      response = post_request("#{base_url}#{BASE_ENDPOINTS::CHARGE_ENDPOINT}", payload)

      handle_charge_response(response)
    end

    # method to verify mobile money transaction
    def verify_charge(txref)
      base_url = rave_object.base_url

      payload = {
        'txref' => txref,
        'SECKEY' => rave_object.secret_key.dup
      }

      payload = payload.to_json

      response = post_request("#{base_url}#{BASE_ENDPOINTS::VERIFY_ENDPOINT}", payload)
      handle_verify_response(response)
    end
  end
end
