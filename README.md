# Weq

`Weq` は "ウィーク" と読みます。(別に他の読み方でもいいけど)

`Weq` は `Elixir` + `Phoenix` で構成された `JSON API` アプリケーションです。   
クライアントからリクエストを受けて、情報(JSON)を返すアプリケーションです。


## 使用用途

 * HTTP経由でDBにクエリを投げて結果を受け取りたい
 * APIのエンドポイントを増やさずに、クライアント側の欲しい情報を自由に取得してほしい
 * GraphQLではなくSQLで問い合わせを行いたい

こんなときに使うことをおすすめします。

使用する際は、DB接続情報について各環境に合わせて変更してください。


## 開発背景

某社のとあるサービスをクラウドに移行するプロジェクトがありました。   
このときクラウドに持っていくことのできないオンプレ側のDBがあったのですが、このオンプレ側のDBの情報を参照するのはサービスにとって必須でした。   
このためクラウドからオンプレ側のデータを参照するために、このAPIを作成しました。

なお、このリポジトリに上げたものは、リリースしたAPIとはコード的には別モノです。   
リリースしたコードを元に実装の見直しと書き直しをしています。   
また公開しても問題ないようにDB接続系情報などは架空のものにしてあります。

(注意)   
上記のオンプレ側のDBは機密情報・個人情報等は含まれていないDBでした。   
機密情報・個人情報が入っているDBの場合は、リクエストに対してシビアな制御が必要になるかもしれません。   
このAPIには制御は入っていないので、注意してください。


## 開発環境

Mac上で、 `Vagrant` + `VirtualBox` を使い、 仮想OSは `CentOS7系`  を入れて開発しました。

また開発時の動作確認には `docker`, `docker-compose` を使っています。   
手元の環境でとりあえず動作させてみる場合は `docker`, `docker-compose` をインストールしてください。


## 動作確認

単体テストと開発サーバの動作確認には `docker`, `docker-compose` が必要です。インストールしてください。   
以下、 `docker`, `docker-compose` がインストールされている前提です。


### 単体テスト

`kick.sh` を用意しているので、このシェルを経由して実行します。シェル内部では `docker-compose` を呼び出しています。

```
# 単体テストを実行する
$ sh kick.sh test
Creating network "weq_default" with the default driver
Creating weq_weqdb2_1 ... done
Creating weq_weqdb1_1 ... done
wait stating database...
............................

Finished in 1.2 seconds
28 tests, 0 failures

Randomized with seed 821175
Stopping weq_weqdb2_1 ... done
Stopping weq_weqdb1_1 ... done
Removing weq_weqtest_run_977f18799023 ... done
Removing weq_weqdb2_1                 ... done
Removing weq_weqdb1_1                 ... done
Removing network weq_default
```


### 開発サーバ起動

`kick.sh` を使って、開発環境上に `Weq API サーバ` を起動します。   
ホスト側の `4000` ポートとコンテナの `4000` ポートを繋いでいます。

```
# 開発サーバを起動する
$ sh kick.sh server
Creating network "weq_default" with the default driver
Creating weq_weqdb2_1 ... done
Creating weq_weqdb1_1 ... done
Compiling 2 files (.ex)
[info] Running WeqWeb.Endpoint with cowboy 2.6.3 at 0.0.0.0:4000 (http)
[info] Access WeqWeb.Endpoint at http://localhost:4000
```

別ターミナルを開いて、 `/api/ping` エンドポイントに対してリクエストを行う。

```
# レスポンスが返ってくる
$ curl http://localhost:4000/api/ping
{"message":"pong"}
```

```
# サーバ側の反応
[info] GET /api/ping
[debug] Processing with WeqWeb.PingController.index/2
  Parameters: %{}
  Pipelines: [:api]
[info] Sent 200 in 179ms
```

`/api/fetch` エンドポイントに対してリクエストを行う。

