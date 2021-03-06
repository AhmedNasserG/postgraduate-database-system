USE pg_database;

GO
-- Users' Insertions

INSERT INTO USERS
VALUES('qwerty', 'ahmed@email.com');

INSERT INTO STUDENT
VALUES(1, 'Ahmed', 'Nasser', 'Engineering', 1.7,
                'Masters', 'Nasr city');

INSERT INTO NON_GUCIAN
VALUES(1);

INSERT INTO USERS
VALUES('student', 'GUCStudent@test.com');

INSERT INTO STUDENT
VALUES(2, 'Abdulaziz', 'Alamri', 'BI', 1.0, 'Masters',
                'Al mokattam');

INSERT INTO GUCIAN
        (id)
VALUES(2);

INSERT INTO USERS
VALUES('zxcv', 'omar@email.com');

INSERT INTO STUDENT
VALUES(3, 'Omar', 'Galal', 'Pharmacy', 2.3, 'Phd',
                'Madinty');

INSERT INTO NON_GUCIAN
VALUES(3);

INSERT INTO USERS
VALUES('as1234', 'mohamed@email.com');

INSERT INTO STUDENT
VALUES(4, 'Mohamed', 'Hassan', 'MGT', 3.0, 'Phd',
                'Al tagamoaa');

INSERT INTO NON_GUCIAN
VALUES(4);

INSERT INTO USERS
VALUES('ag2345', 'michael@email.com');

INSERT INTO STUDENT
VALUES(5, 'Michael', 'Zakhary', 'EMS', 3.2, 'Masters',
                'Nasr City');

INSERT INTO GUCIAN
        (id)
VALUES(5);

INSERT INTO USERS
VALUES('alalsdhf', 'jasmine@email.com');

INSERT INTO STUDENT
VALUES(6, 'Jasmine', 'Yasser', 'BI', 2.7, 'Phd',
                'Al tagamoaa');

INSERT INTO GUCIAN
        (id)
VALUES(6);

INSERT INTO USERS
VALUES('student', 'NONGUCStudent@test.com');

INSERT INTO STUDENT
VALUES(7, 'Philo', 'Hany', 'Civil', 0.9, 'Phd',
                'New Cairo');

INSERT INTO NON_GUCIAN
VALUES(7);

INSERT INTO USERS
VALUES('sdlfhjashdfohdsa', 'youssef@gmail.com');

INSERT INTO STUDENT
VALUES(8, 'Youssef', 'Marwan', 'Arch', 1.8, 'Masters',
                'El Sahel');

INSERT INTO GUCIAN
        (id)
VALUES(8);

INSERT INTO USERS
VALUES('asdfghj', 'prof.Mervat@email.com');

INSERT INTO SUPERVISOR
VALUES(9, 'Mervat', 'Abouelkhair', 'MET',
                'Alexandria');

INSERT INTO USERS
VALUES('sadascca', 'milad@email.com');

INSERT INTO SUPERVISOR
VALUES(10, 'Milad', 'Ghantous', 'EMS',
                'Al Mansoura');

INSERT INTO USERS
VALUES('51sa12asdsa', 'shimaa@email.com');

INSERT INTO SUPERVISOR
VALUES(11, 'Shimmaa', 'Ahmed', 'BI', 'Cairo');

INSERT INTO USERS
VALUES('55adssadasac221', 'haytham-automata@email.com');

INSERT INTO SUPERVISOR
VALUES(12, 'Haytham', 'turing', 'MET',
                'Saudi Arabia');

INSERT INTO USERS
VALUES('supervisor', 'supervisor@test.com');

INSERT INTO SUPERVISOR
VALUES(13, 'Slim', 'Abdennadher', 'MET',
                'Sfax');

INSERT INTO USERS
VALUES('examiner', 'examiner@test.com');

INSERT INTO EXAMINER
VALUES(14, 'Ibrahim Abou Elenein', 0, 'String theory');

INSERT INTO USERS
VALUES('asdhfawhrfihraw', 'omneya.Rabie@guc');

INSERT INTO EXAMINER
VALUES(15, 'Omneya Rabie', 1, 'Database Design');


-- Course Insertions

INSERT INTO COURSE
VALUES
        ('CSEN301', 6, 6000.00);

INSERT INTO COURSE
VALUES
        ('CSEN501', 6, 6000.00);

INSERT INTO COURSE
VALUES
        ('CSEN605', 4, 4000.00);

INSERT INTO COURSE
VALUES
        ('CSEN701', 4, 4000.00);

INSERT INTO COURSE
VALUES
        ('CSEN901', 6, 6000.00);



-- Taken by Insertions

INSERT INTO TAKEN_BY
VALUES
        (1, 1, 100.00);

INSERT INTO TAKEN_BY
VALUES
        (3, 1, 95.00);

