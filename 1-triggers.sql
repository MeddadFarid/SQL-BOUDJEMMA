-- 1/ Trigger pour mettre à jour la quantité en stock d'un produit lorsqu'une facture est créée :

DELIMITER //

CREATE TRIGGER update_product_quantity AFTER INSERT ON facture_product
FOR EACH ROW
BEGIN
  UPDATE product
  SET Quantity = Quantity - NEW.Quantity
  WHERE product_id = NEW.product_id;

  -- Deduct the sum of the new facture from the caisse
  UPDATE caisse
  SET amount_caisse = amount_caisse + NEW.sum
  WHERE caisse_id = 1; -- Replace 1 with the appropriate caisse_id
END;

DELIMITER ;


--2/Trigger pour vérifier si la quantité en stock d'un produit est suffisante avant d'ajouter une facture de produit :

DELIMITER //


CREATE TRIGGER check_product_quantity BEFORE INSERT ON facture_product
FOR EACH ROW
BEGIN
  DECLARE product_quantity INT;
  SELECT Quantity INTO product_quantity
  FROM product
  WHERE product_id = NEW.product_id;
  
  IF product_quantity < NEW.Quantity THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient product quantity';
  END IF;
END;

DELIMITER ;

-- 3/ Trigger pour mettre à jour le montant total d'une facture lorsque des produits y sont ajoutés :

DELIMITER //

CREATE TRIGGER update_facture_total AFTER INSERT ON facture_product
FOR EACH ROW
BEGIN
  DECLARE facture_id INT;
  DECLARE facture_total DECIMAL(10,2);
  
  SET facture_id = NEW.facture_id;
  SET facture_total = (SELECT SUM(Quantity * price)
                       FROM facture_product fp
                       JOIN product p ON fp.product_id = p.product_id
                       WHERE fp.facture_id = facture_id);
  
  UPDATE facture
  SET total_amount = facture_total
  WHERE facture_id = facture_id;
END;
DELIMITER ;


-- 4/ Trigger pour mettre à jour le stock d'un produit lorsqu'un versement est effectué pour une facture 
DELIMITER //

CREATE TRIGGER update_product_stock AFTER INSERT ON versement
FOR EACH ROW
BEGIN
    UPDATE product
    SET Quantity = Quantity + NEW.Quantity
    WHERE product_id = NEW.product_id;
END;
DELIMITER ;

-- 5/When a Product's name changes -> Add previous name and date to its History name
DELIMITER //

CREATE TRIGGER product_name_change_trigger
BEFORE UPDATE ON product
FOR EACH ROW
BEGIN
  IF NEW.product_name != OLD.product_name THEN
    INSERT INTO history_product (product_id, product_previous_name, previous_price, user_id, date)
    VALUES (OLD.product_id, OLD.product_name, OLD.price, NEW.user_id, CURDATE());
  END IF;
END;

DELIMITER ;

-- 6.1/Trigger for when a bon is inserted:
DELIMITER //

CREATE TRIGGER insert_bon_trigger
AFTER INSERT ON bon
FOR EACH ROW
BEGIN
  -- Add the quantity of the products in this bon to the product's quantity
  UPDATE product
  JOIN bon_product ON product.product_id = bon_product.product_id
  SET product.Quantity = product.Quantity + bon_product.Quantity
  WHERE bon_product.bon_id = NEW.bon_id;
  
  -- Add the quantity of the other products in this bon to the other product's quantity
  UPDATE product
  JOIN bon_product ON product.product_id = bon_product.product_id
  SET product.Quantity = product.Quantity + bon_product.Quantity
  WHERE bon_product.bon_id <> NEW.bon_id;
END;
DELIMITER ;

-- 6.2/ Trigger for when a bon is updated:
DELIMITER //

CREATE TRIGGER update_bon_trigger
AFTER UPDATE ON bon
FOR EACH ROW
BEGIN
  -- Recalculate the quantity of the products in this bon
  UPDATE product
  JOIN bon_product ON product.product_id = bon_product.product_id
  SET product.Quantity = product.Quantity - OLD.Quantity + NEW.Quantity
  WHERE bon_product.bon_id = NEW.bon_id;
  
  -- Recalculate the quantity of the other products in this bon
  UPDATE product
  JOIN bon_product ON product.product_id = bon_product.product_id
  SET product.Quantity = product.Quantity - OLD.Quantity + NEW.Quantity
  WHERE bon_product.bon_id <> NEW.bon_id;
END;
DELIMITER ;

-- 7.1/Trigger for when a new facture is inserted (excluding brouillon):
DELIMITER //

CREATE TRIGGER insert_facture_trigger
AFTER INSERT ON facture
FOR EACH ROW
BEGIN
  IF NEW.Brouillon = 0 THEN
    -- Subtract the quantity of the products in this facture from the product's quantity
    UPDATE product
    JOIN facture_product ON product.product_id = facture_product.product_id
    SET product.Quantity = product.Quantity - facture_product.Quantity
    WHERE facture_product.facture_id = NEW.facture_id;
    
    -- Subtract the quantity of the other products in this facture from the other product's quantity
    UPDATE product
    JOIN facture_product ON product.product_id = facture_product.product_id
    SET product.Quantity = product.Quantity - facture_product.Quantity
    WHERE facture_product.facture_id <> NEW.facture_id;
  END IF;
END;
DELIMITER ;

