# Frosty Friday Challenges

このリポジトリは、Snowflake学習コミュニティ「Frosty Friday」のウィークリーチャレンジを通じて、SnowflakeとSQLのスキルを体系的に習得することを目的としています。初級者から上級者まで段階的に学べる構成になっています。

## Frosty Fridayとは

Frosty FridayはSnowflakeに関する週次の学習チャレンジを提供するコミュニティサイトです。毎週、新しい課題に取り組むことで実践的なSnowflake機能とSQLテクニックを習得できます。

## 学習の進め方
1. `challenges/week-001` から順にチャレンジを進めます。
2. 各フォルダには課題内容(`README.md`)、解答SQL(`solution.sql`)、解説(`explanation.md`)が含まれます。
3. 必要に応じて `docs/` 以下のドキュメントで概念を整理し、`learning-notes.md` に学習メモを記録してください。

## Snowflake環境セットアップ
1. Snowflakeアカウントを作成します。
2. `scripts/setup-snowflake.sql` を実行し、初期オブジェクトやロールを構築します。
3. VS Codeで[SQL拡張機能](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-sql)をインストールし、このリポジトリを開いて学習を開始してください。

## フォルダ構成
```
frosty-friday-challenges/
├── README.md
├── docs/
│   ├── learning-notes.md
│   ├── snowflake-concepts.md
│   └── sql-patterns.md
├── challenges/
│   ├── week-001/
│   │   ├── README.md
│   │   ├── solution.sql
│   │   ├── explanation.md
│   │   └── sample-data/
│   ├── week-002/
│   └── week-003/
├── templates/
│   ├── challenge-template.md
│   └── solution-template.sql
├── scripts/
│   ├── setup-snowflake.sql
│   └── test-queries.sql
├── .vscode/
│   ├── extensions.json
│   └── settings.json
└── .gitignore
```

Frosty Fridayチャレンジを通じて、Snowflakeの理解を深めましょう。
