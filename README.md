# Airflow 기반 PostgreSQL ETL 파이프라인

## 프로젝트 개요

이 프로젝트는 **Docker Compose로 구성된 Apache Airflow 환경**에서 **PostgreSQLOperator**를 활용해 ETL(Extract–Transform–Load) 파이프라인를 구현한 예제입니다.

전체 흐름은 *조립라인*과 유사합니다.
원천 데이터 → 중간 가공 → 최종 적재를 각각 분리된 단계로 처리하고, Airflow가 이 순서를 안정적으로 제어합니다.

---

## 아키텍처 구성

* **Airflow (Docker Compose)**
  스케줄링 및 태스크 의존성 관리

* **PostgreSQL**
  staging / mart 레이어 분리

* **PostgresOperator**
  Python 코드 없이 SQL 기반 ETL 수행

* **Bash Script (`setup.sh`)**
  초기 환경 설정 및 실행 자동화

---

## 디렉터리 구조

```
airflow-etl/
├─ dags/
│  ├─ etl_dag.py          # ETL DAG 정의
│  └─ sql/
│     ├─ extract_orders.sql
│     ├─ transform_orders.sql
│     └─ load_orders.sql
├─ scripts/
│  └─ setup.sh            # Airflow 초기화 및 실행 스크립트
├─ docker-compose.yaml
├─ airflow.cfg
└─ README.md
```

---

## ETL DAG 설명

`etl_dag.py`에서는 하나의 DAG 안에서 세 단계가 순차적으로 실행됩니다.

1. **Extract**
   원천 테이블에서 주문 데이터 조회

2. **Transform**
   staging 영역에서 데이터 정제 및 가공

3. **Load**
   mart 테이블에 최종 적재 (UPSERT 방식)

각 단계는 `PostgresOperator`로 정의되며, SQL 파일을 직접 실행하는 구조입니다.

```python
extract_task >> transform_task >> load_task
```

이는 *파이프를 직렬로 연결한 구조*와 같아, 앞 단계가 끝나야 다음 단계가 흐를 수 있습니다.

---

## SQL Load 전략

`load_orders.sql`에서는 `ON CONFLICT` 구문을 사용해 **중복 데이터에 안전한 적재(Upsert)** 를 수행합니다.

* 신규 주문: INSERT
* 기존 주문: UPDATE

이를 통해 배치 재실행 시에도 데이터 정합성을 유지합니다.

---

## 실행 방법

### 1. 환경 변수 설정

`.env` 파일에 PostgreSQL 및 Airflow 계정 정보를 정의합니다.

### 2. Airflow 초기화 및 실행

```bash
bash scripts/setup.sh
```

해당 스크립트는 아래 작업을 자동으로 수행합니다.

* `.env` 로드
* Airflow DB 초기화
* 컨테이너 기동
* PostgreSQL Connection 자동 등록

---

## Airflow UI 접속

* URL: [http://localhost:8080](http://localhost:8080)
* ID / PW: `.env`에 정의된 관리자 계정

---

## 정리

Docker Compose 기반 Airflow 환경에서 SQL 중심의 PostgreSQL ETL 파이프라인을 자동화한 프로젝트입니다.
