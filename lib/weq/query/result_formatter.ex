defmodule Weq.Query.ResultFormatter do
  @moduledoc """
  結果セットフォーマッターモジュール.
  """

  @doc """
  正常系結果セット整形処理.
  カラム情報と値情報が分けられているので、カラムと値を `column => value` の構造にして返す.
  """
  def format({:ok, %{columns: columns, rows: rows}}) do
    formatted_rows = for row <- rows, do: (
      row
      |> Enum.map(&datetime_to_string/1)
      |> (&(Enum.zip(columns, &1))).()
      |> Map.new
    )
    {:ok, formatted_rows}
  end

  @doc """
  エラー系結果セット整形処理.
  """
  def format({:error, reason}) do
    {:error, "| " <> Integer.to_string(reason.mysql.code) <> " | " <> reason.message}
  end

  # DateTime型の値をタイムゾーンのない文字列に変換して返す.
  # Ecto.Adapters.SQL.queryで取得した場合、日時型がUTCのタイムゾーンとして認識されて、そのまま文字列変換を行うと、
  # タイムゾーンが付与された文字列になるため、タイムゾーンのないものに変換する.
  defp datetime_to_string(%DateTime{year: year, month: month, day: day, hour: hour, minute: minute, second: second}) do
    :io_lib.format("~B-~2..0B-~2..0B ~2..0B:~2..0B:~2..0B", [year, month, day, hour, minute, second])
    |> to_string
  end

  # NaiveDateTime型の値をタイムゾーンのない文字列に変換して返す.
  # Ecto.Adapters.SQL.queryで取得した場合、日時型がUTCのタイムゾーンとして認識されて、そのまま文字列変換を行うと、
  # タイムゾーンが付与された文字列になるため、タイムゾーンのないものに変換する.
  defp datetime_to_string(%NaiveDateTime{year: year, month: month, day: day, hour: hour, minute: minute, second: second}) do
    :io_lib.format("~B-~2..0B-~2..0B ~2..0B:~2..0B:~2..0B", [year, month, day, hour, minute, second])
    |> to_string
  end

  # ゼロDate対応版(:zero_datetime).
  defp datetime_to_string(:zero_datetime) do
    "0000-00-00 00:00:00"
  end

  # DateTime型,NaiveDateTime型でない場合は、そのまま値を返す.
  defp datetime_to_string(non_datetime), do: non_datetime

end
