# frozen_string_literal: true

require 'httparty'
require_relative '../../rave_modules/base_endpoints'
require 'json'
require_relative '../../error'

module RaveRuby
  class Base
    attr_reader :rave_object, :get_hashed_key

    # method to initialize this class

    def initialize(rave_object = nil)
      raise ArgumentError, 'Rave Object is required!!!' if rave_object.nil?

      @rave_object = rave_object
    end

    # method to get the hashed secret key
    def get_hashed_key
      hash = Digest::MD5.hexdigest(rave_object.secret_key)
      last_twelve = hash[hash.length - 12..hash.length - 1]
      private_secret_key = rave_object.secret_key.dup
      private_secret_key['FLWSECK-'] = ''
      first_twelve = private_secret_key[0..11]
      first_twelve + last_twelve
    end

    # method to make a get request
    def get_request(endpoint, data = {})
      http_params = {}
      http_params[:query] = data unless data.empty?

      begin
          response = HTTParty.get(endpoint, http_params)
          unless response.code == 200 || response.code == 201
            raise RaveServerError.new(response), "HTTP Code #{response.code}: #{response.body}"
          end

          # response_body = response.body

          return response

          raise RaveServerError.new(response), "Server Message: #{response.message}" unless response.code != 0
      rescue JSON::ParserError => e
        raise RaveServerError.new(response), "Invalid result data. Could not parse JSON response body \n #{e.message}"

        # rescue RaveServerError => e
        #   Util.serverErrorHandler(e)
        # end

        response
        end
    end

    # method to make a post request
    def post_request(endpoint, data)
      response = HTTParty.post(endpoint, {
                                 body: data,
                                 headers: {
                                   'Content-Type' => 'application/json'
                                 }
                               })

      unless response.code == 200 || response.code == 201
        raise RaveServerError.new(response), "HTTP Code #{response.code}: #{response.body}"
      end

      response
    end

    # method to check if the passed parameters is equal to the expected parameters
    def check_passed_parameters(required_params, passed_params)
      # This is used to check if the passed authorization parameters matches the required parameters
      required_params.each do |k, _v|
        unless passed_params.key?(k)
          raise IncompleteParameterError, "Parameters Incomplete, Missing Parameter: #{k}, Please pass in the complete parameter."
        end
        # return true
      end
    end

    # method to handle list bank response
    def handle_list_bank(response)
      list_bank = response

      if list_bank.code == 200
        response = { 'error' => false, 'data' => JSON.parse(list_bank.body) }
        response
      else
        response = { 'error' => true, 'data' => JSON.parse(list_bank.body) }
        response
        # raise InitiateTransferError, response
      end
    end
  end
end
