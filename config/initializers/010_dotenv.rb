if GG.local_environment?
  # Dotenv will not overwrite values by default, so load the local overrides first.
  Dotenv.load(".env.#{GG.env}.local")
  Dotenv.load(".env.#{GG.env}")
end
