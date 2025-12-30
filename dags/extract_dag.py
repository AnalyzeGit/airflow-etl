from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

default_args = {"start_date": datetime(2025, 12, 29)}

with DAG(
    'postgres_extractor',
    description='PostgreSQL extract',
    default_args=default_args,
    schedule='0 0 * * *',
    catchup=False
) as dag:

    postgres_task = PostgresOperator(
        task_id = 'execute_sql_query',
        postgres_conn_id='my_postgres_connection',
        sql="sql/extract_orders.sql"
    )