INSERT INTO TAKEN_BY
VALUES
        (4, 4, 49.00);

INSERT INTO TAKEN_BY
VALUES
        (7, 4, 90.00);

INSERT INTO TAKEN_BY
VALUES
        (1, 2, 75.00);

INSERT INTO TAKEN_BY
VALUES
        (7, 5, 55.00);



-- Payment Insertion
INSERT INTO PAYMENT
VALUES(0.1, 1, 500, 1, null)

INSERT INTO PAYMENT
VALUES(0.2, 2, 1000, 2, null)

INSERT INTO PAYMENT
VALUES(0.3, 2, 1900, 3, null)

INSERT INTO PAYMENT
VALUES(0.4, 1, 1700, 4, null)

INSERT INTO PAYMENT
VALUES(0.3, 3, 15000, 7, NULL);
-- Courses Payment Insertion

INSERT INTO PAYMENT
VALUES(0.1, 1, 500, 1, 1)

INSERT INTO PAYMENT
VALUES(0.1, 1, 500, 1, 2)

INSERT INTO PAYMENT
VALUES(0.1, 1, 500, 3, 1)

INSERT INTO PAYMENT
VALUES(0.1, 1, 500, 4, 4)

INSERT INTO PAYMENT
VALUES(0.1, 1, 500, 7, 4)

INSERT INTO PAYMENT
VALUES(0.1, 1, 500, 7, 5)


INSERT INTO INSTALLMENT
VALUES
        (1, '2/2/2021', 500, 1)

INSERT INTO INSTALLMENT
VALUES
        (2, '2/2/2021', 500, 1)

INSERT INTO INSTALLMENT
VALUES
        (2, '8/2/2021', 500, 0)

INSERT INTO INSTALLMENT
VALUES
        (3, '11/11/2021', 850, 1)

INSERT INTO INSTALLMENT
VALUES
        (3, '3/5/2022', 850, 0)

INSERT INTO INSTALLMENT
VALUES
        (4, '4/5/2021', 1700, 1)

INSERT INTO INSTALLMENT
VALUES
        (5, '6/4/2021', 500, 1)

INSERT INTO INSTALLMENT
VALUES
        (6, '5/4/2021', 500, 1)

-- Thesis Insertions

INSERT INTO THESIS
VALUES('Feature detection on FPGA', '1/1/2021', '3/3/2027', 0, NULL,
                'Hardware', '2/2/2021', 0, 1, 1);

INSERT INTO THESIS
VALUES('Human Activity Recognition', '1/1/2020', '5/6/2021', 1, NULL,
                'Machine Learning', '2/2/2021', 0, 2, 2);

INSERT INTO THESIS
VALUES('Arabic Text Summarization', '10/10/2020', '3/3/2021', 0, NULL,
                'Natural Language Processing', '2/2/2021', 0, 3, 3);

INSERT INTO THESIS
VALUES('Analysis of Algorithms', '12/12/2020', '4/4/2021', 1, NULL,
                'Computer Science', '3/4/2021', 0, 4, 4);

INSERT INTO THESIS
VALUES('Quantum Computing', '9/9/2020', '5/5/2021', 0, NULL,
                'Quantum COMPUTER Science', '3/3/2021', 0, 4, NULL);

INSERT INTO THESIS
VALUES('Cloud Computing', '10/10/2021', '1/1/2022', 1, NULL,
                'DevOps', '12/12/2021', 0, 5, NULL);

INSERT INTO THESIS
VALUES('Internet of things', '8/8/2021', '3/3/2022', 0, NULL,
                'Computer Science', '11/11/2021', 0, 6, NULL);

INSERT INTO THESIS
VALUES('Embedded Systems', '1/1/2021', '6/6/2022', 1, NULL,
                'Hardware', '3/3/2022', 0, 7, NULL);

INSERT INTO THESIS
VALUES('Differential Gemoetry', '10/10/2021', '4/4/2026', 0, NULL,
                'Mathematics', '2/2/2021', 0, 8, NULL);

INSERT INTO THESIS
VALUES('Abstract Algebra', '10/10/2020', '3/3/2021', 1, NULL,
                'Mathematics', '2/2/2021', 0, 7, NULL);

INSERT INTO THESIS
VALUES('Non-Linear Algebra', '10/10/2020', '3/3/2021', 0, NULL,
                'Mathematics', '2/2/2021', 0, 7, NULL);

INSERT INTO THESIS
VALUES('Deep Learning', '1/1/2022', '5/6/2022', 0, NULL,
                'Machine Learning', '2/2/2022', 0, 6, NULL);

INSERT INTO THESIS
VALUES('Data Mining', '11/11/2021', '3/5/2022', 0, NULL,
                'Data Science', '2/2/2021', 0, 5, NULL);

