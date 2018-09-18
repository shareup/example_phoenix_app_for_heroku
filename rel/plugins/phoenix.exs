defmodule Example.Phoenix do
  use Mix.Releases.Plugin

  def before_assembly(_release, _opts) do
    info("Deploying assets")

    with {_output, 0} <- npm_install(),
         {_output, 0} <- npm_deploy(),
         _ = phx_digest() do
      nil
    else
      {_output, error_code} ->
        throw({:error, :npm_deploy_failed, error_code})
    end
  end

  def after_assembly(_release, _opts), do: nil
  def before_package(_release, _opts), do: nil
  def after_package(_release, _opts), do: nil
  def after_cleanup(_release, _opts), do: nil

  defp npm_install do
    System.cmd(
      "npm",
      ["install", "--only", "production"],
      cd: "assets",
      into: IO.stream(:stdio, :line)
    )
  end

  defp npm_deploy do
    System.cmd(
      "npm",
      ["run", "deploy"],
      cd: "assets",
      into: IO.stream(:stdio, :line)
    )
  end

  defp phx_digest, do: Mix.Task.run("phx.digest")
end
