REM   Script: Laboratory Worksheet 05
REM   Laboratory Worksheet 05 

CREATE TABLE stock (  
  company CHAR(7) PRIMARY KEY,  
  price DECIMAL(6,2) NOT NULL,  
  dividend DECIMAL(4,2) NOT NULL,  
  eps DECIMAL(4,2) NOT NULL  
) 
;

CREATE TABLE trading (  
   company char(7),  
   exchange VARCHAR(12),  
    PRIMARY KEY(exchange,company),  
   FOREIGN KEY (company) REFERENCES stock(company)  
      
);

CREATE TABLE purchase (  
  clno CHAR(3) NOT NULL,  
  company CHAR(7) NOT NULL,  
  pdate DATE NOT NULL,  
  qty INTEGER NOT NULL,  
  price DECIMAL(6,2) NOT NULL,  
  FOREIGN KEY (clno) REFERENCES client(clno),  
  FOREIGN KEY (company) REFERENCES stock(company)  
);

CREATE TABLE client (  
    clno char(3),  
    name varchar(12),  
    address varchar (30),  
    PRIMARY KEY(clno)  
) 
;

INSERT INTO client VALUES ('c01', 'John Smith', '3 East Av, Bentley,WA 6102') 
INSERT INTO client VALUES ('c02', 'Jil Bordy', '42 Bent St, Perth, WA 6001') 
;

INSERT INTO client VALUES ('c01', 'John Smith', '3 East Av, Bentley,WA 6102');

INSERT INTO client VALUES ('c02', 'Jil Bordy', '42 Bent St, Perth, WA 6001');

INSERT INTO stock  VALUES ('BHP', 10.50 ,1.50,3.20);

INSERT INTO stock  VALUES ('INTEL',76.50,5.00 ,12.40);

INSERT INTO stock  VALUES ('IBM',70.00,4.25,10.00);

INSERT INTO stock  VALUES ('FORD',40.00,2.00,8.50);

INSERT INTO stock  VALUES ('GM',60.00,2.50,9.20);

INSERT INTO stock  VALUES ('INFOSYS',45.00 ,3.00,7.80);

INSERT INTO trading VALUES ('BHP','New York');

INSERT INTO trading VALUES ('BHP','Sydney');

INSERT INTO trading VALUES ('IBM ','New York');

INSERT INTO trading VALUES ('IBM ','London');

INSERT INTO trading VALUES ('IBM ','Tokyo ');

INSERT INTO trading VALUES ('INTEL','New York');

INSERT INTO trading VALUES ('INTEL','London');

INSERT INTO trading VALUES ('GM','New York ');

INSERT INTO trading VALUES ('INFOSYS','New York');

INSERT INTO purchase VALUES ('c01', 'BHP', TO_DATE('2001-10-02','YYYY-MM-DD'), 1000, 12.00);

INSERT INTO purchase VALUES ('c01', 'BHP', TO_DATE('2002-06-08', 'YYYY-MM-DD'), 2000, 10.50);

INSERT INTO purchase VALUES ('c01', 'IBM', TO_DATE('2002-02-12', 'YYYY-MM-DD'), 500, 58.00);

INSERT INTO purchase VALUES ('c01', 'IBM', TO_DATE('2000-04-10', 'YYYY-MM-DD'), 1200, 65.00);

INSERT INTO purchase VALUES ('c01', 'INFOSYS', TO_DATE('2001-08-01', 'YYYY-MM-DD'), 1000, 64.00);

INSERT INTO purchase VALUES ('c02', 'INTEL', TO_DATE('2000-01-30', 'YYYY-MM-DD'), 300, 35.00);

INSERT INTO purchase VALUES ('c02', 'INTEL', TO_DATE('2001-01-30', 'YYYY-MM-DD'), 400, 54.00);

INSERT INTO purchase VALUES ('c02', 'INTEL', TO_DATE('2001-10-02', 'YYYY-MM-DD'), 200, 60.00);

INSERT INTO purchase VALUES ('c02', 'FORD', TO_DATE('1999-10-05', 'YYYY-MM-DD'), 300, 40.00  );

INSERT INTO purchase VALUES ('c02', 'GM', TO_DATE('1999-10-05', 'YYYY-MM-DD'), 500, 55.50  );

DECLARE   
 var_company_name CHAR(7) :=  'IBM';   
 var_stock NUMBER(10,2); 
BEGIN  
      SELECT s.price INTO var_stock  
      FROM stock s 
      WHERE s.company = var_company_name; 
     DBMS_OUTPUT.PUT_LINE('The stock price of ' || var_company_name || ' is ' || var_stock || ' dollars'); 
END;   
/

DECLARE   
 var_company_name CHAR(7) :=  'IBM';   
 var_stock NUMBER(10,2); 
