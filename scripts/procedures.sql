USE pg_database;
GO

-- Unregisetered user

-- Student
CREATE PROC StudentRegister
    @first_name VARCHAR(20),
    @last_name VARCHAR(20),
    @password VARCHAR(20),
    @faculty VARCHAR(20),
    @Gucian BIT,
    @email VARCHAR(50),
    @address VARCHAR(50)
AS
INSERT INTO
    USERS
values
    (@password)

DECLARE @id INT = SCOPE_IDENTITY()

INSERT INTO
    STUDENT
    (
    id,
    first_name,
    last_name,
    faculty,
    email,
    address
    )
VALUES
    (
        @id,
        @first_name,
        @last_name,
        @faculty,
        @email,
        @address
    )

IF @Gucian = 1
BEGIN
    INSERT INTO
        GUCIAN
        (id)
    values
        (@id)
END
ELSE
BEGIN
    INSERT INTO
        NON_GUCIAN
        (id)
    values
        (@id)
END

GO

-- Supervisor
CREATE PROC SupervisorRegister
    @first_name VARCHAR(20),
    @last_name VARCHAR(20),
    @password VARCHAR(20),
    @faculty VARCHAR(20),
    @email VARCHAR(50)
AS
INSERT INTO
    USERS
values
    (@password)

INSERT INTO
    SUPERVISOR
    (id, first_name, last_name, faculty, email)
VALUES
    (
        SCOPE_IDENTITY(),
        @first_name,
        @last_name,
        @faculty,
        @email
    )

-- Registered user

GO
-- Login
CREATE PROC userLogin
    @id INT,
    @password VARCHAR(20),
    @success BIT OUTPUT
As
IF EXISTS (SELECT *
FROM USERS
WHERE id = @id AND password = @password)
BEGIN
    SET @success = 1
END
ELSE 
BEGIN
    SET @success = 0
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
SELECT sup.first_name AS Supervisor_F_Name , sup.last_name AS Supervisor_L_Name, t.title AS Thesis_Title, stu.first_name AS Student_F_Name, stu.last_name AS Student_L_Name
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

-- issue a thesis payment.

GO

CREATE PROC AdminIssueThesisPayment
    @thesis_serial_number INT,
    @amount DECIMAL(7,2),
    @num_of_installments INT,
    @fund_percentage DECIMAL(3,2),
    @success BIT OUTPUT
AS
if EXISTS (SELECT *
FROM Thesis
WHERE serial_number = @thesis_serial_number)
begin

    INSERT INTO PAYMENT
        (
        fund_percentage,
        num_of_installments,
        total_amount,
        student_id,
        course_id
        )

    VALUES
        (
            @fund_percentage,
            @num_of_installments,
            @amount,
            (SELECT student_id
            FROM THESIS
            WHERE serial_number = @thesis_serial_number),
            NULL
)

    UPDATE THESIS
       SET payment_id = SCOPE_IDENTITY()
         WHERE serial_number = @thesis_serial_number
    SET @success = 1

end
ELSE
SET @success = 0

GO

-- view the profile of any student that contains all his/her information.
CREATE PROC  AdminViewStudentProfile
    @student_id INT
AS
SELECT *
FROM STUDENT
WHERE id = @student_id

GO

-- issue installments as per the number of installments for a certain payment
-- every six months starting from the entered date.

CREATE PROC AdminIssueInstallPayment
    @payment_id INT,
    @installment_date DATE

AS
Declare @num_of_installments INT
SELECT @num_of_installments = num_of_installments
FROM PAYMENT
WHERE id = @payment_id

WHILE @num_of_installments > 0
    BEGIN
    INSERT INTO INSTALLMENT
        (
        payment_id,
        installment_date,
        amount
        )
    VALUES
        (
            @payment_id,
            @installment_date,
            (SELECT total_amount / @num_of_installments
            FROM PAYMENT
            WHERE id = @payment_id)
            )
    SET @installment_date = DATEADD(month, 6, @installment_date)
    SET @num_of_installments = @num_of_installments - 1
END

GO

-- list the title(s) of accepted publication(s) per thesis.
CREATE PROC AdminListAcceptPublication
AS

SELECT
    P.title, T.title, T.serial_number
