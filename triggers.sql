CREATE OR REPLACE FUNCTION check_down_payment()
RETURNS TRIGGER AS $$
DECLARE
    vehicle_price NUMERIC(10,2);
BEGIN
    SELECT price INTO vehicle_price FROM vehicles WHERE vehicle_id = NEW.vehicle_id;

    IF NEW.down_payment < 0.45 * vehicle_price THEN
        RAISE EXCEPTION 'Down payment must be at least 45%% of the vehicle price (%.2f)', vehicle_price * 0.45;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;