{{ config(
    materialized='table',
    schema='week1',
    pre_hook=[
        "create or replace file format {{ this.schema }}.csv_file_format
         type = 'csv'
         field_delimiter = ','
         skip_header = 1
         null_if = ('NULL', 'totally_empty')",
         
        "create or replace stage {{ this.schema }}.week1_ext_stage
         url = 's3://frostyfridaychallenges/challenge_1/'
         file_format = {{ this.schema }}.csv_file_format
         directory = (enable = true)"
    ]
) }}

with source as (
    select 
        $1 as value,
        metadata$filename as source_file,
        metadata$file_row_number as file_row_number,
        metadata$start_scan_time as load_timestamp
    from @dbt_project.week1.week1_ext_stage
),

final as (
    select 
        value,
        source_file,
        file_row_number,
        load_timestamp
    FROM source
)

select
    *
from final