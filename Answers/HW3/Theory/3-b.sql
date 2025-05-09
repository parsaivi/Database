CREATE OR REPLACE FUNCTION update_order_summary()
RETURNS TRIGGER AS $$
DECLARE
    current_total NUMERIC;
    difference NUMERIC;
    target_product_id INT;
    target_price NUMERIC;
    target_quantity NUMERIC;
    proportional_reduction NUMERIC;
    max_item_id RECORD;
BEGIN
    SELECT SUM(quantity * price) INTO current_total
    FROM order_items
    WHERE order_id = NEW.order_id;
    
    difference := NEW.total_amount - current_total;
    
    IF difference > 0 THEN
        SELECT product_id, unit_price INTO target_product_id, target_price
        FROM products
        ORDER BY product_id
        LIMIT 1;
        
        target_quantity := difference / target_price;
        
        INSERT INTO order_items (order_id, product_id, quantity, price)
        VALUES (NEW.order_id, target_product_id, target_quantity, target_price);
        
    ELSIF difference < 0 THEN
        SELECT * INTO max_item_id
        FROM order_items
        WHERE order_id = NEW.order_id
        ORDER BY quantity * price DESC
        LIMIT 1;
        
        proportional_reduction := LEAST(ABS(difference) / (max_item_id.quantity * max_item_id.price), 1);
        
        target_quantity := max_item_id.quantity * (1 - proportional_reduction);
        
        UPDATE order_items
        SET quantity = target_quantity
        WHERE order_id = NEW.order_id AND product_id = max_item_id.product_id;
        
        DELETE FROM order_items
        WHERE order_id = NEW.order_id AND quantity <= 0;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER instead_of_update_order_summary
INSTEAD OF UPDATE ON order_summary
FOR EACH ROW
EXECUTE FUNCTION update_order_summary();