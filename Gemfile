source "https://rubygems.org"

# Our github appliance has an unchangeably low max_startups setting that can lead to a poisoned gem cache on CI.
# The problem with exclusively using https (or rubygems.snc1) is that it requires additional setup on everyone's dev env.
git_source(:groupon) do |repo|
  github = "github.groupondev.com"
  ENV["DOCKER_BUILD"] ? "https://#{github}/#{repo}.git" : "git@#{github}:#{repo}.git"
end

gem "activerecord", "~> 4.2.0", { require: "active_record" }
gem "grape"
gem "pg"
gem "puma"
gem "rake"
gem "sonoma-activerecord", { groupon: "sonoma/sonoma-activerecord" }
gem "sonoma-authentication", { groupon: "sonoma/sonoma-authentication" }
gem "sonoma-colorizer", { groupon: "sonoma/sonoma-colorizer" }
gem "sonoma-dottablehash", { groupon: "sonoma/sonoma-dottablehash" }
gem "sonoma-logger", { groupon: "sonoma/sonoma-logger", require: "sonoma_logger" }
gem "sonoma-monitor", { groupon: "sonoma/sonoma-monitor", require: "sonoma_monitor" }
gem "sonoma-request-id", { groupon: "sonoma/sonoma-request-id" }
gem "steno_logger", { groupon: "steno/steno_ruby" } # dependency of sonoma-logger

group :development, :test do
  gem "bundler-audit"
  gem "byebug"
  gem "dotenv"
  gem "rspec"
  gem "rubocop"
  gem "shotgun"
end
