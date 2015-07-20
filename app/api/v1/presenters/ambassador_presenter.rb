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
              uuid: ambassador.id,
              username: ambassador.username,
              user_uuid: ambassador.user_uuid,
              followers_count: ambassador.followers.count,
              deals: present_deals
            }
          end

          private

          def present_deals
            ambassador.deals.collect do |deal|
              {
                uuid: deal.uuid
              }
            end
          end
        end
      end
    end
  end
end
