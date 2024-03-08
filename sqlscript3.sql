CREATE TYPE exchange_trade AS VARRAY(5)  
of varchar(20); 
 
CREATE TYPE stock_t AS OBJECT( 
     comName varchar(10), 
     currentPrice NUMBER(5,2), 
     exTrade exchange_trade, 
     lastDivident NUMBER(4,2), 
     eps NUMBER(5,2) 
) 
/

CREATE TYPE address_t AS OBJECT( 
   streetNum char(10), 
   streetName varchar(20), 
   suburb char(20), 
   state char(15), 
   pin char(10) 
) 
/

CREATE TYPE investment_t AS OBJECT( 
     comName REF stock_t, 
     purchasePrice NUMBER(5,2), 
     purDate date, 
     qty NUMBER(6) 
) 
/

CREATE TYPE investment_nestedtable_t AS TABLE OF investment_t; 
      
 
CREATE TYPE client_t AS OBJECT( 
      clno char(4), 
      name varchar(20), 
      address address_t, 
      investment investment_nestedtable_t 
) 
/

CREATE TABLE stock OF stock_t( 
      CONSTRAINT stock_pk PRIMARY KEY(comName) 
) ;

CREATE TABLE client OF client_t( 
     CONSTRAINT client_pk PRIMARY KEY(name) 
)nested table investment STORE AS invested_nested_table ;

INSERT INTO stock values(stock_t('BHP',10.50,exchange_trade('Sydney','New York'),1.50,3.20)) ;

INSERT INTO stock values(stock_t('IBM',70.00,exchange_trade('New York','London','Tokyo'),4.25,10.00)) ;

INSERT INTO stock values(stock_t('INTEL',76.50,exchange_trade('New York','London'),5.00,12.40)) ;

INSERT INTO stock values(stock_t('FORD',40.00,exchange_trade('New York'),2.00,8.50)) ;

INSERT INTO stock values(stock_t('GM',60.00,exchange_trade('New York'),2.50,9.20)) ;

INSERT INTO stock values(stock_t('INFOSYS',45.00,exchange_trade('New York'),3.00,7.80)) ;

INSERT INTO client values(client_t('c1','John Smith',address_t('3','East Av','Bentley','WA','6102'),investment_nestedtable_t(investment_t((SELECT REF(s) FROM stock s WHERE s.comName='BHP'),12.00,TO_DATE('02/10/01', 'DD/MM/YY'),1000), 
investment_t((SELECT REF(s) FROM stock s WHERE s.comName='BHP'),10.50,TO_DATE('08/06/02', 'DD/MM/YY'),2000),investment_t((SELECT REF(s) FROM stock s WHERE s.comName='IBM'),58.00,TO_DATE('12/02/00 ', 'DD/MM/YY'),500), 
investment_t((SELECT REF(s) FROM stock s WHERE s.comName='IBM'),65.00,TO_DATE('10/04/01 ', 'DD/MM/YY'),1200), 
investment_t((SELECT REF(s) FROM stock s WHERE s.comName='INFOSYS'),64.00,TO_DATE('11/08/01', 'DD/MM/YY'),1000)))) ;

INSERT INTO client values(client_t('c2','Jill Brody',address_t('42','Bent St','Perth','WA','6001'),investment_nestedtable_t(investment_t((SELECT REF(s) FROM stock s WHERE s.comName='INTEL'),35.00,TO_DATE('30/01/00', 'DD/MM/YY'),300), 
investment_t((SELECT REF(s) FROM stock s WHERE s.comName='INTEL'),54.00, TO_DATE('30/01/01', 'DD/MM/YY'),400),investment_t((SELECT REF(s) FROM stock s WHERE s.comName='INTEL'),60.00,TO_DATE('02/10/01', 'DD/MM/YY'),200), 
investment_t((SELECT REF(s) FROM stock s WHERE s.comName='FORD'),40.00,TO_DATE('05/10/99', 'DD/MM/YY'),300), 
investment_t((SELECT REF(s) FROM stock s WHERE s.comName='GM'),55.50,TO_DATE('12/12/00', 'DD/MM/YY'),500)))) ;

(a)SELECT c.name, 
   i.comName.comName AS COMPANY, 
   i.comName.currentPrice AS CURRENT_PRICE, 
   i.comName.lastDivident AS LAST_DIVIDENT, 
   i.comName.eps AS EARNING_PER_SHARE 
   FROM client c ,  
     TABLE(c.investment)i ;

(b)SELECT c.name,i.comName.comName ,SUM(i.qty) AS total_Shares,SUM(i.purchasePrice * i.qty) / SUM(i.qty) AS avg_Purchase_Price 
   FROM client c, 
     TABLE(c.investment) i 
   GROUP BY c.name, i.comName.comName ;

