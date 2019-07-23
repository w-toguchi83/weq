defmodule WeqWeb.DescController do
  @moduledoc """
  descコントローラー
  """

  use WeqWeb, :controller

  alias WeqWeb.Describer.Parameter
  alias WeqWeb.Describer.Executor
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