FROM PUBLICATION P
    INNER JOIN PUBLISHED_FOR PF ON P.id = PF.publication_id
    INNER JOIN THESIS T ON PF.thesis_serial_number = T.serial_number
WHERE P.is_accepted = 1
ORDER BY T.serial_number

Go

-- Add courses and link courses to students.

CREATE PROC AddCourse
    @courseCode varchar(10),
    @credit_hours int,
    @fees decimal(7,2)

AS
INSERT INTO COURSE
    (
    code,
    credit_hours,
    fees
    )
VALUES
    (
        @courseCode,
        @credit_hours,
        @fees
        )

GO

CREATE PROC linkCourseStudent
    @course_id int,
    @student_id int

AS
INSERT INTO TAKEN_BY
    (
    course_id,
    student_id
    )
VALUES
    (
        @course_id,
        @student_id
        )

GO

CREATE PROC addStudentCourseGrade
    @student_id int,
    @course_id int,
    -- TODO fix it in the schema to be varcahr
    @grade decimal(5,2)

AS
UPDATE TAKEN_BY
    SET grade = @grade
    WHERE student_id = @student_id AND course_id = @course_id

-- view examiners and supervisor(s) names attending a thesis defense taking
-- place on a certain date

GO

CREATE PROC ViewExamSupDefense
    @defense_date DATETIME
AS
    (SELECT E.name
    FROM EXAMINER E INNER JOIN EXAMINED_BY EB ON E.id = EB.examiner_id
    WHERE EB.defense_date = @defense_date)
UNION
    (SELECT S.first_name + S.last_name AS s_name
    FROM SUPERVISOR S INNER JOIN SUPERVISED SD ON S.id = SD.supervisor_id
        INNER JOIN THESIS T ON SD.thesis_serial_number = T.serial_number
        INNER JOIN DEFENSE D on T.serial_number = D.thesis_serial_number
    WHERE D.defense_date = @defense_date)
-- SELECT
--     E .name, S2.first_name + S2.last_name AS name
-- FROM
--     EXAMINER E INNER JOIN EXAMINED_BY EB ON E.id = EB.examiner_id
--     INNER JOIN THESIS T ON EB.thesis_serial_number = T.serial_number
--     INNER JOIN SUPERVISED S ON T.serial_number = S.thesis_serial_number
--     INNER JOIN SUPERVISOR S2 ON S.supervisor_id = S2.id
-- WHERE EB.defense_date = @defense_date

GO

-- Evaluate a student’s progress report, and give evaluation value 0 to 3.
CREATE PROC EvaluateProgressReport
    @supervisor_id INT,
    @thesis_serial_number INT,
    @progress_report_no INT,
    @evaluation_value INT
AS
UPDATE EVALUATED_BY
    SET evaluation = @evaluation_value
    WHERE supervisor_id = @supervisor_id AND thesis_serial_number = @thesis_serial_number AND report_number = @progress_report_no

GO

-- View all my students’s names and years spent in the thesis
CREATE
PROC ViewSupStudentsYears
    @supervisor_id INT
AS
-- current date
DECLARE @current_date DATE
SET @current_date = GETDATE()
SELECT
    ST.first_name + ST.last_name AS name,
    DATEDIFF(year, T.start_date, (SELECT MIN(X) FROM (VALUES (@current_date), (T.end_date)) AS value(X))) AS years
FROM
    SUPERVISOR S INNER JOIN SUPERVISED SD ON
    S.id = SD.supervisor_id
    INNER JOIN THESIS T ON SD.thesis_serial_number = T.serial_number
    INNER JOIN STUDENT ST ON T.student_id = ST.id
WHERE S.id = @supervisor_id

-- View my profile and update my personal information.
GO

CREATE PROC SupViewProfile
    @supervisor_id INT
AS
SELECT *
FROM SUPERVISOR
WHERE id = @supervisor_id
    GO

CREATE PROC UpdateSupProfile
    @supervisor_id INT,
    @name VARCHAR(20),
    @faculty VARCHAR(20)

AS

UPDATE SUPERVISOR
    SET first_name = @name,
    faculty = @faculty
    WHERE id = @supervisor_id

GO

-- procedure to find all publication related to a student 
CREATE PROC ViewAStudentPublications
    @StudentId INT
