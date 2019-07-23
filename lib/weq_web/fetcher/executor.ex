defmodule WeqWeb.Fetcher.Executor do

  alias Weq.Resource
  alias Weq.Query.Normalizer, as: QueryNormalizer
  alias Weq.Query.Executor, as: QueryExecutor

  def execute(%{
    "resource" => resource,
    "query"    => org_query,
    "binds"    => org_binds,
    "limit"    => limit,
    "offset"   => offset,
    "explain"  => explain,
    "debug"    => debug
  }) do
    repo = Resource.convert_to_repo(resource)
    query = if explain do
      add_limit_and_offset("EXPLAIN " <> org_query, limit, offset)
    else
      add_limit_and_offset(org_query, limit, offset)
    end

    {normalized_query, normalized_bind_params} = QueryNormalizer.normalize_query_and_bind_params(query, org_binds)

    rows = QueryExecutor.execute(repo, normalized_query, normalized_bind_params)

    if debug do
      %{
        "resource" => resource,
        "query" => normalized_query,
        "binds" => normalized_bind_params,
        "org_query" => org_query,
        "org_binds" => org_binds,
        "limit" => limit,
        "offset" => offset,
        "explain" => explain,
        "debug" => debug,
        "rows" => rows
      }
    else
      %{"rows" => rows}
    end
  end

  defp add_limit_and_offset(query, limit, offset) do
    query <> " LIMIT #{limit} " <> " OFFSET #{offset}"
  end

end