-- 7.2/Trigger for when a facture is updated:
DELIMITER //
CREATE TRIGGER update_facture_trigger
AFTER UPDATE ON facture
FOR EACH ROW
BEGIN
  -- Recalculate the quantity of the products in this facture
  UPDATE product
  JOIN facture_product ON product.product_id = facture_product.product_id
  SET product.Quantity = product.Quantity + OLD.Quantity - NEW.Quantity
  WHERE facture_product.facture_id = NEW.facture_id;
  
  -- Recalculate the quantity of the other products in this facture
  UPDATE product
  JOIN facture_product ON product.product_id = facture_product.product_id
  SET product.Quantity = product.Quantity + OLD.Quantity - NEW.Quantity
  WHERE facture_product.facture_id <> NEW.facture_id;
END;

DELIMITER ;

-- 8/History for Product Name Changes:
DELIMITER //
CREATE TRIGGER product_name_history_trigger
AFTER UPDATE ON product
FOR EACH ROW
BEGIN
  IF NEW.product_name <> OLD.product_name THEN
    INSERT INTO history_product (product_id, product_previous_name, previous_price, user_id)
    VALUES (OLD.product_id, OLD.product_name, OLD.price, NEW.user_id);
  END IF;
END;

DELIMITER; 

-- 9/History for Bon Insertions:
DELIMITER //
CREATE TRIGGER bon_insert_history_trigger
AFTER INSERT ON bon
FOR EACH ROW
BEGIN
  -- Add quantity of products in this bon to the product's quantity
  UPDATE product
  JOIN bon_product ON product.product_id = bon_product.product_id
  SET product.Quantity = product.Quantity + bon_product.Quantity
  WHERE bon_product.bon_id = NEW.bon_id;
  
  -- Add quantity of other products in this bon to the other product's quantity
  UPDATE product
  JOIN bon_product ON product.product_id = bon_product.product_id
  SET product.Quantity = product.Quantity + bon_product.Quantity
  WHERE bon_product.bon_id <> NEW.bon_id;

  -- Deduct the sum of the new bon from the coffer
  UPDATE coffer
  SET amount_coffer = amount_coffer - NEW.price
  WHERE coffer_id = 1; -- Replace 1 with the appropriate coffer_id


END;
DELIMITER ; 
-- 10/ History for Bon Updates:
DELIMITER //
CREATE TRIGGER bon_update_history_trigger
AFTER UPDATE ON bon
FOR EACH ROW
BEGIN
  -- Recalculate the quantity of the products in this bon
  UPDATE product
  JOIN bon_product ON product.product_id = bon_product.product_id
  SET product.Quantity = product.Quantity + OLD.Quantity - NEW.Quantity
  WHERE bon_product.bon_id = NEW.bon_id;
  
  -- Recalculate the quantity of the other products in this bon
  UPDATE product
  JOIN bon_product ON product.product_id = bon_product.product_id
  SET product.Quantity = product.Quantity + OLD.Quantity - NEW.Quantity
  WHERE bon_product.bon_id <> NEW.bon_id;
END;
DELIMITER ;

-- 11/History for Bon Updates:
DELIMITER //
CREATE TRIGGER bon_update_history_trigger
AFTER UPDATE ON bon
FOR EACH ROW
BEGIN
  -- Recalculate the quantity of the products in this bon
  UPDATE product
  JOIN bon_product ON product.product_id = bon_product.product_id
  SET product.Quantity = product.Quantity + OLD.Quantity - NEW.Quantity
  WHERE bon_product.bon_id = NEW.bon_id;
  
  -- Recalculate the quantity of the other products in this bon
  UPDATE product
  JOIN bon_product ON product.product_id = bon_product.product_id
  SET product.Quantity = product.Quantity + OLD.Quantity - NEW.Quantity
  WHERE bon_product.bon_id <> NEW.bon_id;
END;
DELIMITER ;

DELIMITER //
CREATE TRIGGER increase_caisse_amount
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.Transaction_type = 'money_in' AND NEW.Destination = 'cashier' THEN
        UPDATE caisse
        SET amount_caisse = amount_caisse + NEW.Amount;
    END IF;
END;
DELIMITER ;

DELIMITER //
CREATE TRIGGER decrease_caisse_amount
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.Transaction_type = 'money_out' AND NEW.Destination = 'cashier' THEN
        UPDATE caisse
        SET amount_caisse = amount_caisse - NEW.Amount;
    END IF;
END;

DELIMITER ;


DELIMITER //
CREATE TRIGGER increase_coffer_amount
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.Transaction_type = 'money_in' AND NEW.Destination = 'coffer' THEN
        UPDATE coffer
        SET amount_coffer = amount_coffer + NEW.Amount;
    END IF;
END;

DELIMITER ;

DELIMITER //
CREATE TRIGGER decrease_caisse_amount
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.Transaction_type = 'money_out' AND NEW.Destination = 'cashier' THEN
        UPDATE coffer
        SET amount_coffer = amount_coffer - NEW.Amount;
    END IF;
END;

DELIMITER ;

DELIMITER //
CREATE TRIGGER increase_caisse_decrease_coffer
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.Transaction_type = 'money_in' AND NEW.Destination = 'switch' THEN
        UPDATE caisse
        SET amount_caisse = amount_caisse + NEW.Amount;
        
        UPDATE coffer
        SET amount_coffer = amount_coffer - NEW.Amount;
    END IF;
END;

DELIMITER ;


DELIMITER //
CREATE TRIGGER decrease_caisse_increase_coffer
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.Transaction_type = 'money_out' AND NEW.Destination = 'switch' THEN
        UPDATE caisse
        SET amount_caisse = amount_caisse - NEW.Amount;
        
        UPDATE coffer
        SET amount_coffer = amount_coffer + NEW.Amount;
    END IF;
END;


DELIMITER ;