AS
SELECT distinct P.*
FROM THESIS T INNER JOIN PUBLISHED_FOR PUB ON (T.serial_number = PUB.thesis_serial_number)
    INNER JOIN PUBLICATION P ON (PUB.publication_id = P.id)
WHERE T.student_id = @StudentId

GO

-- procedure to add a defense for a gucian student
CREATE PROC AddDefenseGucian
    @ThesisSerialNo int ,
    @DefenseDate Datetime ,
    @DefenseLocation varchar(15)
AS
INSERT INTO DEFENSE
    (thesis_serial_number, defense_date, location)
VALUES
    (@ThesisSerialNo, @DefenseDate, @DefenseLocation)

GO

-- procedure to add a defense for non-gucian student
CREATE PROC AddDefenseNonGucian
    @ThesisSerialNo int ,
    @DefenseDate Datetime ,
    @DefenseLocation varchar(15)
AS
Declare @student_id INT
SELECT @student_id = student_id
From THESIS
where THESIS.serial_number = @ThesisSerialNo
IF NOT EXISTS (SELECT T.student_id
FROM TAKEN_BY T
where T.grade < 50 and T.student_id = @student_id )
    BEGIN
    INSERT INTO DEFENSE
        (thesis_serial_number, defense_date, location)
    VALUES
        (@ThesisSerialNo, @DefenseDate, @DefenseLocation)

END
ELSE
BEGIN
    PRINT('Student must pass all courses ')
END    

GO

-- prodecure for adding examiner to some defense
CREATE PROC AddExaminer
    @ThesisSerialNo int ,
    @DefenseDate Datetime ,
    @ExaminerName varchar(20),
    @National bit,
    @fieldOfWork varchar(20)
AS
Declare @examiner_id INT
SELECT @examiner_id = id
From EXAMINER
where name = @ExaminerName and field_of_work = @fieldOfWork and is_national = @National

IF (@examiner_id is not NULL ) 
BEGIN
    INSERT INTO EXAMINED_BY
        (examiner_id, thesis_serial_number, defense_date)
    VALUES
        (
            @examiner_id,
            @ThesisSerialNo ,
            @DefenseDate
        )
END

GO
-- prodecure for cancelling thesis if evaluation of last report is zero
CREATE PROC CancelThesis
    @ThesisSerialNo INT
AS
DECLARE @latest_report_number INT
SELECT @latest_report_number = R.report_number
From REPORT R
WHERE R.thesis_serial_number = @ThesisSerialNo AND R.report_Date > =ALL(select R1.report_Date
    FROM REPORT R1
    where R1.thesis_serial_number = R.thesis_serial_number)


IF EXISTS (SELECT E.report_number
FROM EVALUATED_BY E
where E.report_number = @latest_report_number AND E.evaluation = 0)
BEGIN
    DELETE FROM THESIS 
    WHERE THESIS.serial_number = @ThesisSerialNo
END

GO
-- procedure for adding grade for thesis
CREATE PROC AddGrade
    @ThesisSerialNo INT
AS
DECLARE @grade DECIMAL
SELECT @grade = grade
FROM DEFENSE
WHERE DEFENSE.thesis_serial_number = @ThesisSerialNo
UPDATE THESIS
SET grade = @grade
WHERE serial_number = @ThesisSerialNo

GO

-- procedure for adding a grade to defense
CREATE PROC AddDefenseGrade
    @ThesisSerialNo int ,
    @DefenseDate Datetime ,
    @grade decimal
AS
UPDATE DEFENSE
SET grade = @grade 
WHERE thesis_serial_number = @ThesisSerialNo AND defense_date = @DefenseDate

GO
-- procedure to add comments for defense
CREATE PROC AddCommentsGrade
    @ExaminerID int ,
    @ThesisSerialNo int ,
    @DefenseDate Datetime ,
    @comments varchar(300)
AS
UPDATE EXAMINED_BY
SET comments = @comments
where examiner_id = @ExaminerID AND thesis_serial_number = @ThesisSerialNo And defense_date = @DefenseDate

GO
-- procedure to view my profile as student
CREATE PROC viewMyProfile
    @studentId int
AS
IF (Exists (Select id
from GUCIAN
where id = @studentId ) )
BEGIN
    SELECT S.* , G.guc_id
    FROM STUDENT S INNER JOIN GUCIAN G ON (S.id = G.id)
    where S.id = @studentId
