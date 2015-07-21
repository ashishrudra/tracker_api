class DealCatalogData
  DEAL_NOT_FOUND = "Deal is not present for permalink %s"
  class << self
    def get_deal_uuid(permalink)
      deal_data = Clients::DealCatalog.get_deal(permalink)
      raise(GG::Errors::InvalidCondition, format(DEAL_NOT_FOUND, permalink)) if deal_data.blank? || deal_data[:deal].blank?

      deal_data[:deal][:id]
    end
  end
end
