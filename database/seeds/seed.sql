INSERT INTO hotel_bookings (
    id,
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
SELECT
    gen_random_uuid(),

    CASE
        WHEN gs % 3 = 0 THEN '11111111-1111-1111-1111-111111111111'::uuid
        WHEN gs % 3 = 1 THEN '22222222-2222-2222-2222-222222222222'::uuid
        ELSE '33333333-3333-3333-3333-333333333333'::uuid
    END,

    'HOTEL-' || (gs % 10),

    CASE
        WHEN gs % 5 = 0 THEN 'delhi'
        WHEN gs % 5 = 1 THEN 'mumbai'
        WHEN gs % 5 = 2 THEN 'chennai'
        WHEN gs % 5 = 3 THEN 'bangalore'
        ELSE 'hyderabad'
    END,

    CURRENT_DATE + (gs % 10),

    CURRENT_DATE + (gs % 10) + 2,

    ROUND((1000 + random() * 9000)::numeric,2),

    CASE
        WHEN gs % 4 = 0 THEN 'CONFIRMED'
        WHEN gs % 4 = 1 THEN 'PENDING'
        WHEN gs % 4 = 2 THEN 'CANCELLED'
        ELSE 'COMPLETED'
    END,

    NOW() - ((gs % 60) || ' days')::interval

FROM generate_series(1,100) AS gs;

INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    id,

    CASE
        WHEN random() < 0.5
        THEN 'BOOKING_CREATED'
        ELSE 'PAYMENT_SUCCESS'
    END,

    jsonb_build_object(
        'source','website',
        'currency','INR'
    ),

    created_at

FROM hotel_bookings
LIMIT 60;
