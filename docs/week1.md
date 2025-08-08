# Frosty Friday Week 1 学習記録

## チャレンジ概要

**タイトル**: External Stage and CSV Loading  
**難易度**: Beginner  
**URL**: https://frostyfriday.org/blog/2022/07/14/week-1/  
**日付**: 2025-08-03

### 課題内容
FrostyFriday Inc.のS3バケットからCSVデータを直接外部ステージ経由でテーブルに読み込む。

**S3バケット**: `s3://frostyfridaychallenges/challenge_1/`

### 要求仕様
1. 外部ステージの作成
2. CSVファイルフォーマットの設定
3. ステージから直接テーブルへのデータロード

---

## 基本実装

### 使用した基本技術

#### 1. Snowflake External Stages
**概要**：
Snowflake外部のクラウドストレージ上のファイルに直接アクセスするための仕組み。

**実装例**：
```sql
CREATE STAGE week1_ext_stage
URL = 's3://frostyfridaychallenges/challenge_1/'
FILE_FORMAT = csv_file_format;
```

**重要ポイント**：
- データコピー前のアクセスが可能
- ストレージコストの節約
- リアルタイムデータアクセス

#### 2. dbtのpre_hook
**概要**：
モデル実行前に実行されるSQL。インフラストラクチャ準備に最適。

**実装例**：
```sql
{{ config(
    pre_hook=[
        "CREATE FILE FORMAT IF NOT EXISTS ...",
        "CREATE STAGE IF NOT EXISTS ..."
    ]
) }}
```

**重要ポイント**：
- モデルの依存関係を明確化
- インフラ設定の自動化

### 基本実装コード

**ファイル**: `fct_week_01_basic.sql`

**実装のポイント**：
- pre_hookでFile FormatとStageを作成
- {{ this.schema }}を使用してスキーマ参照
- メタデータカラム（METADATA$FILENAME等）を活用

**実行結果**：
個別行レベルでCSVファイルの内容とメタデータを取得

---

## 発展実装

### 追加で学んだ技術

#### 1. LISTAGG関数
**概要**：
複数行を指定区切り文字で連結する集約関数。

**実装例**：
```sql
LISTAGG(value, ' ') WITHIN GROUP (ORDER BY source_file, file_row_number)
```

**この技術を選んだ理由**：
複数ファイルの内容を組み合わせて完全なメッセージを構成するため

### 発展実装コード

**ファイル**: `fct_week_01_advanced.sql`

**実装のポイント**：
- ref()を使用して基本版に依存
- LISTAGG関数で複数行を文字列連結
- ORDER BYで連結順序を制御

**実行結果**：
"You have gotten it right conglatulations!" という完全なメッセージを取得

---

## dbt設計パターン

### モデル構成
```
models/week_01/
├── fct_week_01_basic.sql      # 外部ステージ設定 + 生データ取得
└── fct_week_01_advanced.sql   # 基本版からの集約処理
```

---

## トラブルシューティング

### 遭遇した問題

#### 1. スキーマ参照エラー
**エラー**: `File format 'CSV_FILE_FORMAT' does not exist`

**原因**：
`{{ target.schema }}`がprofiles.ymlのデフォルト（public）を返すため

**解決策**：
`{{ this.schema }}`を使用して正しいスキーマを参照するように修正

---

## 学習のポイント

### 技術選択の比較

#### データロード手法の検討

**SELECT FROM STAGE**: 直接クエリアプローチ
```sql
SELECT 
    $1::VARCHAR AS value,
    METADATA$FILENAME AS source_file
FROM @week1_ext_stage;
```
- 利点: シンプル、ストレージ不要、学習に最適
- 欠点: 毎回ステージアクセス、増分ロード手動実装

**COPY INTO**: 物理コピーアプローチ
```sql
COPY INTO raw_data (value, source_file)
FROM (
    SELECT $1, METADATA$FILENAME
    FROM @week1_ext_stage
);
```
- 利点: 高速アクセス、増分ロードサポート、本番向け
- 欠点: ストレージ必要、複雑、初期ロード時間

**Week 1での選択**: SELECT FROM STAGEを選択
学習目的でシンプルさを重視、小規模データに適している

#### ファイルフォーマット指定タイミングの検討

**ステージ作成時に指定**: 
```sql
CREATE STAGE week1_ext_stage
URL = 's3://bucket/'
FILE_FORMAT = csv_file_format;

-- 使用時はシンプル
SELECT $1 FROM @week1_ext_stage;
```
- 利点: 毎回の指定不要、ミス防止、専用ステージとして明確
- 欠点: 単一フォーマット限定、柔軟性に欠ける

**SELECT時に指定**: 
```sql
CREATE STAGE week1_ext_stage
URL = 's3://bucket/';

-- 使用時にフォーマット指定
SELECT $1 FROM @week1_ext_stage (FILE_FORMAT => csv_file_format);
```
- 利点: 複数フォーマット対応、動的切り替え可能、探索的分析に適す
- 欠点: 毎回記述必要、フォーマット忘れリスク

**Week 1での選択**: ステージ作成時指定を選択
単一フォーマット（CSV）のみを扱い、学習段階でのシンプルさを重視

### 新しく学んだ概念
1. **外部ステージ**: クラウドストレージとの直接統合
   ```sql
   CREATE STAGE week1_ext_stage
   URL = 's3://frostyfridaychallenges/challenge_1/'
   FILE_FORMAT = csv_file_format;
   ```
2. **LISTAGG関数**: 文字列集約の強力な機能
   ```sql
   LISTAGG(value, ' ') WITHIN GROUP (ORDER BY source_file, file_row_number)
   ```
3. **dbt依存関係**: ref()による明示的な依存管理
   ```sql
   SELECT * FROM {{ ref('fct_week_01_basic') }}
   ```

### 実務への応用
- データレイク統合での外部ステージ活用
- 複数ソースからのレポート文書生成でのLISTAGG活用
- 段階的データパイプライン構築でのdbt設計パターン活用

---

## 参考資料

### 公式ドキュメント
- [Snowflake External Stages](https://docs.snowflake.com/en/user-guide/data-load-s3)
- [dbt ref() Function](https://docs.getdbt.com/reference/dbt-jinja-functions/ref)
- [LISTAGG Function](https://docs.snowflake.com/en/sql-reference/functions/listagg)

### コミュニティ資料
- [Frosty Friday Week 1](https://frostyfriday.org/blog/2022/07/14/week-1/)

---

**完了日**: 2025-08-03  
**所要時間**: 約3時間  
**難易度評価**: ⭐⭐⭐☆☆（基本から発展、dbt設計パターンまで）  
**満足度**: ⭐⭐⭐⭐⭐（技術習得、設計パターン学習、隠された課題解決）