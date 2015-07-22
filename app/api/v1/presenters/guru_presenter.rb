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
              username: guru.username,
              writeup: guru.writeup
            }
          end

          private

          def present_deals
            guru.guru_deals.collect do |guru_deal|
              deal = guru_deal.deal
              {
                id: deal.id,
                uuid: deal.deal_uuid,
                permalink: deal.permalink,
                is_cover: guru_deal.is_cover,
                notes: guru_deal.notes
              }
            end
          end
        end
      end
    end
  end
end
