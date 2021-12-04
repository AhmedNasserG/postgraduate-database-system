use pg_database;


-- Unregisetered user

GO
-- Student
CREATE PROC StudentRegister
    @first_name VARCHAR(20),
    @last_name VARCHAR(20),
    @password VARCHAR(20),
    @faculty VARCHAR(20),
    @type BIT,
    @email VARCHAR(50),
    @address VARCHAR(10)
AS
INSERT INTO
    USERS
values
    (@password)

INSERT INTO
    STUDENT
VALUES
    (
        SCOPE_IDENTITY(),
        @first_name,
        @last_name,
        @faculty,
        @email,
        @type,
        @address
    )

GO

-- Supervisor
CREATE PROC SupervisorRegister
    @first_name VARCHAR(20),
    @last_name VARCHAR(20),
    @password VARCHAR(20),
    @faculty VARCHAR(20),
    @email VARCHAR(50),
    @address VARCHAR(10)
AS
INSERT INTO
    USERS
values
    (@password)

INSERT INTO
    SUPERVISOR
VALUES
    (
        SCOPE_IDENTITY(),
        @first_name,
        @last_name,
        @faculty,
        @email,
        @address
    )

-- Registered user

GO
-- Login
CREATE PROC userLogin
    @id INT,
    @password VARCHAR(20),
    @success BIT OUTPUT,
    @Type INT OUTPUT
As
IF EXISTS (SELECT *
FROM USERS
WHERE id = @id AND password = @password)
BEGIN
    SET @success = 1
    IF EXISTS (SELECT *
    FROM STUDENT
    WHERE id = @id)
    BEGIN
        SET @Type = 1
    END
    ELSE IF EXISTS (SELECT *
    FROM SUPERVISOR
    WHERE id = @id)
    BEGIN
        SET @Type = 2
    END
END
ELSE 
BEGIN
    SET @success = 0
    SET @Type = 0
END

GO
-- Adding mobile numbers
CREATE PROC addMobile
    @id INT,
    @mobile_number VARCHAR(20)
AS
INSERT INTO
    MOBILE
VALUES
    (
        @id,
        @mobile_number
    )

-- Admin

GO
-- List Supervisors
CREATE PROC AdminListSup
AS
SELECT *
FROM SUPERVISOR

GO
-- View supervisor profile
CREATE PROC AdminViewSupervisorProfile
    @id INT
AS
SELECT *
FROM SUPERVISOR
WHERE id = @id

GO
-- View Theses
CREATE PROC AdminViewAllTheses
AS
SELECT *
FROM THESIS

GO
-- List the number of on going theses
CREATE PROC AdminViewOnGoingTheses
    @count INT OUTPUT
AS
SET @count = (
SELECT COUNT(*)
FROM THESIS
WHERE start_date <= GETDATE() AND end_date >= GETDATE()
)

GO
-- List all supervisors’ names currently supervising students, theses title, student name.
CREATE PROC AdminViewStudentThesisBySupervisor
AS
SELECT sup.first_name , sup.last_name, t.title, stu.first_name, stu.last_name
FROM SUPERVISOR sup INNER JOIN SUPERVISED ON sup.id = SUPERVISED.supervisor_id
    INNER JOIN THESIS t ON SUPERVISED.thesis_serial_number = t.serial_number
    INNER JOIN STUDENT stu ON stu.id = t.student_id

GO
-- List nonGucians names, course code, and respective grade.
CREATE PROC AdminListNonGucianCourse
    @course_id INT
AS
SELECT stu.first_name, stu.last_name, c.code, t.grade
FROM NON_GUCIAN n INNER JOIN TAKEN_BY t ON n.id = t.student_id
    INNER JOIN STUDENT stu ON stu.id = t.student_id
    INNER JOIN COURSE c ON c.id = t.course_id
WHERE c.id = @course_id 

GO
-- Update the number of thesis extension by 1.
CREATE PROC AdminUpdateExtension
    @thesis_serial_number INT
AS
UPDATE THESIS
SET number_of_extensions = number_of_extensions + 1
WHERE serial_number = @thesis_serial_number




