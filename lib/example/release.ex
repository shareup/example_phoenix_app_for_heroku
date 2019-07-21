defmodule Example.Release do
  require Logger

  @app :example

  def migrate do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end

  def deploy_assets(release) do
    Logger.info("Deploying assets...")

    npm_install()
    npm_deploy()
    phx_digest()

    release
  end

  defp npm_install do
    cmd("npm", ["install", "--prefix", "assets"])
  end

  defp npm_deploy do
    cmd("npm", ["run", "deploy", "--prefix", "assets"])
  end

  defp phx_digest, do: Mix.Task.run("phx.digest")

  defp cmd(program, args) do
    case System.cmd(
           program,
           args,
           into: IO.stream(:stdio, :line)
         ) do
      {_, 0} ->
        nil

      {_, error_code} ->
        throw({:error, :cmd_failed, Enum.join([program] ++ args, " "), error_code})
    end
  end
end
