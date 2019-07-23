defmodule WeqWeb.FetchController do
  @moduledoc """
  fetchコントローラー.
  """

  use WeqWeb, :controller

  alias WeqWeb.Fetcher.Parameter
  alias WeqWeb.Fetcher.Executor
  alias WeqWeb.Utils.ResponseUtil

  def index(conn, params) do
    try do
      params
      |> Parameter.normalize
      |> Executor.execute
      |> (&(json(conn, &1))).()
    rescue
      e in RuntimeError -> ResponseUtil.error_json(conn, e.message)
    end
  end
end
