# frozen_string_literal: true

require_relative 'rave_ruby/rave_modules/base_endpoints'
require_relative 'rave_ruby/rave_objects/base/base'
require_relative 'rave_ruby/rave_modules/util'
require_relative 'rave_ruby/rave_objects/list_banks'
require_relative 'rave_ruby/rave_objects/card'
require_relative 'rave_ruby/rave_objects/account'
require_relative 'rave_ruby/rave_objects/transfer'
require_relative 'rave_ruby/rave_objects/mpesa'
require_relative 'rave_ruby/rave_objects/mobile_money'
require_relative 'rave_ruby/rave_objects/uganda_mobile_money'
require_relative 'rave_ruby/rave_objects/zambia_mobile_money'
require_relative 'rave_ruby/rave_objects/payment_plan'
require_relative 'rave_ruby/rave_objects/subscription'
require_relative 'rave_ruby/rave_objects/ussd'
require_relative 'rave_ruby/rave_objects/preauth'
require_relative 'rave_ruby/rave_objects/sub_account'
require_relative 'rave_ruby/error'

module RaveRuby
class Rave
  attr_accessor :public_key, :secret_key, :production, :url

  # method to initialize rave object

  def initialize(public_key = nil, secret_key = nil, production = false)
    @public_key = public_key
    @secret_key = secret_key
    @production = production
    rave_sandbox_url = BASE_ENDPOINTS::RAVE_SANDBOX_URL
    rave_live_url = BASE_ENDPOINTS::RAVE_LIVE_URL

    # set rave url to sandbox or live if we are in production or development
    @url = if production == false
             rave_sandbox_url
           else
             rave_live_url
           end

    # check if we set our public and secret keys to the environment variable
    if public_key.nil? && secret_key.nil?
      @public_key = ENV['RAVE_PUBLIC_KEY']
      @secret_key = ENV['RAVE_SECRET_KEY']
    else
      @public_key = public_key
      @secret_key = secret_key
      warn 'Warning: To ensure your rave account api keys are safe, It is best to always set your keys in the environment variable'
    end

    # raise this error if no public key is passed
    if @public_key.nil?
      raise RaveBadKeyError, "No public key supplied and couldn't find any in environment variables. Make sure to set public key as an environment variable RAVE_PUBLIC_KEY"
    end
    # raise this error if invalid public key is passed
    raise RaveBadKeyError, "Invalid public key #{@public_key}" unless @public_key[0..6] == 'FLWPUBK'

    # raise this error if no secret key is passed
    if @secret_key.nil?
      raise RaveBadKeyError, "No secret key supplied and couldn't find any in environment variables. Make sure to set secret key as an environment variable RAVE_SECRET_KEY"
    end
    # raise this error if invalid secret key is passed
    raise RaveBadKeyError, "Invalid secret key #{@secret_key}" unless @secret_key[0..6] == 'FLWSECK'
  end

  # method to return the base url
  def base_url
    url
  end
end
end
