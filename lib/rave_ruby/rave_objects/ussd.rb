# frozen_string_literal: true

require_relative 'base/ussd_base.rb'
require 'json'

module RaveRuby
  class Ussd < UssdBase
    # method to initiate ussd transaction
    def initiate_charge(data)
      base_url = rave_object.base_url
      hashed_secret_key = rave_object.encryption_key
      public_key = rave_object.public_key

      # only update the payload with the transaction reference if it isn't already added to the payload
      data.merge!({'txRef' => Util.transaction_reference_generator}) unless data.key?('txRef')

      # only update the payload with the order reference if it isn't already added to the payload
      data.merge!({'orderRef' => Util.transaction_reference_generator}) unless data.key?('orderRef')

      data.merge!({'PBFPubKey' => public_key, 'is_ussd' => '1', 'payment_type' => 'ussd'})

      required_parameters = %w[accountbank accountnumber amount email phonenumber IP]
      check_passed_parameters(required_parameters, data)

      encrypt_data = Util.encrypt(hashed_secret_key, data)

      payload = {
        'PBFPubKey' => public_key,
        'client' => encrypt_data,
        'alg' => '3DES-24'
      }

      payload = payload.to_json
      response = post_request("#{base_url}#{BASE_ENDPOINTS::CHARGE_ENDPOINT}", payload)

      handle_charge_response(response, data)
    end

    # method to verify ussd transaction
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