(c)SELECT c.name, 
    i.comName.comName AS company, 
    SUM(i.qty * i.purchasePrice) AS current_value, 
    SUM(i.qty) AS number_of_shares 
   FROM client c, TABLE(c.investment) i, TABLE(i.comName.exTrade) e 
   WHERE e.column_value = 'New York' 
   GROUP BY c.name, i.comName.comName ;

(d)SELECT c.name AS client_name,SUM(i.qty * i.purchasePrice) AS total_purchase_value 
   FROM client c, 
     TABLE(c.investment) i 
   GROUP BY c.name ;

(e)SELECT c.name,  
    SUM(i.qty * i.comName.currentPrice) - SUM(i.qty * i.purchasePrice) profit 
   FROM client c, TABLE(c.investment) i 
   GROUP BY c.name ;

(4) 
DELETE FROM TABLE ( 
SELECT c.investment 
FROM client c 
WHERE c.clno = 'c1' 
) i 
WHERE i.purchasePrice = 64 ;

DELETE FROM TABLE ( 
SELECT c.investment 
FROM client c 
WHERE c.clno = 'c2' 
) i 
WHERE i.purchasePrice = 55.50 ;

INSERT INTO TABLE ( 
SELECT c.investment 
FROM client c 
WHERE c.clno = 'c1' 
) VALUES ((SELECT REF(s) FROM stock s WHERE s.comName = 'GM'), 60.00,TO_DATE('10/09/24','DD/MM/YY'), 500) ;

INSERT INTO TABLE ( 
SELECT c.investment 
FROM client c 
WHERE c.clno = 'c2' 
) VALUES ((SELECT REF(s) FROM stock s WHERE s.comName = 'GM'), 45.00,TO_DATE('10/09/24','DD/MM/YY'), 1000) ;

CREATE TYPE exchange_trade AS VARRAY(5)  
of varchar(20); 
 
CREATE TYPE stock_t AS OBJECT( 
     comName varchar(10), 
     currentPrice NUMBER(5,2), 
     exTrade exchange_trade, 
     lastDivident NUMBER(4,2), 
     eps NUMBER(5,2) 
) 
/

CREATE TYPE exchange_trade AS VARRAY(5)  
of varchar(20);
/

CREATE TYPE stock_t AS OBJECT( 
     comName varchar(10), 
     currentPrice NUMBER(5,2), 
     exTrade exchange_trade, 
     lastDivident NUMBER(4,2), 
     eps NUMBER(5,2) 
) 
/

CREATE TYPE address_t AS OBJECT( 
   streetNum char(10), 
   streetName varchar(20), 
   suburb char(20), 
   state char(15), 
   pin char(10) 
) 
/

CREATE TYPE investment_t AS OBJECT( 
     comName REF stock_t, 
     purchasePrice NUMBER(5,2), 
     purDate date, 
     qty NUMBER(6) 
) 
/

CREATE TYPE exchange_trade AS VARRAY(5)  
of varchar(20); 
 
CREATE TYPE stock_t AS OBJECT( 
     comName varchar(10), 
     currentPrice NUMBER(5,2), 
     exTrade exchange_trade, 
     lastDivident NUMBER(4,2), 
     eps NUMBER(5,2) 
) 
/

CREATE TYPE address_t AS OBJECT( 
   streetNum char(10), 
   streetName varchar(20), 
   suburb char(20), 
   state char(15), 
   pin char(10) 
) 
/

CREATE TYPE investment_t AS OBJECT( 
     comName REF stock_t, 
     purchasePrice NUMBER(5,2), 
     purDate date, 
     qty NUMBER(6) 
) 
/

CREATE TYPE investment_nestedtable_t AS TABLE OF investment_t; 
      
 
CREATE TYPE client_t AS OBJECT( 
      clno char(4), 
      name varchar(20), 
      address address_t, 
      investment investment_nestedtable_t 
) 
/

CREATE TABLE stock OF stock_t( 
      CONSTRAINT stock_pk PRIMARY KEY(comName) 
) ;

CREATE TABLE client OF client_t( 
     CONSTRAINT client_pk PRIMARY KEY(name) 
)nested table investment STORE AS invested_nested_table ;

INSERT INTO stock values(stock_t('BHP',10.50,exchange_trade('Sydney','New York'),1.50,3.20)) ;

INSERT INTO stock values(stock_t('IBM',70.00,exchange_trade('New York','London','Tokyo'),4.25,10.00)) ;

INSERT INTO stock values(stock_t('INTEL',76.50,exchange_trade('New York','London'),5.00,12.40)) ;

INSERT INTO stock values(stock_t('FORD',40.00,exchange_trade('New York'),2.00,8.50)) ;

