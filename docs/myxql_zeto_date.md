# MyXQLのゼロDate問題

## MyXQLとは

[MyXQL](https://github.com/elixir-ecto/myxql) は、`Phoenix` で使用されているDB接続ライブラリの `Ecto` から使われる `MySQL` に接続するクライアント。


## ゼロDate問題

2019年7月23日時点、MyXQLのバージョンは `v0.2.6`   
特に何もせず構築すると上記のバージョンが入る。

MyXQLでは、テーブルの日時定義項目に `NULL` が登録されていると、データを取得するときにエラーが発生する。

```
## こんな感じ
(ArgumentError) cannot decode MySQL "zero" date as NaiveDateTime
```

しかし、リポジトリのREADMEには次のような記載があり、SQLモードで許可されていれば、エラーではなくアトム( `:zero_datetime` )が戻されるようになっている。

> When using SQL mode that allows them, MySQL "zero" dates and datetimes are represented as :zero_date and :zero_datetime respectively.

しかし、実行してみるとアトムは戻されず、エラーになる。

結論から言うと、ゼロDateのときのアトム戻しのコードは、`v0.2.6` には入っていない。 `master` に入っている。   
なので、ゼロDateを使う可能性がある場合は、 `MyXQL` の取得を `master` に変更する必要がある。


## `mix.exs` の設定で、 `MyXQL` の `master` を取得する

`mix.exs` を変更する。

```
  # 変更前
  defp deps do
    [
      {:phoenix, "~> 1.4.9"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      {:myxql, "=> 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
```

```
  # 変更後
  defp deps do
    [
      {:phoenix, "~> 1.4.9"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      ## 修正したのはココ。gitリポジトリ直指定で、 master を入れるようにした
      {:myxql, git: "git://github.com/elixir-ecto/myxql.git", branch: "master", override: true},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"}
    ]
  end
```

変更後、 `mix deps.get` を実行して、 `myxql` の `master` をプロジェクトに入れる
