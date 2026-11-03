# erp-worker

Celery workers and beat scheduler for the order management system.

Celery tasks are part of the API codebase (`apps/*/tasks.py`, config in `config/settings_parts/celery.py`), so this repo does
NOT copy code: it pins `erp-backend` as a git submodule (`backend/`) and only owns how the processes are built and run
(queues, concurrency, memory limits, health checks).

## Setup
```bash
git clone --recurse-submodules <this repo>
git submodule update --remote backend   # bump the pinned API version deliberately, then commit
docker compose -f compose.worker.yml --env-file .env up -d --build
```
## Processes (same image, different command; queues from the old prod compose)
| service | queues | default concurrency |
|---|---|---|
| worker | default, orders, lark_noti, audit | CELERY_WORKER_CONCURRENCY |
| worker-kiotviet | kiotviet | 4 |
| worker-slow | slow | 2 |
| worker-export | exports | 2 |
| worker-foxia | foxia | 1 |
| beat | (scheduler, `django_celery_beat` DatabaseScheduler) | 1 instance only |

Needs the same env as the API (DB, Redis broker, secrets): provide your own `.env`, never commit it.
Rule: keep API and worker on the same API commit; deploy API first when a migration is involved.