```
# (*) レスポンスは整形しています
$ curl -X POST -H "Content-Type: application/json" -d '{"resource": "weqdb1", "query": "SELECT * FROM m_product", "debug": true}' http://localhost:4000/api/fetch
{
    "binds": [],
    "debug": true,
    "explain": false,
    "limit": 1000,
    "offset": 0,
    "org_binds": [],
    "org_query": "SELECT * FROM m_product",
    "query": "SELECT * FROM m_product LIMIT 1000 OFFSET 0",
    "resource": "weqdb1",
    "rows": [
        {
            "created_at": "2019-07-22 10:30:43",
            "deleted_at": "0000-00-00 00:00:00",
            "id": "1",
            "price": 400,
            "series_id": "1000",
            "title": "シリーズ1商品タイトル1",
            "title_ruby": "シリーズ1ショウヒンタイトル1",
            "updated_at": "2019-07-22 10:30:43",
            "volume": "1"
        },
        {
            "created_at": "2019-07-22 10:30:43",
            "deleted_at": "0000-00-00 00:00:00",
            "id": "10",
            "price": 580,
            "series_id": "3000",
            "title": "シリーズ3商品タイトル3",
            "title_ruby": "シリーズ3ショウヒンタイトル3",
            "updated_at": "2019-07-22 10:30:43",
            "volume": "3"
        },
        {
            "created_at": "2019-07-22 10:30:43",
            "deleted_at": "0000-00-00 00:00:00",
            "id": "2",
            "price": 400,
            "series_id": "1000",
            "title": "シリーズ1商品タイトル2",
            "title_ruby": "シリーズ1ショウヒンタイトル2",
            "updated_at": "2019-07-22 10:30:43",
            "volume": "2"
        },
        {
            "created_at": "2019-07-22 10:30:43",
            "deleted_at": "0000-00-00 00:00:00",
            "id": "3",
            "price": 400,
            "series_id": "1000",
            "title": "シリーズ1商品タイトル3",
            "title_ruby": "シリーズ1ショウヒンタイトル3",
            "updated_at": "2019-07-22 10:30:43",
            "volume": "3"
        },
        {
            "created_at": "2019-07-22 10:30:43",
            "deleted_at": "0000-00-00 00:00:00",
            "id": "4",
            "price": 410,
            "series_id": "1000",
            "title": "シリーズ1商品タイトル4",
            "title_ruby": "シリーズ1ショウヒンタイトル4",
            "updated_at": "2019-07-22 10:30:43",
            "volume": "4"
        },
        {
            "created_at": "2019-07-22 10:30:43",
            "deleted_at": "0000-00-00 00:00:00",
            "id": "5",
            "price": 420,
            "series_id": "1000",
            "title": "シリーズ1商品タイトル5",
            "title_ruby": "シリーズ1ショウヒンタイトル5",
            "updated_at": "2019-07-22 10:30:43",
            "volume": "5"
        },
        {
            "created_at": "2019-07-22 10:30:43",
            "deleted_at": "0000-00-00 00:00:00",
            "id": "6",
            "price": 380,
            "series_id": "2000",
            "title": "シリーズ2商品タイトル1",
            "title_ruby": "シリーズ2ショウヒンタイトル1",
            "updated_at": "2019-07-22 10:30:43",
            "volume": "1"
        },
        {
            "created_at": "2019-07-22 10:30:43",
            "deleted_at": "2019-07-22 10:30:43",
            "id": "7",
            "price": 380,
            "series_id": "2000",
            "title": "シリーズ2商品タイトル2",
            "title_ruby": "シリーズ2ショウヒンタイトル2",
            "updated_at": "2019-07-22 10:30:43",
            "volume": "2"
        },
        {
            "created_at": "2019-07-22 10:30:43",
            "deleted_at": "0000-00-00 00:00:00",
            "id": "8",
            "price": 580,
            "series_id": "3000",
            "title": "シリーズ3商品タイトル1",
            "title_ruby": "シリーズ3ショウヒンタイトル1",
            "updated_at": "2019-07-22 10:30:43",
            "volume": "1"
        },
        {
            "created_at": "2019-07-22 10:30:43",
            "deleted_at": "0000-00-00 00:00:00",
            "id": "9",
            "price": 580,
            "series_id": "3000",
            "title": "シリーズ3商品タイトル2",
            "title_ruby": "シリーズ3ショウヒンタイトル2",
            "updated_at": "2019-07-22 10:30:43",
            "volume": "2"
        }
    ]
}
```

```
# サーバ側の反応
[info] POST /api/fetch
[debug] Processing with WeqWeb.FetchController.index/2
  Parameters: %{"debug" => true, "query" => "SELECT * FROM m_product", "resource" => "weqdb1"}
  Pipelines: [:api]
[debug] QUERY OK db=0.7ms decode=14.1ms queue=14.3ms
SELECT * FROM m_product LIMIT 1000 OFFSET 0 []
[info] Sent 200 in 162ms
```

