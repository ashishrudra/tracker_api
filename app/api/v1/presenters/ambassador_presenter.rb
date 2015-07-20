module GA
  module API
    module V1
      module Presenters
        class AmbassadorPresenter
          attr_accessor :ambassador

          def initialize(ambassador)
            self.ambassador = ambassador
          end

          def present
            {
              deals: present_deals,
              email: ambassador.email,
              followers_count: ambassador.followers.count,
              user_uuid: ambassador.user_uuid,
              username: ambassador.username,
              uuid: ambassador.id,
            }
          end

          private

          def present_deals
            ambassador.deals.collect do |deal|
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
