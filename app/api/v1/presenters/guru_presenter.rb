module GG
  module API
    module V1
      module Presenters
        class GuruPresenter
          attr_accessor :guru

          def initialize(guru)
            self.guru = guru
          end

          def present
            {
              avatar: guru.avatar,
              deals: present_deals,
              followersCount: guru.followers.count,
              id: guru.id,
              location: guru.location,
              pageTitle: guru.page_title,
              userUuid: guru.user_uuid,
              username: guru.username
            }
          end

          private

          def present_deals
            guru.deals.collect do |deal|
              {
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
end
