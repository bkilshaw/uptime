import Config

# Configure your database
config :uptime, Uptime.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "uptime_dev",
  port: 5414,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
