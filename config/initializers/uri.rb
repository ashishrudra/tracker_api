class GrouponUri < Grape::Validations::Base
  GROUPON_STAGING = /^https?:\/\/(w{3}\.)?staging.groupon.com\/deals\/[\S]+/
  INVALID_MESSAGE = "Please provide a valid Groupon Staging URL.".freeze

  def validate_param!(attr_name, params)
    unless params[attr_name] =~ GROUPON_STAGING
      raise(GG::Errors::InvalidCondition, INVALID_MESSAGE)
    end
  end
end
