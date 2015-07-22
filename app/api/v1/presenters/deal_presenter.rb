module GG
  module API
    module V1
      module Presenters
        class DealPresenter
          attr_accessor :deal, :guru

          def initialize(deal, guru=nil)
            self.deal = deal
            self.guru = guru || deal.gurus.first
          end

          def present
            {
              avatar: guru.avatar,
              username: guru.username,
              id: deal.id,
              uuid: deal.deal_uuid,
              permalink: deal.permalink
            }
          end
        end
      end
    end
  end
end