end
ELSE
BEGIN
    SELECT S.*
    FROM STUDENT S
    WHERE
id = @studentId
End

GO
-- procedure to edit profile as student
CREATE PROC editMyProfile
    @studentID int,
    @firstName varchar(10),
    @lastName varchar(10),
    @password varchar(10),
    @email varchar(10),
    @address varchar(10),
    @type varchar(10)
AS
UPDATE STUDENT 
set first_name = @firstName,
last_name = @lastName,
address = @address,
email = @email,
type = @type
WHERE id = @studentID

UPDATE USERS 
SET PASSWORD = @password
WHERE id = @studentID

GO

-- As a Gucian graduate, add my undergraduate ID

CREATE PROC addUndergradID
    @studentID INT,
    @undergradID INT
AS
IF NOT EXISTS(SELECT guc_id
FROM GUCIAN
WHERE guc_id = @undergradID)
BEGIN
    UPDATE GUCIAN
    SET guc_id = @undergradID
    WHERE id = @studentID;
END
ELSE
BEGIN
    RAISERROR('A Student with the same undegradID exist please try another one', 0, 1)
END

GO

-- As a nonGucian student, view my courses' grades

CREATE PROC ViewCoursesGrades
    @studentID INT
AS
SELECT *
FROM TAKEN_BY TB INNER JOIN COURSE C ON TB.course_id =  C.id
where student_id = @studentID;

GO

-- View all my payments and installments

CREATE PROC ViewCoursePaymentsInstall
    @studentID INT
AS
    (SELECT *
    FROM PAYMENT P INNER JOIN INSTALLMENT I ON P.id = I.payment_id
    WHERE P.student_id = @studentID)
EXCEPT
    (
    SELECT *
    FROM PAYMENT P1 INNER JOIN INSTALLMENT I1 ON P1.id = I1.payment_id
    WHERE P1.student_id = @studentID AND P1.course_id IS NULL
);

GO

CREATE PROC ViewThesisPaymentsInstall
    @studentID INT
AS
SELECT P.*, I.*
FROM THESIS T INNER JOIN PAYMENT P ON T.payment_id = P.id
    INNER JOIN INSTALLMENT I ON P.id = I.payment_id
WHERE T.student_id = @studentID;

GO

CREATE PROC ViewUpcomingInstallments
    @studentID INT
AS
SELECT I.*
FROM PAYMENT P INNER JOIN INSTALLMENT I ON P.id = I.payment_id
WHERE I.installment_date > GETDATE() AND P.student_id = @studentID;

GO

CREATE PROC ViewMissedInstallments
    @studentID INT
AS
SELECT I.*
FROM PAYMENT P INNER JOIN INSTALLMENT I ON P.id = I.payment_id
WHERE P.student_id = @studentID AND I.is_paid = 0
    AND I.installment_date < GETDATE();

GO

-- Add and fill my progress report(s)

CREATE PROC AddProgressReport
    @thesisSerialNo INT,
    @progressReportDate DATE
AS
INSERT INTO REPORT
    (thesis_serial_number, report_date)
VALUES(@thesisSerialNo, @progressReportDate);

GO

CREATE PROC FillProgressReport
    @thesisSerialNo INT,
    @progressReportNo INT,
    @state INT,
    @description VARCHAR(200)
AS
UPDATE REPORT
SET state = @state, description = @description
WHERE thesis_serial_number = @thesisSerialNo AND report_number = @progressReportNo

GO

-- View my progress report(s) evaluations

CREATE PROC ViewEvalProgressReport
    @thesisSerialNo INT,
    @progressReportNo INT
AS
SELECT evaluation
FROM EVALUATED_BY
WHERE thesis_serial_number = @thesisSerialNo AND report_number = @progressReportNo

GO

-- Add publication

CREATE PROC addPublication
    @title VARCHAR(50),
    @pubDate DATETIME,
    @host VARCHAR(50),
    @place VARCHAR(50),
    @accepted BIT
AS
INSERT INTO PUBLICATION
VALUES(@title, @pubDate, @place, @host, @accepted);

GO

-- Link publication to my thesis

CREATE PROC linkPubThesis
    @pubID INT,
    @thesisSerialNo INT
AS
INSERT INTO PUBLISHED_FOR
VALUES(@pubID, @thesisSerialNo);