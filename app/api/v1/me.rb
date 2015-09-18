module TA
  module API
    module V1
      class Me < Grape::API
      attr_accessor :client

      def get
        byebug
        data = Clients::TrackerApi.get("/me").body

        Me.new(data)
      end
    end
  end
  end
  end
