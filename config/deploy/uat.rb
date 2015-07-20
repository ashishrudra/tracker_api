server("GEEKON34.snc1", { roles: %w(app db utility worker), user: fetch(:user), primary: true })
