defmodule WeqWeb.Describer.Executor do

  alias Weq.Resource
  alias Weq.Query.Tokenizer, as: QueryTokenizer
  alias Weq.Query.Executor, as: QueryExecutor

  def execute(%{
    "resource" => resource,
    "table"    => table,
  }) do
    repo = Resource.convert_to_repo(resource)
    ## 念の為トークンに分解して、最初の項を対象とする
    query = "DESC " <> (QueryTokenizer.tokenize(table) |> List.first)

    rows = QueryExecutor.execute(repo, query)

    %{
      "table" => table,
      "rows" => rows
    }
  end
end
