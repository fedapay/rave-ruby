# frozen_string_literal: true

module RaveRuby
  class RaveServerError < StandardError
    attr_reader :response
    def initialize(response = nil)
      @response = response
    end
  end

  class RaveBadKeyError < RaveServerError
  end

  class IncompleteParameterError < RaveServerError
  end

  class SuggestedAuthError < RaveServerError
  end

  class RequiredAuthError < RaveServerError
  end

  class InitiateTransferError < RaveServerError
  end

  class CreatePaymentPlanError < RaveServerError
  end

  class ListPaymentPlanError < RaveServerError
  end

  class FetchPaymentPlanError < RaveServerError
  end

  class CancelPaymentPlanError < RaveServerError
  end

  class EditPaymentPlanError < RaveServerError
  end

  class ListSubscriptionError < RaveServerError
  end

  class FetchSubscriptionError < RaveServerError
  end

  class CancelSubscriptionError < RaveServerError
  end

  class ActivateSubscriptionError < RaveServerError
  end
end
