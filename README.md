# Terraform + Database Reliability Assessment

## Technologies

- Terraform
- AWS
- Docker Compose
- PostgreSQL
- GitHub Actions

## Author

Prashanth

## Query Optimization

The following query filters booking records by city and created_at then groups the results by org_id and status.

```sql
SELECT org_id, status, COUNT(*), SUM(amount)
FROM hotel_bookings
WHERE city = 'delhi'
  AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY org_id, status;
```

To optimize this query, I created the following composite index:

```sql
CREATE INDEX idx_hotel_bookings_city_created
ON hotel_bookings(city, created_at);
```

### Why this index?

city is an equality filter.
created_at is a range filter.
The composite index allows PostgreSQL to quickly locate rows that match both conditions before performing the aggregation.

For this assessment's dataset (100 rows), PostgreSQL may still choose a sequential scan because scanning the entire table is inexpensive. With larger datasets, the composite index significantly reduces the number of rows that must be scanned.


## Backup

Run:

```bash
./scripts/backup.sh
```

A timestamped SQL backup is created in /home/ubuntu/terraform-db-assessment/database/backups/.

## Restore

Run:

```bash
./scripts/restore.sh /home/ubuntu/terraform-db-assessment/database/backups/<backup-file>.sql
```

## Verify

Connect to the restored database:

```bash
psql -h localhost -U postgres -d hoteldb_restore
```

Verify the data:

```sql
SELECT COUNT(*) FROM hotel_bookings;
SELECT COUNT(*) FROM booking_events;
```
completed
