# よく使うSQLパターン集

```sql
-- 日付範囲を生成する例
SELECT DATEADD(day, seq4(), '2024-01-01') AS day
FROM TABLE(GENERATOR(ROWCOUNT => 10));
```

```sql
-- 配列を展開する例
SELECT VALUE::STRING AS element
FROM TABLE(FLATTEN(INPUT => PARSE_JSON('["a","b","c"]')));
```

頻繁に使うクエリや構文をまとめておきます。
