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
VALUES(1, 'Ahmed', 'Nasser', 'MET', 'ahmed@email.com', 'Alexandria');

INSERT INTO SUPERVISOR
VALUES(2, 'Ibrahim', 'Abouelenen', 'EMS', 'ibrahim@email.com', 'Al Mansoura');

INSERT INTO SUPERVISOR
VALUES(3, 'Shimmaa', 'Ahmed', 'MGT', 'shimaa@email.com', 'Cairo');

INSERT INTO SUPERVISOR
VALUES(4, 'Abdulaziz', 'Hassan', 'CIVIL', 'abdulaziz@email.com', 'Saudi Arabia');


-- Gucian Insertions

INSERT INTO GUCIAN
        (id)
VALUES(1);

INSERT INTO GUCIAN
VALUES(2, 3);

INSERT INTO GUCIAN
VALUES(5, 12);

INSERT INTO GUCIAN
VALUES(6, 15);

-- Non Gucian Insertions

INSERT INTO NON_GUCIAN
VALUES(3);

INSERT INTO NON_GUCIAN
VALUES(4);

INSERT INTO NON_GUCIAN
VALUES(7);

INSERT INTO NON_GUCIAN
VALUES(8);

-- Courses Insertions

INSERT INTO COURSE
VALUES(1, '301', 6, 5000.32);

INSERT INTO COURSE
VALUES(2, '501', 8, 4000.32);

INSERT INTO COURSE
VALUES(3, '401', 4, 3000.32);

INSERT INTO COURSE
VALUES(4, '201', 2, 2000.32);

INSERT INTO COURSE
VALUES(5, '101', 5, 1000.32);

INSERT INTO COURSE
VALUES(6, '601', 7, 5900.2);

INSERT INTO COURSE
VALUES(7, '304', 3, 5080.23);

INSERT INTO COURSE
VALUES(8, '203', 1, 1080.3);

-- Taken_by insertions

INSERT INTO TAKEN_BY
VALUES(3, 1, 70);

INSERT INTO TAKEN_BY
VALUES(4, 2, 80);

INSERT INTO TAKEN_BY
VALUES(7, 3, 75);

INSERT INTO TAKEN_BY
VALUES(8, 6, 65);

INSERT INTO TAKEN_BY
VALUES(4, 5, 99);

-- Payment Insertions

INSERT INTO PAYMENT
VALUES(1, 0.5, 2, 5000.32, 3, 1);

INSERT INTO PAYMENT
VALUES(2, 0.2, 3, 4000.32, 4, 2);

INSERT INTO PAYMENT
VALUES(3, 0.7, 4, 1080.3, 7, 8);

INSERT INTO PAYMENT
VALUES(4, 0.8, 5, 1000.32, 8, 5);

INSERT INTO PAYMENT
VALUES(5, 0.4, 6, 5900.2, 3, 6);

-- Thesis payments

INSERT INTO PAYMENT
        (id, fund_percentage,num_of_installments, total_amount, student_id)
VALUES(6, 0.4, 2, 50000, 4);

INSERT INTO PAYMENT
        (id, fund_percentage, num_of_installments, total_amount, student_id)
VALUES(7, 0.4, 2, 40000, 7);

INSERT INTO PAYMENT
        (id, fund_percentage, num_of_installments, total_amount, student_id)
VALUES(8, 0.4, 2, 7000, 8);

-- Installment Insertions

INSERT INTO INSTALLMENT
        (payment_id, amount, installment_date)
VALUES(1, 2500.16, '2021-11-11');

INSERT INTO INSTALLMENT
        (payment_id, amount, installment_date)
VALUES(2, 1333.44, '2021-12-10');

INSERT INTO INSTALLMENT
        (payment_id, amount, installment_date)
VALUES(3, 270.075, '2021-11-11');

INSERT INTO INSTALLMENT
        (payment_id, amount, installment_date)
VALUES(4, 200.064, '2021-11-11');

INSERT INTO INSTALLMENT
        (payment_id, amount, installment_date)
VALUES(5, 983.36, '2020-11-11');

INSERT INTO INSTALLMENT
        (payment_id, amount, installment_date)
VALUES(6, 25000, '2021-10-10');

INSERT INTO INSTALLMENT
        (payment_id, amount, installment_date)
VALUES(7, 20000, '2021-10-10');

INSERT INTO INSTALLMENT
        (payment_id, amount, installment_date)
VALUES(8, 3500, '2021-10-10');

-- Thesis Insertions

INSERT INTO THESIS
VALUES('NLP for Beginners', '2021-9-9', '2021-12-12', 1,
                'Machine Learning', '2021-12-13', 0, 3, 1);

INSERT INTO THESIS
VALUES('Data Science for Beginners', '2021-8-8', '2021-12-12', 0,
                'Data Science', '2021-12-13', 0, 4, 2);

INSERT INTO THESIS
VALUES('Full stack web development for Beginners', '2021-5-5', '2021-12-12', 0,
                'Web Development', '2021-12-13', 0, 7, 3);

INSERT INTO THESIS
VALUES('Tableau for Beginners', '2021-3-3', '2021-12-12', 1,
                'Data Visualization', '2021-12-13', 0, 8, 4);

INSERT INTO THESIS
VALUES('PowerBI for beginners', '2020-3-3', '2021-11-11', 0,
                'Data Science', '2021-12-12', 0, 4, 6);

-- Evaluated_By Insertions

INSERT INTO EVALUATED_BY
VALUES(1, 1, 1, 1.5);

INSERT INTO EVALUATED_BY
VALUES(2, 2, 2, 2);

SELECT *
FROM USERS;

SELECT *
FROM STUDENT;

SELECT *
FROM GUCIAN;

SELECT *
FROM NON_GUCIAN;

SELECT *
FROM COURSE;

SELECT *
FROM TAKEN_BY;

SELECT *
FROM PAYMENT;

SELECT *
FROM INSTALLMENT;

SELECT *
FROM THESIS;

SELECT *
FROM REPORT;

SELECT *
FROM PUBLICATION;

SELECT *
FROM PUBLISHED_FOR;

SELECT *
FROM SUPERVISOR;

SELECT *
FROM EVALUATED_BY;
