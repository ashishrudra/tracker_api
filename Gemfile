source("https://rubygems.org")

# Our github appliance has an unchangeably low max_startups setting that can lead to a poisoned gem cache on CI.
# The problem with exclusively using https (or rubygems.snc1) is that it requires additional setup on everyone's dev env.
# We can't use `git_source` because deploy_bot is running an older version of bundler.
def groupon_path(repo)
  github = "github.groupondev.com"
  ENV["INTERNAL_GEMS_OVER_SSH"] ? "git@#{github}:#{repo}.git" : "https://#{github}/#{repo}.git"
end

gem "activerecord", "~> 4.2.0", { require: "active_record" }
gem "grape"
gem "pg"
gem "puma"
gem "rake"
gem "sonoma-activerecord", { git: groupon_path("sonoma/sonoma-activerecord") }
gem "sonoma-authentication", { git: groupon_path("sonoma/sonoma-authentication") }
gem "sonoma-colorizer", { git: groupon_path("sonoma/sonoma-colorizer") }
gem "sonoma-dottablehash", { git: groupon_path("sonoma/sonoma-dottablehash") }
gem "sonoma-monitor", { git: groupon_path("sonoma/sonoma-monitor"), require: "sonoma_monitor" }
gem "sonoma-request-id", { git: groupon_path("sonoma/sonoma-request-id") }
gem "sonoma-local-config", { git: groupon_path("sonoma/sonoma-local-config") }
gem "uuidtools"
gem "dotenv"

group :development, :test do
  gem "bundler-audit"
  gem "byebug"
  gem "rspec"
  gem "rubocop"
  gem "shotgun"
end

group :test do
  gem "database_cleaner", "~> 1.4.1"
  gem "factory_girl"
  gem "rack-test"
  gem "rspec"
  gem "webmock"
end

group :deployer do
  gem "capistrano", "3.4.0"
  gem "sonoma-remote", { git: groupon_path("sonoma/sonoma-remote") }
end
