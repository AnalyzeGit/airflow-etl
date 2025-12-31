UPDATE staging.order
SET order_time = NOW()
WHERE order_time IS NULL;