REM   Script: Laboratory Worksheet 04
REM   Laboratory Worksheet 04

ALTER TYPE stock_t  
ADD MEMBER  
FUNCTION 
computeYield 
RETURN FLOAT  
CASCADE;

CREATE OR REPLACE TYPE BODY stock_t AS  
MEMBER FUNCTION computeYield RETURN FLOAT IS 
    BEGIN 
        RETURN SELF.dividend / SELF.curr_price*100; 
    END computeYield; 
END; 
/

SELECT s.company, s.computeYield() 
FROM stocks s ;

ALTER TYPE stock_t  
ADD MEMBER  
FUNCTION 
priceInUSD(rate FLOAT) 
RETURN FLOAT  
CASCADE;

CREATE OR REPLACE TYPE BODY stock_t AS 
MEMBER FUNCTION computeYield RETURN FLOAT IS 
    BEGIN 
        RETURN SELF.dividend / SELF.curr_price*100; 
    END computeYield;  
MEMBER FUNCTION priceInUSD(rate FLOAT) RETURN FLOAT IS 
    BEGIN 
        RETURN rate*SELF.curr_price; 
    END priceInUSD; 
END; 
 
 
SELECT s.company, s.curr_price, s.priceInUSD(2) 
FROM stocks s; 
 
--(c)-- 
ALTER TYPE stock_t  
ADD MEMBER  
FUNCTION 
countExchanges 
RETURN INT  
CASCADE; 
 
CREATE OR REPLACE TYPE BODY stock_t AS 
MEMBER FUNCTION computeYield RETURN FLOAT IS 
    BEGIN 
        RETURN SELF.dividend / SELF.curr_price*100; 
    END computeYield;  
MEMBER FUNCTION priceInUSD(rate FLOAT) RETURN FLOAT IS 
    BEGIN 
        RETURN rate*SELF.curr_price; 
    END priceInUSD; 
MEMBER FUNCTION countExchanges RETURN INT IS 
    BEGIN 
        RETURN self.exchange.COUNT; 
    END countExchanges; 
END; 
 
SELECT s.company, s.countExchanges() 
FROM stocks s; 
 
--(d)-- 
ALTER TYPE client_t  
ADD MEMBER  
FUNCTION 
computePurchaseValue 
RETURN FLOAT  
CASCADE; 
 
CREATE OR REPLACE TYPE BODY client_t AS 
MEMBER FUNCTION computePurchaseValue RETURN FLOAT IS 
    total_purchase_value FLOAT := 0; 
    BEGIN 
        FOR i IN investments.FIRST..investments.LAST LOOP 
            total_purchase_value := total_purchase_value + (investments(i).purchase_price * investments(i).qty); 
        END LOOP; 
        RETURN total_purchase_value; 
    END computePurchaseValue; 
END; 
 
SELECT c.name, c.computePurchaseValue() FROM clients c; 
 
--(e)-- 
ALTER TYPE client_t  
ADD MEMBER  
FUNCTION 
computeTotalProfit 
RETURN FLOAT  
CASCADE; 
 
CREATE OR REPLACE TYPE BODY client_t AS 
MEMBER FUNCTION computePurchaseValue RETURN FLOAT IS 
    total_purchase_value FLOAT := 0; 
    BEGIN 
        FOR i IN investments.FIRST..investments.LAST LOOP 
            total_purchase_value := total_purchase_value + (investments(i).purchase_price * investments(i).qty); 
        END LOOP; 
        RETURN total_purchase_value; 
    END computePurchaseValue; 
MEMBER FUNCTION computeTotalProfit RETURN FLOAT IS 
    total_profit FLOAT := 0; 
    current_price FLOAT := 0; 
    BEGIN 
        FOR i IN investments.FIRST..investments.LAST LOOP 
            SELECT s.curr_price INTO current_price FROM stocks s WHERE investments(i).company = s.company; 
 
            total_profit := total_profit + ((current_price - investments(i).purchase_price )* investments(i).qty); 
        END LOOP; 
        RETURN total_profit; 
    END computeTotalProfit; 
END; 
 
SELECT c.name, c.computeTotalProfit() FROM clients c; 
 
 
--2-- 
--(a)-- 
SELECT s.company, e.COLUMN_VALUE AS exchange, s.computeYield() AS yield, s.priceInUSD(0.74) AS price_in_usd 
FROM stocks s, TABLE(s.exchange) e; 
 
--(b)-- 
SELECT s.company, s.curr_price, s.countExchanges() AS no_of_exchanges 
FROM stocks s, TABLE(s.exchange) e 
WHERE s.countExchanges()>1; 
 
--(c)-- 
SELECT c.name, i.company AS STOCK_NAME, s.computeYield() AS yield, s.curr_price, s.eps  
FROM clients c, TABLE(c.investments) i, stocks s 
WHERE i.company = s.company; 
 
 
--(d)-- 
SELECT c.name, c.computePurchaseValue() AS total_purchase_vlaue 
FROM clients c; 
 
 
--(e)-- 
SELECT c.name, c.computeTotalProfit() AS total_profit 
FROM clients c; 

/

