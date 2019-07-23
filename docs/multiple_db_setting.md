# 複数DB設定

Phoenixにおける複数DB設定の方法について記載する

## 設定方法

作業は大きく分けて次のものになる

 * DBをあらわす `Repo` のモジュールを複数作成し、スーパーバイザーの管理に追加する
 * `config` 系のファイルを複数の `Repo` に合わせて変更する
 * 複数の `Repo` に対応するマイグレーション用のディレクトリを作成する
 * テストのヘルパー系モジュールを複数の `Repo` に対応させる

以下、設定例を記載しながら順に設定方法・変更内容を記載します。


### DBをあらわす `Repo` のモジュールを複数作成し、スーパーバイザーの管理に追加する

デフォルトでは1つの `Repo` モジュールが用意されています。  
変更前は次のパスに `Repo` モジュールがありました。

`/path/to/weq/lib/weq/repo.ex`

複数のDBに対応させるために次のように変更しました。

 * `/path/to/weq/lib/weq/repo.ex` を削除
 * `repos` ディレクトリを次のパスに作成  `/path/to/weq/lib/weq/repos`
 * `repos` ディレクトリ配下に `Repo` モジュールを複数作成

今回、サンプルで作成した `Repo` モジュールは次のようになります。

 * `/path/to/weq/lib/weq/repos/weqdb1_repo.ex`
 * `/path/to/weq/lib/weq/repos/weqdb2_repo.ex`

ファイルの内容は次のようになります。

```weqdb1_repo.ex
defmodule Weq.Repos.Weqdb1Repo do
  use Ecto.Repo,
    otp_app: :weq,
    adapter: Ecto.Adapters.MyXQL,
    read_only: true
end
```

```weqdb2_repo.ex
defmodule Weq.Repos.Weqdb2Repo do
  use Ecto.Repo,
    otp_app: :weq,
    adapter: Ecto.Adapters.MyXQL,
    read_only: true
end
```

なお、今回作成するAPIは、登録・更新は行わない想定のため `read_only: true` を付与しています。

次に作成した `Weq.Repos.Weqdb1Repo` と `Weq.Repos.Weqdb2Repo` をスーパーバイザーの管理におきます。  
修正するファイルは次のものです。

`/path/to/weq/lib/weq/application.ex`


変更前の内容は次です。

```application.ex
defmodule Weq.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Weq.Repo,
      # Start the endpoint when the application starts
      WeqWeb.Endpoint
      # Starts a worker by calling: Weq.Worker.start_link(arg)
      # {Weq.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Weq.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WeqWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
```

変更後の内容は次です。

```application.ex
defmodule Weq.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      # 変更した箇所はココです!!
      Weq.Repos.Weqdb1Repo,
      Weq.Repos.Weqdb2Repo,
      # Start the endpoint when the application starts
      WeqWeb.Endpoint
      # Starts a worker by calling: Weq.Worker.start_link(arg)
      # {Weq.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Weq.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WeqWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
```

以上で、複数のDBに対応した `Repo` モジュールを定義し、スーパーバイザーの管理に追加できました。


### `config` 系のファイルを複数の `Repo` に合わせて変更する

次の `config` ファイルを変更します。

`/path/to/weq/config/config.exs`


変更前は次の内容でした。


```config.exs
use Mix.Config

config :weq,
  ecto_repos: [Weq.Repo]

# Configures the endpoint
config :weq, WeqWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zC1gjEdI73gYbbkvOdYEofS29DIVEyYRx4zhb+GQdmSEInn45hAqv08DO1WdYQmQ",
  render_errors: [view: WeqWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Weq.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
```

変更後は次の通りです。


```config.exs
use Mix.Config

config :weq,
  # 変更した箇所はココです!!
  ecto_repos: [Weq.Repos.Weqdb1Repo, Weq.Repos.Weqdb2Repo]

# Configures the endpoint
config :weq, WeqWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zC1gjEdI73gYbbkvOdYEofS29DIVEyYRx4zhb+GQdmSEInn45hAqv08DO1WdYQmQ",
  render_errors: [view: WeqWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Weq.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
```


環境毎に読み込まれるファイルも変更します。  
`dev.exs` の変更例は次の通りです。

今回は2つのDBについて追加しているので、接続設定も2つにします。

```dev.exs
use Mix.Config

# 複数のDB接続設定を追加しました!!
config :weq, Weq.Repos.Weqdb1Repo,
  username: "user1",
  password: "xxxx1",
  database: "db1",
  hostname: "host1",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :weq, Weq.Repos.Weqdb2Repo,
  username: "user2",
  password: "xxxx2",
  database: "db1",
  hostname: "host2",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

## 以下は省略
```

以上で、 `config` 系ファイルの変更ができました。


### 複数の `Repo` に対応するマイグレーション用のディレクトリを作成する

マイグレーション用のディレクトリを作成しないとアプリケーション起動時に次のようにエラーになります。

```
** (Mix) Could not find migrations directory "priv/weqdb1_repo/migrations"
for repo Weq.Repos.Weqdb1Repo.

This may be because you are in a new project and the
migration directory has not been created yet. Creating an
empty directory at the path above will fix this error.

If you expected existing migrations to be found, please
make sure your repository has been properly configured
and the configured path exists.
```

ここでの作業は、対応するディレクトリを作成するだけです。  
今回は次のディレクトリを作成しました。

 * `/path/to/weq/priv/weqdb1_repo/migrations`
 * `/path/to/weq/priv/weqdb2_repo/migrations`


空ディレクトリを作成すれば、エラーは出なくなります。


### テストのヘルパー系モジュールを複数の `Repo` に対応させる

テストのヘルパー系モジュールがデフォルトの `Repo` モジュールに依存しているので、これを変更します。

次のファイルを変更します。

`/path/to/weq/test/test_helper.exs`

変更前は次の内容でした。

```test_helper.exs
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Weq.Repo, :manual)
```

変更後は次の通りです。

```test_helper.exs
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Weq.Repos.Weqdb1Repo, :manual)
Ecto.Adapters.SQL.Sandbox.mode(Weq.Repos.Weqdb2Repo, :manual)
```

次にDB接続系のテストが実行できるように次のテストサポートファイルを変更します。

`/path/to/weq/test/support/conn_case.ex`

変更前は次の内容でした。

```conn_case.ex
  # setup tags のみ表示
  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Weq.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Weq.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
```

変更後は次の通りです。

```conn_case.ex
  # setup tags のみ表示
  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Weq.Repos.Weqdb1Repo)
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Weq.Repos.Weqdb2Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Weq.Repos.Weqdb1Repo, {:shared, self()})
      Ecto.Adapters.SQL.Sandbox.mode(Weq.Repos.Weqdb2Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
```

`/path/to/weq/test/support/data_case.ex` についても同様の変更を行います。  
変更内容は省略します。 `conn_case` の修正とほぼ同じです。( `using` マクロで `alias` を宣言している箇所があるので、そこも修正してください)

DB接続系のテストの例は次の通りです。  
`Weq.DataCase` を `use` して使います。

```
defmodule Weq.Repos.Weqdb1RepoTest do
  use Weq.DataCase, async: true

  test "connect webdb1" do
    assert {:ok, result} = Ecto.Adapters.SQL.query(Weq.Repos.Weqdb1Repo, "SELECT 1")
    assert result.rows === [[1]]
    assert result.num_rows === 1
  end
end
```


