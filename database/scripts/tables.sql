--drop dataBase pg_database
CREATE DATABASE pg_database;
GO
USE pg_database;
-- Create Users Table
CREATE TABLE USERS
(
    id INT IDENTITY PRIMARY KEY,
    password VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE
);

-- Create Admin Table
CREATE TABLE ADMIN
(
    id INT PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES USERS(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Create Student Table
CREATE TABLE STUDENT
(
    id INT PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    faculty VARCHAR(20) NOT NULL,
    gpa DECIMAL(3, 2) CHECK (
        gpa >= 0.7
            AND gpa <= 5
    ),
    type VARCHAR(10),
    address VARCHAR(50) NOT NULL,
    FOREIGN KEY (id) REFERENCES USERS(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Create Mobile Table
CREATE TABLE MOBILE
(
    id INT,
    number VARCHAR(20) NOT NULL,
    PRIMARY KEY (id, number),
    FOREIGN KEY (id) REFERENCES USERS(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Create GUCIAN Table
CREATE TABLE GUCIAN
(
    id INT PRIMARY KEY,
    guc_id VARCHAR(10),
    FOREIGN KEY (id) REFERENCES STUDENT(id) ON DELETE CASCADE ON UPDATE CASCADE,
);


-- Create NON_GUCIAN Table
CREATE TABLE NON_GUCIAN
(
    id INT PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES STUDENT(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Create Supervisor Table
CREATE TABLE SUPERVISOR
(
    id INT PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20),
    faculty VARCHAR(20) NOT NULL,
    address VARCHAR(50),
    FOREIGN KEY (id) REFERENCES USERS(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Create Course Table
CREATE TABLE COURSE
(
    id INT PRIMARY KEY IDENTITY,
    code VARCHAR(10) NOT NULL,
    credit_hours INT NOT NULL,
    fees DECIMAL(8, 2) NOT NULL,
);

-- create table taken_by
CREATE TABLE TAKEN_BY
(
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    grade Decimal(5, 2) CHECK (
        grade >= 0.0
            AND grade <= 100.0
    ),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES NON_GUCIAN(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES COURSE(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Create Payment Table
CREATE TABLE PAYMENT
(
    id INT PRIMARY KEY IDENTITY,
    fund_percentage DECIMAL(5, 2) NOT NULL,
    num_of_installments INT NOT NULL CHECK (num_of_installments >= 1),
    total_amount DECIMAL(8, 2) NOT NULL,
    student_id INT NOT NULL,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES STUDENT(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES COURSE(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- create table installment
CREATE TABLE INSTALLMENT
(
    payment_id INT NOT NULL,
    installment_date DATE NOT NULL,
    amount DECIMAL(8, 2) NOT NULL,
    is_paid BIT DEFAULT 0,
    PRIMARY KEY (payment_id, installment_date),
    FOREIGN KEY (payment_id) REFERENCES PAYMENT(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Create Thesis Table
CREATE TABLE THESIS
(
    serial_number INT IDENTITY PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    duration AS DATEDIFF(day,start_date, end_date),
    type BIT,
    grade DECIMAL(5, 2) CHECK (
        grade >= 0.0
            AND grade <= 100.0
    ),
    field VARCHAR(50) NOT NULL,
    seminar_date DATETIME NOT NULL,
    number_of_extensions INT DEFAULT 0,
    student_id INT,
    payment_id INT,
    FOREIGN KEY (student_id) REFERENCES STUDENT(id),
    FOREIGN KEY (payment_id) REFERENCES PAYMENT(id),
);

-- create table supervised
CREATE TABLE SUPERVISED
(
    supervisor_id INT NOT NULL,
    thesis_serial_number INT NOT NULL,
    PRIMARY KEY (supervisor_id, thesis_serial_number),
    FOREIGN KEY (supervisor_id) REFERENCES SUPERVISOR(id) ON DELETE CASCADE ON UPDATE CASCADE,
    Foreign Key (thesis_serial_number) REFERENCES THESIS(serial_number) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- create table report
CREATE TABLE REPORT
(
    thesis_serial_number INT NOT NULL,
    state INT,
    report_date DATE NOT NULL,
    report_number INT NOT NULL IDENTITY,
    description VARCHAR(200),
    PRIMARY KEY (thesis_serial_number, report_number),
);

-- create table evaluted by
CREATE TABLE EVALUATED_BY
(
    supervisor_id INT NOT NULL,
    thesis_serial_number INT NOT NULL,
    report_number INT NOT NULL,
    evaluation INT CHECK (
        evaluation >= 0
            AND evaluation <= 3
    ),
    PRIMARY KEY (
        supervisor_id,
        thesis_serial_number,
        report_number
    ),
    FOREIGN KEY (thesis_serial_number, report_number) REFERENCES REPORT(thesis_serial_number, report_number) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (supervisor_id) REFERENCES SUPERVISOR(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- create table defense
CREATE TABLE DEFENSE
(
    thesis_serial_number INT NOT NULL,
    defense_date DATETIME NOT NULL,
    location VARCHAR(15) NOT NULL,
    grade DECIMAL(5, 2) CHECK (
        grade >= 0.0
            AND grade <= 100.0
    ),
    PRIMARY KEY (thesis_serial_number, defense_date),
    FOREIGN KEY (thesis_serial_number) REFERENCES THESIS(serial_number) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- create table examiner
CREATE TABLE EXAMINER
(
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    is_national BIT NOT NULL,
    field_of_work VARCHAR(20) NOT NULL,
    FOREIGN KEY (id) REFERENCES USERS(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- create table examined by
CREATE TABLE EXAMINED_BY
(
    examiner_id INT NOT NULL,
    thesis_serial_number INT NOT NULL,
    defense_date DATETIME NOT NULL,
    comments VARCHAR(300) ,
    PRIMARY KEY (examiner_id, thesis_serial_number, defense_date),
    FOREIGN KEY (examiner_id) REFERENCES EXAMINER(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (thesis_serial_number, defense_date) REFERENCES DEFENSE(thesis_serial_number, defense_date) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- create table publication
CREATE TABLE PUBLICATION
(
    id INT IDENTITY PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    publication_date DATETIME NOT NULL,
    place VARCHAR(50) NOT NULL,
    host VARCHAR(50) NOT NULL,
    is_accepted BIT NOT NULL,
);


-- CREATE TABLE PUBLISHED_FOR
CREATE TABLE PUBLISHED_FOR
(
    publication_id INT NOT NULL,
    thesis_serial_number INT NOT NULL,
    PRIMARY KEY (publication_id, thesis_serial_number),
    FOREIGN KEY (publication_id) REFERENCES PUBLICATION(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (thesis_serial_number) REFERENCES THESIS(serial_number) ON DELETE CASCADE ON UPDATE CASCADE,
);

CREATE TABLE STUDENT_ADD_PUBLICATION
(
    publication_id INT PRIMARY KEY,
    student_id INT,
    FOREIGN KEY(student_id) REFERENCES STUDENT(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(publication_id) REFERENCES PUBLICATION(id) ON DELETE CASCADE ON UPDATE CASCADE
);