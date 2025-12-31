#!/bin/bash

set -e # 스크립트 실행 중 어떤 명령이든 하나라도 실패하면 즉시 스크립트를 중단(exit)시키는 옵션.

echo "▶ Airflow setup started"

# 1. 환경 변수 로드 (.env 파일: 파일 존재 및 일반파일 검사함)
if [ ! -f .env ]; then
  echo "❌ .env file not found"
  exit 1
fi

source .env # 현재 셀에 변 수를 로드함.

# 2. Airflow 초기화 (DB + 기본 계정 생성)
docker compose up airflow-init

# 3. Airflow 컨테이너 기동
docker compose up -d

# 4. Airflow Postgres Connection 생성
docker compose exec airflow-webserver airflow connections add my_postgres_connection \
    --conn-type postgres \
    --conn-host $POSTGRES_HOST \
    --conn-schema $POSTGRES_DB \
    --conn-login $POSTGRES_USER \
    --conn-password $POSTGRES_PASSWORD \
    --conn-port $POSTGRES_PORT || true # 이 줄에서 에러 나도 괜찮다, 계속 가라”는 의도 표현


echo "✅ Airflow setup completed"
echo "👉 Airflow UI: http://localhost:8080"
echo "👉 Login: $AIRFLOW_ADMIN_USER / $AIRFLOW_ADMIN_PASSWORD"
