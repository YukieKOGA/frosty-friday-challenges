
  
    

        create or replace transient table DBT_PROJECT.PUBLIC.week1_advanced
         as
        (

  with source_data as (
      select 1 as id
      union all
      select null as id
  )

  select *
  from source_data
        );
      
  