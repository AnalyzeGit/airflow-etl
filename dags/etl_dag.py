from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

default_args = {"start_date": datetime(2025, 12, 30)}

with DAG(
    'postgres_etl',
    description='Extract, transform, and load data using PostgreSQL.',
    default_args=default_args,
    schedule='0 0 * * *',
    catchup=False
) as dag:

    extract_task = PostgresOperator(
        task_id = 'extract_from_postgres',
        postgres_conn_id='my_postgres_connection',
        sql="sql/extract_orders.sql"
    )

    transform_task = PostgresOperator(
        task_id = 'transform_from_postgres',
        postgres_conn_id='my_postgres_connection',
        sql="sql/transform_orders.sql"
    )

    load_task = PostgresOperator(
        task_id = 'load_from_postgres',
        postgres_conn_id='my_postgres_connection',
        sql="sql/load_orders.sql"
    )

    extract_task >> transform_task >> load_task
