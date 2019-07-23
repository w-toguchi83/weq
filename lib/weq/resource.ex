defmodule Weq.Resource do
  @moduledoc """
  リソースモジュール.
  """

  # リソース名とRepoの定義マップ
  @resource_to_repo_map %{
    "weqdb1" => Weq.Repos.Weqdb1Repo,
    "weqdb2" => Weq.Repos.Weqdb2Repo
  }

  def convert_to_repo(resource) do
    if Map.has_key?(@resource_to_repo_map, resource) do
      Map.fetch!(@resource_to_repo_map, resource)
    else
      raise ArgumentError, message: "undefined resource(#{resource})"
    end
  end
end
