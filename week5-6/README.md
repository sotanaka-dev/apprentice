# インターネットTV

<details>
  <summary><h2>プロジェクトの要件</h2></summary>

  好きな時間に好きな場所で話題の動画を無料で楽しめる「インターネットTVサービス」を新規に作成することになりました。データベース設計をした上で、データ取得する SQL を作成してください。

  仕様は次の通りです。サービスのイメージとしては [ABEMA](https://abema.tv/) を頭に思い浮かべてください。

  - ドラマ1、ドラマ2、アニメ1、アニメ2、スポーツ、ペットなど、複数のチャンネルがある
  - 各チャンネルの下では時間帯ごとに番組枠が1つ設定されており、番組が放映される
  - 番組はシリーズになっているものと単発ものがある。シリーズになっているものはシーズンが1つものと、シーズン1、シーズン2のように複数シーズンのものがある。各シーズンの下では各エピソードが設定されている
  - 再放送もあるため、ある番組が複数チャンネルの異なる番組枠で放映されることはある
  - 番組の情報として、タイトル、番組詳細、ジャンルが画面上に表示される
  - 各エピソードの情報として、シーズン数、エピソード数、タイトル、エピソード詳細、動画時間、公開日、視聴数が画面上に表示される。単発のエピソードの場合はシーズン数、エピソード数は表示されない
  - ジャンルとしてアニメ、映画、ドラマ、ニュースなどがある。各番組は1つ以上のジャンルに属する
  - KPIとして、チャンネルの番組枠のエピソードごとに視聴数を記録する。なお、一つのエピソードは複数の異なるチャンネル及び番組枠で放送されることがあるので、属するチャンネルの番組枠ごとに視聴数がどうだったかも追えるようにする

  番組、シーズン、エピソードの関係について、以下のようなイメージです(シリーズになっているものの例)。

  - 番組：鬼滅の刃
  - シーズン：1
  - エピソード：1話、2話、...、26話

</details>

<details>
  <summary><h2>ER図</h2></summary>
  <br>

  ![ER図](https://www.plantuml.com/plantuml/png/hLJ1JiCm3BtdAtg4mtP0sWLDqmeKc80DJGLnYq9ZZKXjCYKf2AtyEscegor5fKZhnQtzRB_dnfaRoxGjYvmGa5ROpoXxOr92Rg8TYTmZU7GUNInk5iiqcauVxsOpxnwDl96i01T_ZjUNj_7wv6moENMe9mVw2WlIhLORpGeiZEvk0sUkiK-Jr8Dg6o5s67ENaOVKVO23oRJOMg6a2wV9IzfjGJSWDM0Z_t547LZyIFCtm8oIW-erM2hBmg4Sv2V5K2Fa9WSAMs4KXxh2QdMVnCiURO6e9dKG3GG7FFxpoxoxr0nzYuV4-pJam0nGpcnTwYfEattXlH9GfycL7QR3BnUrei1UBG-GFFG7Mz53v5KhnZDcB0scki-m_q2s8-v7lGlue9agfMrHDO_sZgYgyLZjEYjEyCK3ghy1U4X9Oz6D-a9yi8Z46wGJ1WEsX_-H77mXf3jXWY_8u1S8cOFazLtw3G00)
</details>


<details>
  <summary><h2>ステップ1：テーブル設計</h2></summary>

  ### テーブル：channels
  | カラム名 | データ型     | NULL | キー    | 初期値 | AUTO INCREMENT |
  | -------- | ------------ | ---- | ------- | ------ | -------------- |
  | id       | BIGINT       |      | PRIMARY |        | YES            |
  | name     | VARCHAR(255) |      |         |        |                |
  - ユニークキー制約：nameに対して設定

  ### テーブル：channel_programs
  | カラム名   | データ型 | NULL | キー              | 初期値 | AUTO INCREMENT |
  | ---------- | -------- | ---- | ----------------- | ------ | -------------- |
  | channel_id | BIGINT   |      | PRIMARY / FOREIGN |        |                |
  | program_id | BIGINT   |      | PRIMARY / FOREIGN |        |                |
  - 外部キー制約：channel_idに対して、channelsテーブルのidから設定
  - 外部キー制約：program_idに対して、programsテーブルのidから設定

  ### テーブル：programs
  | カラム名    | データ型     | NULL | キー    | 初期値 | AUTO INCREMENT |
  | ----------- | ------------ | ---- | ------- | ------ | -------------- |
  | id          | BIGINT       |      | PRIMARY |        | YES            |
  | title       | VARCHAR(255) |      |         |        |                |
  | description | TEXT         |      |         |        |                |

  ### テーブル：program_genres
  | カラム名   | データ型 | NULL | キー              | 初期値 | AUTO INCREMENT |
  | ---------- | -------- | ---- | ----------------- | ------ | -------------- |
  | genre_id   | BIGINT   |      | PRIMARY / FOREIGN |        |                |
  | program_id | BIGINT   |      | PRIMARY / FOREIGN |        |                |
  - 外部キー制約：genre_idに対して、genresテーブルのidから設定
  - 外部キー制約：program_idに対して、programsテーブルのidから設定

  ### テーブル：genres
  | カラム名 | データ型     | NULL | キー    | 初期値 | AUTO INCREMENT |
  | -------- | ------------ | ---- | ------- | ------ | -------------- |
  | id       | BIGINT       |      | PRIMARY |        | YES            |
  | name     | VARCHAR(255) |      |         |        |                |
  - ユニークキー制約：nameに対して設定

  ### テーブル：seasons
  | カラム名          | データ型     | NULL | キー    | 初期値 | AUTO INCREMENT |
  | ----------------- | ------------ | ---- | ------- | ------ | -------------- |
  | id                | BIGINT       |      | PRIMARY |        | YES            |
  | season_num        | INT          | YES  |         |        |                |
  | is_single_episode | BOOLEAN      |      |         | FALSE  |                |
  | program_id        | BIGINT       |      | FOREIGN |        |                |
  - 外部キー制約：program_idに対して、programsテーブルのidから設定

  ### テーブル：episodes
  | カラム名     | データ型     | NULL | キー    | 初期値 | AUTO INCREMENT |
  | ------------ | ------------ | ---- | ------- | ------ | -------------- |
  | id           | BIGINT       |      | PRIMARY |        | YES            |
  | episode_num  | INT          | YES  |         |        |                |
  | title        | VARCHAR(255) |      |         |        |                |
  | description  | TEXT         |      |         |        |                |
  | duration     | TIME         |      |         |        |                |
  | release_date | DATE         |      |         |        |                |
  | season_id    | BIGINT       |      | FOREIGN |        |                |
  - 外部キー制約：season_idに対して、seasonsテーブルのidから設定

  ### テーブル：program_slots
  | カラム名   | データ型 | NULL | キー    | 初期値 | AUTO INCREMENT |
  | ---------- | -------- | ---- | ------- | ------ | -------------- |
  | id         | BIGINT   |      | PRIMARY |        | YES            |
  | start_time | DATETIME |      |         |        |                |
  | end_time   | DATETIME |      |         |        |                |
  | channel_id | BIGINT   |      | FOREIGN |        |                |
  - 外部キー制約：channel_idに対して、channelsテーブルのidから設定

  ### テーブル：broadcast_episodes
  | カラム名        | データ型 | NULL | キー              | 初期値 | AUTO INCREMENT |
  | --------------- | -------- | ---- | ----------------- | ------ | -------------- |
  | program_slot_id | BIGINT   |      | PRIMARY / FOREIGN |        |                |
  | episode_id      | BIGINT   |      | PRIMARY / FOREIGN |        |                |
  | view_count      | BIGINT   |      |                   | 0      |                |
  - 外部キー制約：program_slot_idに対して、program_slotsテーブルのidから設定
  - 外部キー制約：episode_idに対して、episodesテーブルのidから設定
</details>


<details>
  <summary><h2>ステップ2：環境構築手順</h2></summary>

  1. プロジェクトルートで下記のコマンドを実行し、MySQLコンテナをビルド ⇒ 起動します。<br>※ 初回コンテナ起動時に`/docker-entrypoint-initdb.d/init.sql`が自動実行され、テーブルとサンプルデータが作成されるようになっています。（compose.ymlに対象のSQLスクリプトをマウントする処理を記述しています。）

      ```
      docker compose up -d --build
      ```

  2. 下記のコマンドを実行してパスワードを入力すると、起動したコンテナ内のMySQLにログインできます。<br>※ ホスト側の<code>./docker/db/.env</code>で指定したデータベース（week5_6）とパスワードを使います。<br>※ 1の手順にて全てのSQLが実行された後はコンテナが再起動されるので、再起動完了までにログインしようとするとエラーになります。その場合は少し待って再度ログインしてください。

      ```
      docker compose exec -it db mysql -u root -D week5_6 -p
      ```

  3. week5_6が選択され、テーブルが構築されているかを確認します。

      ```
      SELECT DATABASE();
      SHOW TABLES;
      ```
</details>


<details>
  <summary><h2>ステップ3：SQLの作成</h2></summary>

  1. よく見られているエピソードを知りたいです。エピソード視聴数トップ3のエピソードタイトルと視聴数を取得してください。
      ```mysql
      SELECT
        e.title,
        be.view_count
      FROM episodes AS e
        INNER JOIN broadcast_episodes AS be
          ON e.id = be.episode_id
      ORDER BY view_count DESC
      LIMIT 3;
      ```

  2. よく見られているエピソードの番組情報やシーズン情報も合わせて知りたいです。エピソード視聴数トップ3の番組タイトル、シーズン数、エピソード数、エピソードタイトル、視聴数を取得してください。
      ```mysql
      SELECT
        p.title AS program_title,
        s.season_num,
        e.episode_num,
        e.title AS episode_title,
        be.view_count
      FROM episodes AS e
        INNER JOIN broadcast_episodes AS be
          ON e.id = be.episode_id
        INNER JOIN seasons AS s
          ON e.season_id = s.id
        INNER JOIN programs AS p
          ON s.program_id = p.id
      ORDER BY view_count DESC
      LIMIT 3;
      ```

  3. 本日の番組表を表示するために、本日、どのチャンネルの、何時から、何の番組が放送されるのかを知りたいです。本日放送される全ての番組に対して、チャンネル名、放送開始時刻(日付+時間)、放送終了時刻、シーズン数、エピソード数、エピソードタイトル、エピソード詳細を取得してください。なお、番組の開始時刻が本日のものを本日方法される番組とみなすものとします。
      ```mysql
      SELECT
        c.name,
        ps.start_time,
        ps.end_time,
        s.season_num,
        e.episode_num,
        e.title,
        e.description
      FROM channels AS c
        INNER JOIN program_slots AS ps
          ON c.id = ps.channel_id
        INNER JOIN broadcast_episodes AS bs
          ON ps.id = bs.program_slot_id
        INNER JOIN episodes AS e
          ON bs.episode_id = e.id
        INNER JOIN seasons AS s
          ON e.season_id = s.id
      WHERE DATE(ps.start_time) = CURDATE()
      ORDER BY ps.start_time;
      ```

  4. ドラマというチャンネルがあったとして、ドラマのチャンネルの番組表を表示するために、本日から一週間分、何日の何時から何の番組が放送されるのかを知りたいです。ドラマのチャンネルに対して、放送開始時刻、放送終了時刻、シーズン数、エピソード数、エピソードタイトル、エピソード詳細を本日から一週間分取得してください。
      ```mysql
      SELECT
        ps.start_time,
        ps.end_time,
        COALESCE(s.season_num, 'Single Episode') AS 'season_num',
        e.episode_num,
        e.title,
        e.description
      FROM channels AS c
        INNER JOIN program_slots AS ps
          ON c.id = ps.channel_id
        INNER JOIN broadcast_episodes AS be
          ON ps.id = be.program_slot_id
        INNER JOIN episodes AS e
          ON be.episode_id = e.id
        INNER JOIN seasons AS s
          ON e.season_id = s.id
      WHERE c.name = 'チャンネル1'
        AND ps.start_time BETWEEN CURDATE() AND CURDATE() + INTERVAL 1 WEEK
      ORDER BY ps.start_time;
      ```

  5. 直近一週間で最も見られた番組が知りたいです。直近一週間に放送された番組の中で、エピソード視聴数合計トップ2の番組に対して、番組タイトル、視聴数を取得してください。
      ```mysql
      SELECT
        p.title,
        SUM(be.view_count) AS sum_view_count
      FROM programs AS p
        INNER JOIN seasons AS s
          ON p.id = s.program_id
        INNER JOIN episodes AS e
          ON s.id = e.season_id
        INNER JOIN broadcast_episodes AS be
          ON e.id = be.episode_id
        INNER JOIN program_slots AS ps
          ON be.program_slot_id = ps.id
      WHERE ps.start_time BETWEEN CURDATE() AND CURDATE() + INTERVAL 1 WEEK
      GROUP BY p.id
      ORDER BY sum_view_count DESC
      LIMIT 2
      ;
      ```

  6. ジャンルごとの番組の視聴数ランキングを知りたいです。番組の視聴数ランキングはエピソードの平均視聴数ランキングとします。ジャンルごとに視聴数トップの番組に対して、ジャンル名、番組タイトル、エピソード平均視聴数を取得してください。
      ```mysql
      -- ウィンドウ関数の結果をWHERE句で使用したいのでFROM句の副問い合わせにする必要がある（ウィンド関数を記述できるSELECT句はWHERE句よりも後に実行される為）
      SELECT
        genre_avg_views.name,
        genre_avg_views.title,
        genre_avg_views.avg_view_count
      FROM (
        SELECT
          g.name,
          p.title,
          AVG(be.view_count) AS avg_view_count,
          RANK() OVER (
            PARTITION BY pg.genre_id
            ORDER BY AVG(be.view_count) DESC
          ) AS view_count_rank
        FROM programs AS p
          INNER JOIN program_genres AS pg
            ON p.id = pg.program_id
          INNER JOIN genres AS g
            ON pg.genre_id = g.id
          INNER JOIN seasons AS s
            ON p.id = s.program_id
          INNER JOIN episodes AS e
            ON s.id = e.season_id
          INNER JOIN broadcast_episodes AS be
            ON e.id = be.episode_id
        GROUP BY pg.genre_id, p.id
      ) AS genre_avg_views
      WHERE genre_avg_views.view_count_rank = 1;
      ```
</details>
