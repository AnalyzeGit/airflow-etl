INSERT INTO staging.order (
    order_id,
    user_id,
    order_amount,
    order_time,
    status
)
SELECT  
    order_id,
    user_id,
    order_amount,
    order_time,
    status
FROM raw."order"
ON CONFLICT (order_id)
DO UPDATE SET
    user_id      = EXCLUDED.user_id,
    order_amount = EXCLUDED.order_amount,
    order_time   = EXCLUDED.order_time,
    status       = EXCLUDED.status;
