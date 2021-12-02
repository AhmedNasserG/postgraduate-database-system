CREATE DATABASE pg_database;

GO
    USE pg_database;

-- Create Users Table
CREATE TABLE USERS (
    id INT IDENTITY PRIMARY KEY,
    password VARCHAR(20) NOT NULL,
);

-- Create Admin Table
CREATE TABLE ADMIN (
    id INT PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES USERS(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Create Student Table
CREATE TABLE STUDENT (
    id INT PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    faculty VARCHAR(20) NOT NULL,
    gpa DECIMAL(3, 2) NOT NULL CHECK (
        gpa >= 0.7
        AND gpa <= 5
    ),
    email VARCHAR(50) NOT NULL,
    type BIT,
    address VARCHAR(50) NOT NULL,
    FOREIGN KEY (id) REFERENCES USERS(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Create Mobile Table
CREATE TABLE MOBILE (
    id INT,
    number VARCHAR(20) NOT NULL,
    PRIMARY KEY (id, number),
    FOREIGN KEY (id) REFERENCES USERS(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Create GUCIAN Table
CREATE TABLE GUCIAN (
    id INT PRIMARY KEY,
    guc_id INT UNIQUE,
    FOREIGN KEY (id) REFERENCES STUDENT(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Create NON_GUCIAN Table
CREATE TABLE NON_GUCIAN (
    id INT PRIMARY KEY,
    FOREIGN KEY (id) REFERENCES STUDENT(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Create Supervisor Table
CREATE TABLE SUPERVISOR (
    id INT PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    faculty VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    address VARCHAR(50) NOT NULL,
    FOREIGN KEY (id) REFERENCES USERS(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Create Course Table
CREATE TABLE COURSE (
    id INT PRIMARY KEY,
    code VARCHAR(10) NOT NULL,
    credit_hours INT NOT NULL,
    fees DECIMAL(7, 2) NOT NULL,
);

-- create table taken_by
CREATE TABLE TAKEN_BY (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    grade Decimal(5, 2) NOT NULL check (
        grade >= 0.0
        AND grade <= 100.0
    ),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES NON_GUCIAN(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES COURSE(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Create Payment Table
CREATE TABLE PAYMENT (
    id INT PRIMARY KEY,
    fund_percentage DECIMAL(3, 2) NOT NULL CHECK (
        fund_percentage >= 0.0
        AND fund_percentage <= 1.0
    ),
    num_of_installments INT NOT NULL CHECK (num_of_installments >= 1),
    total_amount DECIMAL(7, 2) NOT NULL,
    student_id INT NOT NULL,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES STUDENT(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (course_id) REFERENCES COURSE(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- create table installment
CREATE TABLE INSTALLMENT (
    payment_id INT NOT NULL,
    amount DECIMAL(7, 2) NOT NULL,
    installment_date DATE NOT NULL,
    PRIMARY KEY (payment_id, installment_date),
    FOREIGN KEY (payment_id) REFERENCES PAYMENT(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- Create Thesis Table
CREATE TABLE THESIS (
    serial_number INT IDENTITY PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    duration AS YEAR(end_date) - YEAR(start_date),
    type BIT,
    field VARCHAR(50) NOT NULL,
    seminar_date DATE NOT NULL,
    number_of_extensions INT NOT NULL,
    student_id INT,
    payment_id INT Unique,
    FOREIGN KEY (student_id) REFERENCES STUDENT(id),
    FOREIGN KEY (payment_id) REFERENCES PAYMENT(id),
);

-- create table supervised
CREATE TABLE SUPERVISED (
    supervisor_id INT NOT NULL,
    thesis_serial_number INT NOT NULL,
    PRIMARY KEY (supervisor_id, thesis_serial_number),
    FOREIGN KEY (supervisor_id) REFERENCES SUPERVISOR(id) ON DELETE CASCADE ON UPDATE CASCADE,
    Foreign Key (thesis_serial_number) REFERENCES THESIS(serial_number) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- create table report
CREATE TABLE REPORT (
    thesis_serial_number INT NOT NULL,
    state INT NOT NULL,
    report_date DATE NOT NULL,
    report_number INT NOT NULL,
    description VARCHAR(20) NOT NULL,
    PRIMARY KEY (thesis_serial_number, report_number),
);

-- create table evaluted by
CREATE TABLE EVALUATED_BY (
    supervisor_id INT NOT NULL,
    thesis_serial_number INT NOT NULL,
    report_number INT NOT NULL,
    evaluation int NOT NULL CHECK (
        evaluation >= 0
        AND evaluation <= 3
    ),
    PRIMARY KEY (
        supervisor_id,
        thesis_serial_number,
        report_number
    ),
    Foreign Key (thesis_serial_number, report_number) REFERENCES REPORT(thesis_serial_number, report_number) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (supervisor_id) REFERENCES SUPERVISOR(id) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- create table defense
CREATE TABLE DEFENSE (
    thesis_serial_number INT NOT NULL,
    defense_date DATE NOT NULL,
    location VARCHAR(50) NOT NULL,
    grade DECIMAL(5, 2) NOT NULL CHECK (
        grade >= 0.0
        AND grade <= 100.0
    ),
    PRIMARY KEY (thesis_serial_number, defense_date),
    FOREIGN KEY (thesis_serial_number) REFERENCES THESIS(serial_number) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- create table examiner
CREATE TABLE EXAMINER (
    id INT NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    is_national BIT NOT NULL,
    field_of_work VARCHAR(50) NOT NULL,
);

-- create table examined by
CREATE TABLE EXAMINED_BY (
    examiner_id INT NOT NULL,
    thesis_serial_number INT NOT NULL,
    defense_date DATE NOT NULL,
    comments VARCHAR(300) NOT NULL,
    PRIMARY KEY (examiner_id, thesis_serial_number, defense_date),
    FOREIGN KEY (examiner_id) REFERENCES EXAMINER(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (thesis_serial_number, defense_date) REFERENCES DEFENSE(thesis_serial_number, defense_date) ON DELETE CASCADE ON UPDATE CASCADE,
);

-- create table publication
CREATE TABLE PUBLICATION (
    id INT IDENTITY PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    publication_date DATE NOT NULL,
    place VARCHAR(50) NOT NULL,
    host VARCHAR(50) NOT NULL,
    is_accepted BIT NOT NULL,
);

-- create table published_for
CREATE TABLE PUBLISHED_FOR (
    publication_id INT NOT NULL,
    thesis_serial_number INT NOT NULL,
    PRIMARY KEY (publication_id, thesis_serial_number),
    FOREIGN KEY (publication_id) REFERENCES PUBLICATION(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (thesis_serial_number) REFERENCES THESIS(serial_number) ON DELETE CASCADE ON UPDATE CASCADE,
);