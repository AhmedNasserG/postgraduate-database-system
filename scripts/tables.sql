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
    FOREIGN KEY (student_id) REFERENCES STUDENT(id) ON DELETE CASCADE ON UPDATE CASCADE,
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
    student_id INT NOT NULL,
    supervisor_id INT NOT NULL,
    payment_id INT NOT NULL,
    FOREIGN KEY (supervisor_id) REFERENCES SUPERVISOR(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (student_id) REFERENCES STUDENT(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (payment_id) REFERENCES PAYMENT(id) ON DELETE CASCADE ON UPDATE CASCADE,
);