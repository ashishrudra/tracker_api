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
              deals: present_deals,
              followersCount: guru.followers.count,
              userUuid: guru.user_uuid,
              username: guru.username,
              uuid: guru.id
            }
          end

          private

          def present_deals
            guru.deals.collect do |deal|
              {
                uuid: deal.id,
                permalink: deal.permalink
              }
            end
          end
        end
      end
    end
  end
end