## 開発サーバの停止

`kick.sh` 経由で停止できます。

```
$ sh kick.sh stop
```


## APIエンドポイント

実装されているAPIエンドポイントについて記載します。

次のAPIエンドポイントが実装されています。

 * /api/ping
 * /api/fetch
 * /api/count
 * /api/desc

なお、各APIで実行時エラーが発生した場合は、HTTPステータスコード: `500` とエラーメッセージを含んだJSONを返します。

### /api/ping

許可メソッド: GET

正常時は次のレスポンスを常に返します。

```
{"message":"pong"}
```

APIサーバの死活監視や接続確認時に使うことを想定しています。


### /api/fetch

許可メソッド: POST

`Weq` が提供するメインAPIです。このAPIエンドポイントを経由して、クライアントは自由にデータを取得できます。   
ただし、最大で取得できるデータの件数は 1,000件に制限されています。   
問い合わせされたクエリに対してAPI内部で自動的に `LIMIT` と `OFFSET` が付与されます。   
1,000件以上を取得する場合は、クライアント側で `offset` を変更しながら、複数回リクエストしてください。

#### パラメータ

JSONで表現したパラメータをエンドポイントに対して送ります。

|項目名|型|説明|必須|
|---|:---:|---|:---:|
|resource|string| クエリを発行するリソース(DB)を指定する|○|
|query|string| DBに発行する問い合わせクエリ|○|
|binds|map or array| クエリに埋め込んだブレースホルダーや名前付きブレースホルダーに値を埋め込むバインド変数|-|
|limit|int| 結果として受け取る rows の数です。0以上、1000以下の値を設定できます。デフォルトは 1000 です|-|
|offset|int| データを取得するときのオフセットを設定できます。デフォルトは 0 です|-|
|explain|bool| true が設定された場合は、クエリの実行結果ではなく実行計画を返します。デフォルトは false です|-|
|debug|bool| true が設定された場合は、結果セットにデバッグ情報(実際に実行した正規化したクエリなどの情報)を付加します|-|


```
# サンプル
{
  "resource": "dbname",
  "query": "SELECT * FROM table1 where id in (:id_list) AND type = :type",
  "binds": {
    "id_list": [1, 2, 3],
    "type": "hoge"
  },
  "limit": 1000,
  "offset": 0,
  "explain": false,
  "debug": false
}
```

#### レスポンス

`rows` キーの中に配列があり、配列の各要素が1レコードになっています。

```
# サンプル
{
    "binds": [],
    "debug": true,
    "explain": false,
    "limit": 1000,
    "offset": 0,
    "org_binds": [],
    "org_query": "SELECT * FROM m_product",
    "query": "SELECT * FROM m_product LIMIT 1000 OFFSET 0",
    "resource": "weqdb1",
    "rows": [
        {
            "created_at": "2019-07-22 10:30:43",
            "deleted_at": "0000-00-00 00:00:00",
            "id": "1",
            "price": 400,
            "series_id": "1000",
            "title": "シリーズ1商品タイトル1",
            "title_ruby": "シリーズ1ショウヒンタイトル1",
            "updated_at": "2019-07-22 10:30:43",
            "volume": "1"
        },
        ...
    ]
}
```


### /api/count

許可メソッド: POST

データ件数を取得する補助的なAPIです。   
リクエストされたクエリのSELECT句を内部で `SELECT count(*) AS count` に変換して結果を取得します。

#### パラメータ

JSONで表現したパラメータをエンドポイントに対して送ります。

|項目名|型|説明|必須|
|---|:---:|---|:---:|
|resource|string| クエリを発行するリソース(DB)を指定する|○|
|query|string| DBに発行する問い合わせクエリ|○|
|binds|Map or List| クエリに埋め込んだブレースホルダーや名前付きブレースホルダーに値を埋め込むバインド変数|-|
|debug|bool| true が設定された場合は、結果セットにデバッグ情報(実際に実行した正規化したクエリなどの情報)を付加します|-|


```
# サンプル
{
  "resource": "weqdb1",
  "query": "SELECT * FROM m_product",
  "binds": [],
  "debug": true
}
```

#### レスポンス

`count` キーにデータ件数が格納されています。

