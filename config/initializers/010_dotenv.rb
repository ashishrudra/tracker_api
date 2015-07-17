if GA.local_environment?
  # Dotenv will not overwrite values by default, so load the local overrides first.
  Dotenv.load(".env.#{GA.env}.local")
  Dotenv.load(".env.#{GA.env}")
end
