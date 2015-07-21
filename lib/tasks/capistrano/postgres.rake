namespace :postgres do
  task :boot do
    on(roles(:db)) do
      execute(:sudo, "docker run --name ga-postgres -p 5432:5432 -e POSTGRES_PASSWORD=ga -d postgres")
    end
  end
end