INSERT INTO stock values(stock_t('GM',60.00,exchange_trade('New York'),2.50,9.20)) ;

INSERT INTO stock values(stock_t('INFOSYS',45.00,exchange_trade('New York'),3.00,7.80)) ;

INSERT INTO client values(client_t('c1','John Smith',address_t('3','East Av','Bentley','WA','6102'),investment_nestedtable_t(investment_t((SELECT REF(s) FROM stock s WHERE s.comName='BHP'),12.00,TO_DATE('02/10/01', 'DD/MM/YY'),1000), 
investment_t((SELECT REF(s) FROM stock s WHERE s.comName='BHP'),10.50,TO_DATE('08/06/02', 'DD/MM/YY'),2000),investment_t((SELECT REF(s) FROM stock s WHERE s.comName='IBM'),58.00,TO_DATE('12/02/00 ', 'DD/MM/YY'),500), 
investment_t((SELECT REF(s) FROM stock s WHERE s.comName='IBM'),65.00,TO_DATE('10/04/01 ', 'DD/MM/YY'),1200), 
investment_t((SELECT REF(s) FROM stock s WHERE s.comName='INFOSYS'),64.00,TO_DATE('11/08/01', 'DD/MM/YY'),1000)))) ;

INSERT INTO client values(client_t('c2','Jill Brody',address_t('42','Bent St','Perth','WA','6001'),investment_nestedtable_t(investment_t((SELECT REF(s) FROM stock s WHERE s.comName='INTEL'),35.00,TO_DATE('30/01/00', 'DD/MM/YY'),300), 
investment_t((SELECT REF(s) FROM stock s WHERE s.comName='INTEL'),54.00, TO_DATE('30/01/01', 'DD/MM/YY'),400),investment_t((SELECT REF(s) FROM stock s WHERE s.comName='INTEL'),60.00,TO_DATE('02/10/01', 'DD/MM/YY'),200), 
investment_t((SELECT REF(s) FROM stock s WHERE s.comName='FORD'),40.00,TO_DATE('05/10/99', 'DD/MM/YY'),300), 
investment_t((SELECT REF(s) FROM stock s WHERE s.comName='GM'),55.50,TO_DATE('12/12/00', 'DD/MM/YY'),500)))) ;

(a)SELECT c.name, 
   i.comName.comName AS COMPANY, 
   i.comName.currentPrice AS CURRENT_PRICE, 
   i.comName.lastDivident AS LAST_DIVIDENT, 
   i.comName.eps AS EARNING_PER_SHARE 
   FROM client c ,  
     TABLE(c.investment)i ;

(b)SELECT c.name,i.comName.comName ,SUM(i.qty) AS total_Shares,SUM(i.purchasePrice * i.qty) / SUM(i.qty) AS avg_Purchase_Price 
   FROM client c, 
     TABLE(c.investment) i 
   GROUP BY c.name, i.comName.comName ;

(c)SELECT c.name, 
    i.comName.comName AS company, 
    SUM(i.qty * i.purchasePrice) AS current_value, 
    SUM(i.qty) AS number_of_shares 
   FROM client c, TABLE(c.investment) i, TABLE(i.comName.exTrade) e 
   WHERE e.column_value = 'New York' 
   GROUP BY c.name, i.comName.comName ;

(d)SELECT c.name AS client_name,SUM(i.qty * i.purchasePrice) AS total_purchase_value 
   FROM client c, 
     TABLE(c.investment) i 
   GROUP BY c.name ;

(e)SELECT c.name,  
    SUM(i.qty * i.comName.currentPrice) - SUM(i.qty * i.purchasePrice) profit 
   FROM client c, TABLE(c.investment) i 
   GROUP BY c.name ;

(4) 
DELETE FROM TABLE ( 
SELECT c.investment 
FROM client c 
WHERE c.clno = 'c1' 
) i 
WHERE i.purchasePrice = 64 ;

DELETE FROM TABLE ( 
SELECT c.investment 
FROM client c 
WHERE c.clno = 'c2' 
) i 
WHERE i.purchasePrice = 55.50 ;

INSERT INTO TABLE ( 
SELECT c.investment 
FROM client c 
WHERE c.clno = 'c1' 
) VALUES ((SELECT REF(s) FROM stock s WHERE s.comName = 'GM'), 60.00,TO_DATE('10/09/24','DD/MM/YY'), 500) ;

INSERT INTO TABLE ( 
SELECT c.investment 
FROM client c 
WHERE c.clno = 'c2' 
) VALUES ((SELECT REF(s) FROM stock s WHERE s.comName = 'GM'), 45.00,TO_DATE('10/09/24','DD/MM/YY'), 1000) ;

