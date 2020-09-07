# frozen_string_literal: true

require_relative 'base.rb'

module RaveRuby
  class UssdBase < Base
    # method to handle ussd charge response
    def handle_charge_response(response, request)
      charge_response = response
      flwRef = charge_response['data']['flwRef']
      txRef = charge_response['data']['txRef']
      status = charge_response['data']['status']
      amount = charge_response['data']['amount']
      charged_amount = charge_response['data']['charged_amount']
      currency = charge_response['data']['currency']
      payment_type = charge_response['data']['paymentType']
      charge_response_code = charge_response['data']['chargeResponseCode']
      charge_response_message = charge_response['data']['chargeResponseMessage']
      validation_instruction = charge_response['data']['validateInstructions']

      bank_list = {'gtb' => '058', 'zenith' => '057'}
      gtb_response_text = "To complete this transaction, please dial *737*50*#{charged_amount.ceil}*159#"

      if charge_response_code == '02'
        if request['accountbank'] == bank_list['gtb']
          res = {"error": false, "status": status, "validation_required": true, "txRef": txRef, "flwRef": flwRef, "validateInstruction": gtb_response_text, "amount": amount, "currency": currency, "paymentType": payment_type}
          JSON.parse(res.to_json)
        else
          res = {"error": false, "status": status, "validation_required": true, "txRef": txRef, "flwRef": flwRef, "validateInstruction": validation_instruction, "amount": amount, "currency": currency, "paymentType": payment_type}
          JSON.parse(res.to_json)
        end
      else
        res = {"error": false, "status": status, "validation_required": false, "txRef": txRef, "flwRef": flwRef, "amount": amount, "currency": currency, "paymentType": payment_type}
        JSON.parse(res.to_json)
      end
    end

    # method to handle ussd verify response
    def handle_verify_response(response)
      verify_response = response
      flwref = verify_response['data']['flwref']
      txref = verify_response['data']['txref']
      status = verify_response['data']['status']
      charged_amount = verify_response['data']['chargedamount']
      amount = verify_response['data']['amount']
      vbvmessage = verify_response['data']['vbvmessage']
      vbvcode = verify_response['data']['vbvcode']
      currency = verify_response['data']['currency']
      charge_code = verify_response['data']['chargecode']
      charge_message = verify_response['data']['chargemessage']

      if charge_code == '00' && status == 'successful'
        res = {"error": false, "status": status, "transaction_complete": true, "txref": txref, "flwref": flwref, "amount": amount, "chargedamount": charged_amount, "vbvmessage": vbvmessage, "vbvcode": vbvcode, "currency": currency, "chargecode": charge_code, "chargemessage": charge_message}
        JSON.parse(res.to_json)
      else
        res = {"error": false, "status": status, "transaction_complete": false, "txref": txref, "flwef": flwref, "amount": amount, "chargedamount": charged_amount, "vbvmessage": vbvmessage, "vbvcode": vbvcode, "currency": currency, "charge_code": charge_code, "chargemessage": charge_message}
        JSON.parse(res.to_json)
      end
    end
  end
end
