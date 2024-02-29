REM   Script: Laboratory Worksheet 02
REM   Laboratory Worksheet 02

CREATE TYPE dept_t; 
/

CREATE TYPE emp_t AS OBJECT( 
	empNo CHAR(6), 
	firstName VARCHAR(12), 
	lastName VARCHAR(15), 
	workDept REF dept_t, 
	sex CHAR(1), 
	brithDate DATE, 
	salary NUMBER(8,2)	 
) 
/

CREATE TYPE dept_t AS OBJECT( 
	deptNo CHAR(3), 
	deptName VARCHAR(36), 
	MgrNo REF emp_t, 
	AdmrDept REF dept_t 
) 
/

CREATE TABLE oremp OF emp_t( 
CONSTRAINT oremp_pk PRIMARY KEY(empNo ), 
CONSTRAINT oremp_firstName firstName NOT NULL, 
CONSTRAINT oremp_lastName lastName NOT NULL, 
CONSTRAINT oremp_sex_chk CHECK (sex='M' OR sex='F' OR sex='m' OR sex='f') 
) ;

create table ordept of dept_t( 
CONSTRAINT ordept_pk PRIMARY KEY(DEPTNO), 
CONSTRAINT ordept_deptName DEPTNAME NOT NULL, 
CONSTRAINT ordept_mgrNo_fk1 FOREIGN KEY(mgrNo) REFERENCES oremp, 
CONSTRAINT ordept_admrDept_fk2 FOREIGN KEY (admrDept) REFERENCES ordept 
) ;

INSERT INTO oremp VALUES(emp_t('000010', 'CHRISTINE', 'HASS', NULL, 'F', '14-AUG-1953', 72750)) ;

INSERT INTO oremp VALUES(emp_t('000020', 'MITCHELL', 'THOMPSON', NULL, 'M', '02-FEB-1968', 61250)) ;

INSERT INTO oremp VALUES(emp_t('000030', 'SALLY', 'KWAN', NULL, 'F', '11-MAY-1971', 58250)) ;

INSERT INTO oremp VALUES(emp_t('000060', 'IRVING', 'STERN', NULL, 'M', '07-JUL-1965', 55555)) ;

INSERT INTO oremp VALUES(emp_t('000070', 'EVA', 'PULAKSI', NULL, 'F', '26-MAY-1973', 56170)) ;

INSERT INTO oremp VALUES(emp_t('000050', 'JOHN', 'GEYER', NULL, 'M', '15-SEP-1955', 60175)) ;

INSERT INTO oremp VALUES(emp_t('000090', 'EILEEN', 'HENDERSON', NULL, 'F', '15-MAY-1961', 49750)) ;

INSERT INTO oremp VALUES(emp_t('000100', 'THEODORE', 'SPENSER', NULL, 'M', '18-AUG-1976', 46150)) ;

INSERT INTO ordept VALUES (dept_t('A00', 'SPIFFY COMPUTER SERVICE DIV', (SELECT REF(e) FROM oremp e WHERE e.empNo = '000010'), NULL)) ;

INSERT INTO ordept VALUES (dept_t('B01', 'PLANNING', (SELECT REF(e) FROM oremp e WHERE e.empNo = '000020'), NULL)) ;

INSERT INTO ordept VALUES (dept_t('C01', 'INFORMATION CENTER', (SELECT REF(e) FROM oremp e WHERE e.empNo = '000030'), NULL)) ;

INSERT INTO ordept VALUES (dept_t('D01', 'DEVELOPMENT CENTER', (SELECT REF(e) FROM oremp e WHERE e.empNo = '000060'), NULL)) ;

UPDATE oremp e 
SET e.workDept = (SELECT REF(d) FROM ordept d WHERE d.deptNo = 'A00') 
WHERE e.empNo = '000010' ;

UPDATE oremp e 
SET e.workDept = (SELECT REF(d) FROM ordept d WHERE d.deptNo = 'B01') 
WHERE e.empNo = '000020' ;

UPDATE oremp e 
SET e.workDept = (SELECT REF(d) FROM ordept d WHERE d.deptNo = 'C01') 
WHERE e.empNo = '000030' ;

UPDATE oremp e 
SET e.workDept = (SELECT REF(d) FROM ordept d WHERE d.deptNo = 'D01') 
WHERE e.empNo = '000060' ;

UPDATE oremp e 
SET e.workDept = (SELECT REF(d) FROM ordept d WHERE d.deptNo = 'D01') 
WHERE e.empNo = '000070' ;

UPDATE oremp e 
SET e.workDept = (SELECT REF(d) FROM ordept d WHERE d.deptNo = 'C01') 
WHERE e.empNo = '000050' ;

UPDATE oremp e 
SET e.workDept = (SELECT REF(d) FROM ordept d WHERE d.deptNo = 'B01') 
WHERE e.empNo = '000090' ;

UPDATE oremp e 
SET e.workDept = (SELECT REF(d) FROM ordept d WHERE d.deptNo = 'B01') 
WHERE e.empNo = '000100' ;

UPDATE ordept d 
SET d.admrDept = (SELECT REF(d) from ordept d where d.deptNo='A00') 
WHERE d.deptNo = 'A00' ;

UPDATE ordept d 
SET d.admrDept = (SELECT REF(d) FROM ordept d WHERE d.deptNo='A00') 
WHERE d.deptNo = 'B01' ;

UPDATE ordept d 
SET d.admrDept = (SELECT REF(d) FROM ordept d WHERE d.deptNo='A00') 
WHERE d.deptNo = 'C01' ;

UPDATE ordept d 
SET d.admrDept = (SELECT REF(d) FROM ordept d WHERE d.deptNo='C01') 
WHERE d.deptNo = 'D01' ;

SELECT 
    e.empNo, 
    e.firstName, 
    e.lastName, 
    (SELECT d.deptName FROM ordept d WHERE REF(d) = e.workDept) AS workDept, 
    e.sex, 
    e.brithDate, 
    e.salary 
FROM oremp e, ordept d;

SELECT d.deptName, d.mgrNo.lastName 
FROM ordept d;

SELECT e.empNo,e.lastName, e.workDept.deptName 
FROM oremp e 
JOIN ordept d ON e.workDept = d;

SELECT d.deptNo, d.deptName, d.admrDept.deptName 
FROM ordept d;

SELECT d.deptNo, d.deptName, d.admrDept.deptName, d.admrDept.mgrNo.lastName 
FROM ordept d;

SELECT e.empNo, e.firstName, e.lastname, e.salary, e.workDept.mgrNo.lastName, e.workDept.mgrNo.salary 
FROM oremp e;

SELECT e.sex, e.workdept.deptNo, e.workdept.deptName, AVG(e.salary) 
FROM oremp e 
GROUP BY e.sex, e.workdept.deptNo, e.workdept.deptName 
 
 
 
;

