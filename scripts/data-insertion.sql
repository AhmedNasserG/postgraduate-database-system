USE pg_database;

GO

-- User Insertions

INSERT INTO USERS
VALUES('qwerty');

INSERT INTO USERS
VALUES('asdfg');

INSERT INTO USERS
VALUES('zxcv');

INSERT INTO USERS
VALUES('as1234');

INSERT INTO USERS
VALUES('ag2345');

INSERT INTO USERS
VALUES('alalsdhf');

INSERT INTO USERS
VALUES('asdfg');

INSERT INTO USERS
VALUES('sdlfhjashdfohdsa');

INSERT INTO USERS
VALUES('asdfghj');

INSERT INTO USERS
VALUES('sadascca');

INSERT INTO USERS
VALUES('51sa12asdsa');

INSERT INTO USERS
VALUES('55adssadasac221');

INSERT INTO USERS
VALUES('6656asds25466as@dsad');

-- Student Insertions

INSERT INTO STUDENT
VALUES(1, 'Ahmed', 'Nasser', 'Engineering', 1.7, 'ahmed@email.com', 1,
                'Nasr city');

INSERT INTO STUDENT
VALUES(2, 'Abdulaziz', 'Alamri', 'BI', 1.0, 'abdulaziz@email.com', 1,
                'Al mokattam');

INSERT INTO STUDENT
VALUES(3, 'Omar', 'Galal', 'Pharmacy', 2.3, 'omar@email.com', 0,
                'Madinty');

INSERT INTO STUDENT
VALUES(4, 'Mohamed', 'Hassan', 'MGT', 3.0, 'mohamed@email.com', 0,
                'Al tagamoaa');

INSERT INTO STUDENT
VALUES(5, 'Michael', 'Zakhary', 'EMS', 3.2, 'michael@email.com', 1,
                'Nasr City');

INSERT INTO STUDENT
VALUES(6, 'Jasmine', 'Yasser', 'BI', 2.7, 'jasmine@email.com', 1,
                'Al tagamoaa');

INSERT INTO STUDENT
VALUES(7, 'Philo', 'Hany', 'Civil', 0.9, 'philo@email.com', 1,
                'New Cairo');

INSERT INTO STUDENT
VALUES(8, 'Youssef', 'Marwan', 'Arch', 1.8, 'youssef@gmail.com', 0, 'El Sahel');

-- Supervisor Insertions

INSERT INTO SUPERVISOR
VALUES(9, 'Mervat', 'Abouelkhair', 'MET', 'Mervat.agile@email.com', 'Alexandria');

INSERT INTO SUPERVISOR
VALUES(10, 'Milad', 'Ghantous', 'EMS', 'milad-mawakef@email.com', 'Al Mansoura');

INSERT INTO SUPERVISOR
VALUES(11, 'Shimmaa', 'Ahmed', 'BI', 'shimaa@email.com', 'Cairo');

INSERT INTO SUPERVISOR
VALUES(12, 'Haytham', 'turing', 'MET', 'haytham-automata@email.com', 'Saudi Arabia');

INSERT INTO SUPERVISOR
VALUES(13, 'Slim', 'Abdennadher', 'MET', 'slim-constraint@email.com', 'Sfax');

-- Thesis Insertions

INSERT INTO THESIS
VALUES('Feature detection on FPGA', '1/1/2021', '3/3/2021', 0, 'Hardware',
                '2/2/2021', 0, NULL, NULL, NULL);

INSERT INTO THESIS
VALUES('Feature detection on FPGA', '1/1/2021', '3/3/2021', 0, 'Hardware',
                '2/2/2021', 0, NULL, NULL, NULL);
INSERT INTO THESIS
VALUES('Feature detection on FPGA', '1/1/2021', '3/3/2021', 0, 'Hardware',
                '2/2/2021', 0, NULL, NULL, NULL);