INSERT INTO THESIS
VALUES('Virtual Reality', '12/12/2021', '3/3/2022', 0, NULL,
                'Computer Science', '2/2/2022', 0, 4, NULL);

INSERT INTO THESIS
VALUES('Water Recognition on Mars', '11/11/2021', '3/3/2022', 0, NULL,
                'Data Science', '2/2/2022', 0, 3, NULL);

-- SUPERVISED BY INSERTION
INSERT INTO SUPERVISED
VALUES
        (9 , 1 )

INSERT INTO SUPERVISED
VALUES
        (13 , 1 )

INSERT INTO SUPERVISED
VALUES
        (10 , 2 )

INSERT INTO SUPERVISED
VALUES
        (11 , 3)

INSERT INTO SUPERVISED
VALUES
        (12 , 4 )

INSERT INTO SUPERVISED
VALUES
        (13 , 5)

INSERT INTO SUPERVISED
VALUES
        (13 , 6)

INSERT INTO SUPERVISED
VALUES
        (10 , 7)

INSERT INTO SUPERVISED
VALUES
        (9 , 8)


INSERT INTO SUPERVISED
VALUES
        (13 , 9)


INSERT INTO SUPERVISED
VALUES
        (12 , 10)


INSERT INTO SUPERVISED
VALUES
        (13 , 11)


INSERT INTO SUPERVISED
VALUES
        (11 , 12)


INSERT INTO SUPERVISED
VALUES
        (10 , 13)


INSERT INTO SUPERVISED
VALUES
        (9 , 14)


INSERT INTO SUPERVISED
VALUES
        (9 , 15)


-- Progress Reports' insertions

INSERT INTO REPORT
VALUES(1, 1, '2/3/2021', 'done with first half of thesis');

INSERT INTO REPORT
VALUES(2, 2, '4/4/2021', 'finished the research part');

INSERT INTO REPORT
VALUES(3, 3, '1/1/2021', 'It comes to an end possibly');

INSERT INTO REPORT
VALUES(4, 3, '3/3/2021', 'done with the implementaion');

INSERT INTO REPORT
VALUES(5, 3, '2/2/2021', 'just missing final points');

INSERT INTO REPORT
VALUES(1, 1, '3/3/2021', 'done with second half of thesis');

INSERT INTO EVALUATED_BY
VALUES(9, 1, 1, 1);

INSERT INTO EVALUATED_BY
VALUES(10, 2, 2, 2);

INSERT INTO EVALUATED_BY
VALUES(11, 3, 3, 3);

INSERT INTO EVALUATED_BY
VALUES(12, 4, 4, 2);


INSERT INTO EVALUATED_BY
VALUES(13, 5, 5, 1);

INSERT INTO EVALUATED_BY
VALUES(13, 1, 6, 0)

-- defenses insertion

INSERT INTO DEFENSE
VALUES
        (1, '2/2/2021', 'GUC', Null)

INSERT INTO DEFENSE
VALUES
        (2, '3/3/2021', 'Cairo Uni', NULL)

INSERT INTO DEFENSE
Values
        (4, '3/4/2021', 'H13', NULL)

INSERT INTO DEFENSE
VALUES
        (3, '2/2/2021', 'GUC', Null)

GO

INSERT INTO EXAMINED_BY
VALUES
        (14, 1, '2/2/2021', 'very good presentation')

INSERT INTO EXAMINED_BY
VALUES
        (15, 2, '3/3/2021', 'poor presentation and writing skills')

INSERT INTO EXAMINED_BY
Values
        (14, 2, '3/3/2021', 'Eh Elgamadan dh')

INSERT INTO EXAMINED_BY
Values
        (14, 4, '3/4/2021', '3azamaaaa')

INSERT INTO EXAMINED_BY
VALUES
        (14, 3, '2/2/2021', 'amazing work')

-- publication Insertion
INSERT INTO PUBLICATION
VALUES
        ('Further Research for Computer Architecture', '2/2/2021', 'Cairo', 'IEEE Conference', 1)

INSERT INTO PUBLICATION
VALUES
        ('New NLP Technique for voice recognition', '2/2/2021', 'Cairo', 'ML Conference', 1)


INSERT INTO PUBLICATION
VALUES
        ('Big O Notation', '2/2/2021', 'Cairo', 'CS Conference', 0)

INSERT INTO PUBLISHED_FOR
VALUES
        (1, 1)

INSERT INTO PUBLISHED_FOR
VALUES
        (1, 2)

INSERT INTO PUBLISHED_FOR
VALUES
        (2, 2)

INSERT INTO PUBLISHED_FOR
VALUES
        (2, 3)

INSERT INTO PUBLISHED_FOR
VALUES
        (3, 4)



INSERT INTO USERS
Values('admin', 'admin@test.com')
INSERT INTO ADMIN

VALUES(SCOPE_IDENTITY());