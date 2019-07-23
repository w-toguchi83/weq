defmodule WeqWeb.Counter.Executor do

  alias Weq.Resource
  alias Weq.Query.Tokenizer, as: QueryTokenizer
  alias Weq.Query.Normalizer, as: QueryNormalizer
  alias Weq.Query.Executor, as: QueryExecutor

  def execute(%{
    "resource" => resource,
    "query"    => org_query,
    "binds"    => org_binds,
    "debug"    => debug
  }) do
    repo = Resource.convert_to_repo(resource)

    {normalized_query, normalized_bind_params} = QueryNormalizer.normalize_query_and_bind_params(org_query, org_binds)
    count_query = get_count_query(QueryTokenizer.tokenize(normalized_query))

    rows = QueryExecutor.execute(repo, count_query, normalized_bind_params)
    count = List.first(rows) |> Map.get("count")

    if debug do
      %{
        "resource" => resource,
        "query" => count_query,
        "binds" => normalized_bind_params,
        "org_query" => org_query,
        "org_binds" => org_binds,
        "debug" => debug,
        "count" => count
      }
    else
      %{"count" => count}
    end
  end

  defp get_count_query(query_tokens) do
    index_of_first_from = Enum.find_index(query_tokens, &(&1 === "FROM" or &1 === "from"))
    after_from = Enum.slice(query_tokens, index_of_first_from + 1, Enum.count(query_tokens))

    ## countクリ生成
    ["SELECT", "COUNT(*)", "AS", "count", "FROM"] ++ after_from
    |> Enum.join(" ")
  end
end
