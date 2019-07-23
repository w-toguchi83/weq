use Mix.Config

# Configure your database
config :weq, Weq.Repos.Weqdb1Repo,
  username: "root",
  password: "root123",
  database: "weq_test",
  hostname: "weqdb1",
  after_connect: &MyXQL.query!(&1, "SET NAMES 'utf8'"),
  pool: Ecto.Adapters.SQL.Sandbox

config :weq, Weq.Repos.Weqdb2Repo,
  username: "root",
  password: "root123",
  database: "weq_test",
  hostname: "weqdb2",
  after_connect: &MyXQL.query!(&1, "SET NAMES 'utf8'"),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :weq, WeqWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
