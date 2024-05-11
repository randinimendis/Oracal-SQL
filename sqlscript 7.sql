
CREATE TYPE Course_t AS OBJECT (
    cid CHAR(10),
    cname VARCHAR2(50),
    credits NUMBER(3)
);
/


CREATE TYPE Grade_t AS OBJECT (
    course REF Course_t,
    grade CHAR(2),
    semester NUMBER(2),
    year NUMBER(4)
);
/


CREATE TYPE Grades_nt AS TABLE OF Grade_t;
/


CREATE TYPE Student_t AS OBJECT (
    sid CHAR(10),
    sname VARCHAR2(50),
    gpa NUMBER(5, 2),
    grades Grades_nt
);
/


CREATE TABLE Courses OF Course_t (
    cid PRIMARY KEY
);



CREATE TABLE Students OF Student_t (
    sid PRIMARY KEY
) NESTED TABLE grades STORE AS StudentGrades;





INSERT INTO Students VALUES (
    'S001',
    'Sampath Wijesinghe',
    3.4,
    Grades_nt(
        Grade_t(
            (SELECT REF(c) FROM Courses c WHERE c.cid = 'DBMS II'),
            NULL,
            2,
            2006
        ),
        Grade_t(
            (SELECT REF(c) FROM Courses c WHERE c.cid = 'SE I'),
            'B+',
            1,
            2005
        )
    )
);



UPDATE Students s
SET s.grades = Grades_nt(
    Grade_t(
        (SELECT REF(c) FROM Courses c WHERE c.cid = 'DBMS II'),
        'A', -- Updated grade
        2,
        2006
    )
)
WHERE s.sid = 'S001';




SELECT s.sname
FROM Students s
WHERE (
    SELECT g.grade
    FROM TABLE(s.grades) g
    WHERE g.course.cid = 'DBMS II'
) = 'A';



CREATE TYPE Elective_t UNDER Course_t (
    consideredForGPA BOOLEAN
);



ALTER TYPE Student_t ADD MEMBER FUNCTION NumAGrades RETURN NUMBER CASCADE;
/




CREATE OR REPLACE TYPE BODY Student_t AS
MEMBER FUNCTION NumAGrades RETURN NUMBER IS
        numAgrades NUMBER := 0;
    BEGIN
        FOR i IN 1..self.grades.COUNT LOOP
            IF self.grades(i).grade = 'A' THEN
                numAgrades := numAgrades + 1;
            END IF;
        END LOOP;
        RETURN numAgrades;
    END NumAGrades;
END;
/



SELECT s.sname AS "Student Name", s.NumAGrades AS "Number of A Grades"
FROM Students s;




SELECT s.sname AS "Student Name",
       s.gpa AS "GPA"
FROM Students s
WHERE EXISTS (
    SELECT 1
    FROM TABLE(s.grades) g
    WHERE DEREF(g.course).IS OF (Elective_t)
);











DROP TYPE BODY Student_t;
DROP TYPE Elective_t;
DROP TABLE Students;
DROP TYPE TABLE Courses;
DROP TYPE Student_t;
DROP TYPE Grades_nt;
DROP TYPE Grade_t;
DROP TYPE Course_t;