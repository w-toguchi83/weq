defmodule Weq.ResourceTest do
  use ExUnit.Case, async: true

  alias Weq.Resource

  test "convert_to_repo" do
    assert Resource.convert_to_repo("weqdb1") === Weq.Repos.Weqdb1Repo
    assert Resource.convert_to_repo("weqdb2") === Weq.Repos.Weqdb2Repo
  end

  test "error: undefined resource" do
    assert_raise ArgumentError, "undefined resource(hoge)", fn ->
      Resource.convert_to_repo("hoge")
    end
  end

end