BEGIN  
      SELECT s.price INTO var_stock  
      FROM stock s 
      WHERE s.company = var_company_name; 
     
   IF var_stock < 45 THEN   
      DBMS_OUTPUT.PUT_LINE('Current price is very low !');  
    ELSIF var_stock < 55 THEN  
      DBMS_OUTPUT.PUT_LINE('Current price is low !'); 
    ELSIF var_stock < 65 THEN 
      DBMS_OUTPUT.PUT_LINE('Current price is medium !'); 
    ELSIF var_stock < 75 THEN 
      DBMS_OUTPUT.PUT_LINE('Current price is medium high !'); 
    ELSE 
      DBMS_OUTPUT.PUT_LINE('Current price is high !'); 
   END IF; 
END;   
/

SET SERVEROUTPUT ON 


DECLARE 
    i NUMBER := 9; 
    j NUMBER; 
BEGIN 
    WHILE i >= 1 LOOP 
        j := 1; 
        WHILE j <= i LOOP 
            DBMS_OUTPUT.PUT(i || ' '); 
            j := j + 1; 
        END LOOP; 
        DBMS_OUTPUT.NEW_LINE; 
        i := i - 1; 
    END LOOP; 
END; 
/

SET SERVEROUTPUT ON 


DECLARE 
    i NUMBER; 
    j NUMBER; 
BEGIN 
    FOR i IN REVERSE 1..9 LOOP 
        FOR j IN 1..i LOOP 
            DBMS_OUTPUT.PUT(i || ' '); 
        END LOOP; 
        DBMS_OUTPUT.NEW_LINE; 
    END LOOP; 
END; 
/

SET SERVEROUTPUT ON 


DECLARE 
    i NUMBER := 9; 
    j NUMBER; 
BEGIN 
    LOOP 
        EXIT WHEN i < 1; 
        j := 1; 
        LOOP 
            EXIT WHEN j > i; 
            DBMS_OUTPUT.PUT(i || ' '); 
            j := j + 1; 
        END LOOP; 
        DBMS_OUTPUT.NEW_LINE; 
        i := i - 1; 
    END LOOP; 
END; 
/

DECLARE 
    CURSOR loyal_clients_cur IS 
        SELECT clno, company, pdate 
        FROM purchase 
        WHERE pdate < TO_DATE('01/01/2002', 'DD/MM/YYYY');  
    v_bonus_qty NUMBER; 
BEGIN 
    FOR loyal_client IN loyal_clients_cur LOOP 
        
        IF loyal_client.pdate < TO_DATE('01/01/2000', 'DD/MM/YYYY') THEN 
            v_bonus_qty := 150; 
        ELSIF loyal_client.pdate < TO_DATE('01/01/2001', 'DD/MM/YYYY') THEN 
            v_bonus_qty := 100; 
        ELSE 
            v_bonus_qty := 50; 
        END IF; 
 
         
        UPDATE purchase 
        SET qty = qty + v_bonus_qty 
        WHERE clno = loyal_client.clno 
        AND company = loyal_client.company 
        AND pdate < TO_DATE('01/01/2002', 'DD/MM/YYYY');  
 
        DBMS_OUTPUT.PUT_LINE('Updated purchase quantity for client ' || loyal_client.clno || 
                             ' and company ' || loyal_client.company || ' with bonus quantity ' || v_bonus_qty); 
    END LOOP; 
     
     
    COMMIT; 
END; 
/

DECLARE 
    v_bonus_qty NUMBER; 
     
    CURSOR loyal_clients_cur IS 
        SELECT clno, company, pdate, qty 
        FROM purchase 
        WHERE pdate < TO_DATE('01/01/2002', 'DD/MM/YYYY');  
     
    loyal_client_rec loyal_clients_cur%ROWTYPE; 
BEGIN 
    OPEN loyal_clients_cur; 
    LOOP 
        FETCH loyal_clients_cur INTO loyal_client_rec; 
        EXIT WHEN loyal_clients_cur%NOTFOUND; 
 
         
        IF loyal_client_rec.pdate < TO_DATE('01/01/2000', 'DD/MM/YYYY') THEN 
            v_bonus_qty := 150; 
        ELSIF loyal_client_rec.pdate < TO_DATE('01/01/2001', 'DD/MM/YYYY') THEN 
            v_bonus_qty := 100; 
        ELSE 
            v_bonus_qty := 50; 
        END IF; 
 
        
        UPDATE purchase 
        SET qty = qty + v_bonus_qty 
        WHERE clno = loyal_client_rec.clno 
        AND company = loyal_client_rec.company 
        AND pdate < TO_DATE('01/01/2002', 'DD/MM/YYYY');  
 
      
        DBMS_OUTPUT.PUT_LINE('Updated purchase quantity for client ' || loyal_client_rec.clno || 
                             ' and company ' || loyal_client_rec.company || ' with bonus quantity ' || v_bonus_qty); 
    END LOOP; 
 
    CLOSE loyal_clients_cur; 
    
    COMMIT; 
END; 
/

