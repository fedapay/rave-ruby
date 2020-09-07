# frozen_string_literal: true

require_relative 'base/transfer_base.rb'
require 'json'

module RaveRuby
  class Transfer < TransferBase
    # method to initiate single transfer
    def initiate_transfer(data)
      base_url = rave_object.base_url

      # only update the payload with the transaction reference if it isn't already added to the payload
      data.merge!({'reference' => Util.transaction_reference_generator}) unless data.key?('reference')

      data.merge!({'seckey' => rave_object.secret_key.dup})

      required_parameters = %w[amount currency]
      check_passed_parameters(required_parameters, data)

      payload = data.to_json

      response = post_request("#{base_url}#{BASE_ENDPOINTS::TRANSFER_ENDPOINT}/create", payload)

      handle_initiate_response(response)
    end

    # method to perform bulk transfer request
    def bulk_transfer(data)
      base_url = rave_object.base_url

      data.merge!({'seckey' => rave_object.secret_key.dup})

      required_parameters = %w[title bulk_data]
      check_passed_parameters(required_parameters, data)

      payload = data.to_json

      response = post_request("#{base_url}#{BASE_ENDPOINTS::TRANSFER_ENDPOINT}/create_bulk", payload)

      handle_bulk_response(response)
    end

    # method to perform get fee request
    def get_fee(currency)
      base_url = rave_object.base_url
      response = get_request("#{base_url}#{BASE_ENDPOINTS::GET_FEE_ENDPOINT}", {'seckey' => rave_object.secret_key.dup, 'currency' => currency})
      handle_transfer_status(response)
    end

    # method to perform get balance request
    def get_balance(currency)
      base_url = rave_object.base_url

      payload = {
        'seckey' => rave_object.secret_key.dup,
        'currency' => currency
      }

      payload = payload.to_json

      response = post_request("#{base_url}#{BASE_ENDPOINTS::GET_BALANCE_ENDPOINT}", payload)
      handle_balance_status(response)
    end

    # method to fetch a single transfer
    def fetch(reference)
      base_url = rave_object.base_url
      response = get_request("#{base_url}#{BASE_ENDPOINTS::FETCH_ENDPOINT}", {'seckey' => rave_object.secret_key.dup, 'reference' => reference})
      handle_fetch_status(response)
    end

    # method to fetch all transfers
    def fetch_all_transfers
      base_url = rave_object.base_url
      response = get_request("#{base_url}#{BASE_ENDPOINTS::FETCH_ENDPOINT}", {'seckey' => rave_object.secret_key.dup})
      handle_fetch_status(response)
    end
  end
end
