DROP TABLE IF EXISTS registration;
DROP TABLE IF EXISTS course;
DROP TABLE IF EXISTS student;

CREATE TABLE Student (
       id INTEGER PRIMARY KEY,
       firstName TEXT,
       LastName  TEXT
       );


CREATE TABLE Course (
       id INTEGER PRIMARY KEY,
       name TEXT,
       code TEXT,
       maxStudent INTEGER
       );


CREATE TABLE Registration (
       id INTEGER PRIMARY KEY,
       student_id INTEGER,
       course_id INTEGER
       );

INSERT INTO Student (firstName, LastName) VALUES ('Habib', 'Habbib');
INSERT INTO Student (firstName, LastName) VALUES ('Rosnel' , 'Rosnel');
INSERT INTO Student (firstName, LastName) VALUES ('Irfan', 'Irfan');
INSERT INTO Student (firstName, LastName) VALUES ('Donie', 'Donie');
INSERT INTO Student (firstName, LastName) VALUES ('Phi', 'Phi');
INSERT INTO Student (firstName, LastName) VALUES ('Joseph', 'Joseph');

INSERT INTO Course (name,code, maxStudent) VALUES ('HASKELL','HASK101' , 25);
INSERT INTO Course (name,code, maxStudent) VALUES ('PLUTUS' , 'PLUT201', 20);
INSERT INTO Course (name,code, maxStudent) VALUES ('MARLO' , 'MARL400',  10);
INSERT INTO Course (name,code, maxStudent) VALUES ('JAVA' , 'JAVA400',   100);

INSERT INTO Registration (student_id, course_id) VALUES (1,1);
INSERT INTO Registration (student_id, course_id) VALUES (2,1);
INSERT INTO Registration (student_id, course_id) VALUES (3,1);
INSERT INTO Registration (student_id, course_id) VALUES (4,1);
INSERT INTO Registration (student_id, course_id) VALUES (4,2);
INSERT INTO Registration (student_id, course_id) VALUES (4,3);