```
# サンプル
{
 "binds": [],
 "count": 10,
 "debug": true,
 "org_binds": [],
 "org_query": "SELECT * FROM m_product",
 "query": "SELECT COUNT(*) AS count FROM m_product",
 "resource": "weqdb1"
}
```


### /api/desc

許可メソッド: POST 

開発の補助ツールとしての位置づけのAPIです。   
`DESC table_name` の結果を返します。


#### パラメータ

|項目名|型|説明|必須|
|---|:---:|---|:---:|
|resource|string| クエリを発行するリソース(DB)を指定する|○|
|table|string| DESCするテーブル名|○|

```
# サンプル
{
  "resource": "weqdb1",
  "table": "m_product"
}
```

#### レスポンス

`rows` キーの中に配列があり、DESC結果のレコードがその要素1つ1つに格納されています。


```
# サンプル
{
    "rows": [
        {
            "Default": null,
            "Extra": "",
            "Field": "id",
            "Key": "PRI",
            "Null": "NO",
            "Type": "varchar(30)"
        },
        {
            "Default": null,
            "Extra": "",
            "Field": "title",
            "Key": "",
            "Null": "NO",
            "Type": "varchar(255)"
        },
        {
            "Default": null,
            "Extra": "",
            "Field": "title_ruby",
            "Key": "",
            "Null": "NO",
            "Type": "varchar(255)"
        },
        {
            "Default": null,
            "Extra": "",
            "Field": "volume",
            "Key": "",
            "Null": "YES",
            "Type": "varchar(7)"
        },
        {
            "Default": null,
            "Extra": "",
            "Field": "price",
            "Key": "",
            "Null": "NO",
            "Type": "int(10) unsigned"
        },
        {
            "Default": null,
            "Extra": "",
            "Field": "series_id",
            "Key": "MUL",
            "Null": "NO",
            "Type": "varchar(30)"
        },
        {
            "Default": null,
            "Extra": "",
            "Field": "created_at",
            "Key": "",
            "Null": "NO",
            "Type": "datetime"
        },
        {
            "Default": null,
            "Extra": "",
            "Field": "updated_at",
            "Key": "",
            "Null": "NO",
            "Type": "datetime"
        },
        {
            "Default": null,
            "Extra": "",
            "Field": "deleted_at",
            "Key": "",
            "Null": "NO",
            "Type": "datetime"
        }
    ],
    "table": "m_product"
}
```


## RESTfulAPI vs GraphQL vs Weq

RESTを心底理解しているか? GraphQLを心底理解しているか？

と言われると、とても心もとないのですが、ここに私見を書いておきます。


### RESTfulAPIの個人的なジレンマ

一昔前、といってもそんな昔じゃないですけど、私もRESTなAPIを作りたいと思っていました。

しかし、次のような条件のAPIを作るときにジレンマが発生しました。

 * 情報を取得するからHTTPメソッドは当然、`GET` だ！！
 * でもパラメータは長くなったり複雑だったりするので、クエリパラメータではなく、POSTの時に使うボディに入れよう

私の理解では、情報を取得するRESTなAPIなら、 `GET` です。   
パラメータは複雑なパターンになるのでJSONで構造化してボディにパラメータとして入れます。

気持ち悪いなという感覚はありましたが、一時はこれで満足していました。

しかし、、、

クライアント側の実装で、 `GET` メソッドなのにボディにパラメータを入れる場合、実装上の一工夫が必要だったり、   
サーバ側で簡単に負荷をかけてみたいと思っても `apache bench` で `GET` メソッドを指定しつつボディにパラメータを入れる方法がわからなかったり、、、

という問題に突き当たりました。

そして私はこれを「自然の流れに反している」と捉えたのです。   
つまり、 `GET` メソッドなのに `ボディ` にパラメータを入れるなんてことは、やっぱり「気持ち悪い」ことなのです。


### 思想転換(RESTを超える)

それでも私は `REST` に憧れのようなものを抱いていました。   
私には自分自身が納得感を持って `REST` を超えるための思想転換が必要でした。

そして私は次のような考えに至りました。

 * APIエンドポイントを関数と捉える
 * 関数に対してパラメータをわたす場合は、単純なものならクエリパラメータに、複雑だったり長大なものはボディのパラメータに
 * 関数にわたすパラメータに応じて `GET` と `POST` を使い分ければよい
 * `GET` だろうか `POST` だろうが私は関数から戻り値を得るだけだ
 * 関数の副作用については関数側(サーバ側)で責任を持ってやってもらえばよい。私は気にしない

