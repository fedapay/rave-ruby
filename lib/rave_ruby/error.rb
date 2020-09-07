# frozen_string_literal: true

module RaveRuby
  class RaveError < StandardError; end

  class RaveServerError < RaveError
    attr_reader :response
    def initialize(response = nil)
      @response = response
    end
  end

  class RaveBadKeyError < RaveError
  end

  class IncompleteParameterError < RaveError
  end

  class SuggestedAuthError < RaveError
  end

  class RequiredAuthError < RaveError
  end

  class InitiateTransferError < RaveError
  end

  class CreatePaymentPlanError < RaveError
  end

  class ListPaymentPlanError < RaveError
  end

  class FetchPaymentPlanError < RaveError
  end

  class CancelPaymentPlanError < RaveError
  end

  class EditPaymentPlanError < RaveError
  end

  class ListSubscriptionError < RaveError
  end

  class FetchSubscriptionError < RaveError
  end

  class CancelSubscriptionError < RaveError
  end

  class ActivateSubscriptionError < RaveError
  end
end
