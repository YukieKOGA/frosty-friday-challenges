
  
    

        create or replace transient table DBT_PROJECT.week1.week1_basic
         as
        (

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
        );
      
  