use Mix.Config

config :example, Example.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

config :libcluster, :topologies,
  default: [
    strategy: Cluster.Strategy.DNSPoll,
    config: [
      polling_interval: 10_000,
      query: System.get_env("HEROKU_DNS_FORMATION_NAME"),
      node_basename: "example",
      secret: System.get_env("CLUSTER_SECRET"),
      debug: true
    ]
  ]