この考えによって、私は情報を取得する場合でも平気で `POST` メソッドを使い、ボディにパラメータを入れることができます。   
`GET` とか `POST` とか、HTTPメソッドはあまり関係ありません。私はしかるべきパラメータを送り、しかるべき戻り値を受け取るだけです。   
だって、それ(APIエンドポイント)は `関数` なんですから！！


### GraphQLの噂

`GraphQL` の噂を聞くようになりました。   
別部署のチームが新しいAPIに `GraphQL` を採用し、実験的に実装をはじめたという噂も聞きました。

私の `GraphQL` に対する印象は次の通りです。

 * 実装が面倒そう...

まあ、しかし、実装したい人がいて楽しいなら、それはそれでいいのです。

それからもう少し `GraphQL` について調べてみました。   
私の(拙いかもしれない)理解では次の通りです。

 * `GraphQL` は型安全である
 * `GraphQL` のエンドポイントは1つしかない
 * `GraphQL` を使えばクライアントはクライアントが必要とする項目だけ取得できる
 * `GraphQL` は情報の取得の他に登録・更新もできる

`RESTfulAPI` と `GraphQL実装のAPI` の比較記事もあり、 `GraphQL` は `RESTfulAPI` のようにエンドポイントがどんどん増えていくことがなくAPIの管理が楽だ、というのが強みのようでした。


### Weqを実装する

私の所属する部署で、既存サービスのクラウド移行と新規サービスをクラウド上に実装するという2つのプロジェクトがはじまりました。

両サービスともクラウドで動作するのですが、ユーザーにサービスを提供するにはオンプレ側にあるDBの情報が必要でした。   
そして、オンプレ側にあるDBは他部署も利用しているもので、クラウドに移行することはできない年代物のDBでした。

既存サービスについては、実装されているSQLコード資産をできるだけ生かせたほうがよく、新規サービスについては詳細な仕様は定かでではなく、どのような情報が必要になるのかわかりませんでした。

私にはアイディアがあり、クラウドとオンプレをつなぐAPIの実装をはじめました。   
そしてそれが `Weq` です。   
`Weq` は身も蓋もなく言ってしまえば、 `HTTP経由プロキシのDB操作API` です。   

`Weq` の特徴は次の通りです。

 * `Weq` のエンドポイントは原則1つしかない(/api/fetch)
 * `Weq` を使えばクライアントはクライアントが必要とする項目だけ取得できる
 * `Weq` は使い慣れたSQLでデータの問い合わせを行うことができる
 * `Weq` はバックエンドのDBに接続するユーザーの権限を `SELECT` に限定すれば、参照のみに制限できる(無闇に登録・更新させない)


`GraphQL` と比較すると、どうでしょうか？   
`Weq` は型安全ではありませんが、これは自由とのトレードオフです。   
`GraphQL` のバックエンドは `DB` に限定されていませんが、例えば `DB` だとして、テーブルが追加されたとしましょう。   
おそらく `GraphQL` では新しいテーブルを認識するための型定義が必要となるでしょう。   
しかし、 `Weq` の場合は、クライアントが「テーブルの追加」を認識すれば、 `Weq` 自身は何も変更せずに動き続けます。

私は今回のプロジェクトにおいては、 `GraphQL` の実装は実現可能性を含めて重すぎると考えました。

やりたいことは、「問い合わせをしたら、問い合わせに応じたデータが欲しい」ということでした。   
`Weq` はこれを満たします。

`RESTfulAPI` で実装していたら、どうなっていたでしょう?   
新規サービスにおいては、仕様も明確でなく、データ構造もまだ定まっていませんでした。   
仕様やデータ構造が明確になる度に、これらに応じた `REST` なAPIを作ることになっていたかもしれません。   
これは明らかに工数がかかりすぎます。   
必要だったのは `Weq` の `/api/fetch` でした。   
このAPIエンドポイントがあれば、好きにデータを取得できるし、変更にも対応できます。


私は `Weq` を手軽で簡単な課題解決の1つの回答だと考えています。


## おまけ

複数DBの設定については [このドキュメント](./docs/multiple_db_setting.md) を参照してください。

MyXQLのゼロDateエラーについては [このドキュメント](./docs/myxql_zeto_date.md) を参照してください。
