REM   Script: Laboratory Worksheet 01
REM   Laboratory Worksheet 02

CREATE TABLE client (    
    clno CHAR(3) PRIMARY KEY,    
    name VARCHAR(12),    
    address VARCHAR(30)    
) ;

INSERT INTO client VALUES ('c01', 'John Smith', '3 East Av, Bentley, WA 6102') ;

INSERT INTO client VALUES ('c02', 'Jill Brody', '42 Bent St, Perth, WA 6001') ;

CREATE TABLE stock (    
    company CHAR(7) PRIMARY KEY,    
    current_price NUMBER(6,2),    
    last_dividend NUMBER(4,2),    
    eps NUMBER(4,2)    
) ;

INSERT INTO stock VALUES ('BHP', 10.50, 1.50, 3.20) ;

INSERT INTO stock VALUES ('IBM', 70.00, 4.25, 10.00) ;

INSERT INTO stock VALUES ('INTEL', 76.50, 5.00, 12.40) ;

INSERT INTO stock VALUES ('FORD', 40.00, 2.00, 8.50) ;

INSERT INTO stock VALUES ('GM', 60.00, 2.50, 9.20) ;

INSERT INTO stock VALUES ('INFOSYS', 45.00, 3.00, 7.80) ;

CREATE TABLE trading (    
    company CHAR(7),    
    exchange VARCHAR(12),    
    PRIMARY KEY (company, exchange),    
    FOREIGN KEY (company) REFERENCES stock(company)    
) ;

INSERT INTO trading VALUES ('BHP', 'Sydney') ;

INSERT INTO trading VALUES ('BHP', 'New York') ;

INSERT INTO trading VALUES ('IBM', 'New York') ;

INSERT INTO trading VALUES ('IBM', 'London') ;

INSERT INTO trading VALUES ('IBM', 'Tokyo') ;

INSERT INTO trading VALUES ('INTEL', 'New York') ;

INSERT INTO trading VALUES ('INTEL', 'London') ;

INSERT INTO trading VALUES ('FORD', 'New York') ;

INSERT INTO trading VALUES ('GM', 'New York') ;

INSERT INTO trading VALUES ('INFOSYS', 'New York') ;

CREATE TABLE purchase (    
    clno CHAR(3),    
    company CHAR(7),    
    pdate DATE,    
    qty NUMBER(6),    
    price NUMBER(6,2),    
    PRIMARY KEY (clno, company, pdate),    
    FOREIGN KEY (clno) REFERENCES client(clno),    
    FOREIGN KEY (company) REFERENCES stock(company)    
) ;

INSERT INTO purchase VALUES ('c01', 'BHP', TO_DATE('02/10/01', 'DD/MM/YY'), 1000, 12.00) ;

INSERT INTO purchase VALUES ('c01', 'BHP', TO_DATE('08/06/02', 'DD/MM/YY'), 2000, 10.50) ;

INSERT INTO purchase VALUES ('c01', 'IBM', TO_DATE('12/02/00', 'DD/MM/YY'), 500, 58.00) ;

INSERT INTO purchase VALUES ('c01', 'IBM', TO_DATE('10/04/01', 'DD/MM/YY'), 1200, 65.00) ;

INSERT INTO purchase VALUES ('c01', 'INFOSYS', TO_DATE('11/08/01', 'DD/MM/YY'), 1000, 64.00) ;

INSERT INTO purchase VALUES ('c02', 'INTEL', TO_DATE('30/01/00', 'DD/MM/YY'), 300, 35.00) ;

INSERT INTO purchase VALUES ('c02', 'INTEL', TO_DATE('30/01/01', 'DD/MM/YY'), 400, 54.00) ;

INSERT INTO purchase VALUES ('c02', 'INTEL', TO_DATE('02/10/01', 'DD/MM/YY'), 200, 60.00) ;

INSERT INTO purchase VALUES ('c02', 'FORD', TO_DATE('05/10/99', 'DD/MM/YY'), 300, 40.00) ;

INSERT INTO purchase VALUES ('c02', 'GM', TO_DATE('12/12/00', 'DD/MM/YY'), 500, 55.50) ;

select *     
from client  ;

select *      
from trading  ;

select *      
from stock  ;

SELECT c.name AS client_name, p.company, s.current_price, s.last_dividend, s.eps     
FROM client c     
JOIN purchase p ON c.clno = p.clno     
JOIN stock s ON p.company = s.company ;

SELECT c.name AS client_name, p.company, SUM(p.qty) AS total_shares_held,    
    AVG(p.price) AS average_purchase_price    
FROM client c    
JOIN purchase p ON c.clno = p.clno    
GROUP BY c.name, p.company ;

SELECT s.company, c.name AS client_name, p.qty, (p.qty * s.current_price) AS current_value    
FROM stock s    
JOIN trading t ON s.company = t.company    
JOIN purchase p ON s.company = p.company AND t.exchange = 'New York'    
JOIN client c ON p.clno = c.clno ;

SELECT c.name AS client_name, SUM(p.qty * p.price) AS total_purchase_value    
FROM client c    
JOIN purchase p ON c.clno = p.clno    
GROUP BY c.name ;

SELECT c.name AS client_name,    
    SUM(p.qty * s.current_price) - SUM(p.qty * p.price) AS book_profit_or_loss    
FROM client c    
JOIN purchase p ON c.clno = p.clno    
JOIN stock s ON p.company = s.company    
GROUP BY c.name ;

