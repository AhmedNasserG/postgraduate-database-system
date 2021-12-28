USE pg_database;

GO
-- 1) a) Student
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
    (@password, @email)

DECLARE @id INT = SCOPE_IDENTITY()

INSERT INTO
    STUDENT
    (
    id,
    first_name,
    last_name,
    faculty,
    address
    )
VALUES
    (
        @id,
        @first_name,
        @last_name,
        @faculty,
        @address
    )

IF @Gucian = 1
BEGIN
    INSERT INTO
        GUCIAN
        (id)
    VALUES
        (@id)
END
ELSE
BEGIN
    INSERT INTO
        NON_GUCIAN
        (id)
    VALUES
        (@id)
END

GO

-- 1) a) Supervisor
CREATE PROC SupervisorRegister
    @first_name VARCHAR(20),
    @last_name VARCHAR(20),
    @password VARCHAR(20),
    @faculty VARCHAR(20),
    @email VARCHAR(50)
AS
INSERT INTO
    USERS
VALUES
    (@password, @email)

INSERT INTO
    SUPERVISOR
    (id, first_name, last_name, faculty)
VALUES
    (
        SCOPE_IDENTITY(),
        @first_name,
        @last_name,
        @faculty
    )
GO

CREATE PROC ExaminerRegister
    @name VARCHAR(20),
    @fieldOfWork VARCHAR(20),
    @National BIT,
    @email VARCHAR(50),
    @password VARCHAR(50)

AS
INSERT INTO
    USERS
VALUES
    (@password, @email)

INSERT INTO
    EXAMiNER
    (id, name, is_national,field_of_work)
VALUES
    (
        SCOPE_IDENTITY(),
        @name,
        @National,
        @fieldOFWork
    )

-- Registered user

GO
-- 2) a) Login
CREATE PROC userLogin
    @email VARCHAR(50),
    @password VARCHAR(20),
    @success BIT OUTPUT,
    @id INT OUTPUT
As
IF EXISTS (SELECT *
FROM USERS
WHERE email = @email AND password = @password)
BEGIN
    SELECT @id = id
    FROM USERS
    where  email = @email

    SET @success = 1
END
ELSE
BEGIN
    SET @success = 0
END
GO

-- get type of the user
CREATE PROCEDURE TypeOFUser
    @id INT,
    @type INT OUTPUT
AS
IF EXISTS (select *
FROM STUDENT
where id=@id)
BEGIN
    set @type = 0
END
ELSE IF EXISTS (SELECT *
FROM SUPERVISOR
where id =@id)
BEGIN
    SET @type = 1
END
ELSE IF EXISTS (SELECT *
FROM EXAMINER
where id = @id)
BEGIN
    SET @type = 2
END
ELSE IF EXISTS (SELECT *
FROM ADMIN
where id = @id)
BEGIN
    SET @type = 3
END

GO
-- 2) b) Adding mobile numbers
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
-- 3) a) List Supervisors
CREATE PROC AdminListSup
AS
SELECT *
FROM SUPERVISOR

GO
-- 3) b) View supervisor profile
CREATE PROC AdminViewSupervisorProfile
    @id INT
AS
SELECT *
FROM SUPERVISOR
WHERE id = @id

GO
-- 3) c) View Theses
CREATE PROC AdminViewAllTheses
AS
SELECT *
FROM THESIS

GO
-- 3) d) List the number of on going theses
CREATE PROC AdminViewOnGoingTheses
    @count INT OUTPUT
AS
SET @count = (
SELECT COUNT(*)
FROM THESIS
WHERE start_date <= GETDATE() AND end_date >= GETDATE()
)

GO
-- 3) e) List all supervisors’ names currently supervising students, theses title, student name.
CREATE PROC AdminViewStudentThesisBySupervisor
AS
SELECT sup.first_name AS Supervisor_F_Name , sup.last_name AS Supervisor_L_Name, t.title AS Thesis_Title, stu.first_name AS Student_F_Name, stu.last_name AS Student_L_Name
FROM SUPERVISOR sup INNER JOIN SUPERVISED ON sup.id = SUPERVISED.supervisor_id
    INNER JOIN THESIS t ON SUPERVISED.thesis_serial_number = t.serial_number
    INNER JOIN STUDENT stu ON stu.id = t.student_id

GO
-- 3) f) List nonGucians names, course code, and respective grade.
CREATE PROC AdminListNonGucianCourse
    @course_id INT
AS
SELECT stu.first_name, stu.last_name, c.code, t.grade
FROM NON_GUCIAN n INNER JOIN TAKEN_BY t ON n.id = t.student_id
    INNER JOIN STUDENT stu ON stu.id = t.student_id
    INNER JOIN COURSE c ON c.id = t.course_id
WHERE c.id = @course_id

GO
-- 3) g) Update the number of thesis extension by 1.
CREATE PROC AdminUpdateExtension
    @thesis_serial_number INT
AS
UPDATE THESIS
SET number_of_extensions = number_of_extensions + 1
WHERE serial_number = @thesis_serial_number

-- 3) h) issue a thesis payment.

GO

CREATE PROC AdminIssueThesisPayment
    @thesis_serial_number INT,
    @amount DECIMAL(7,2),
    @num_of_installments INT,
    @fund_percentage DECIMAL(3,2),
    @success BIT OUTPUT
AS
IF EXISTS (SELECT *
FROM Thesis
WHERE serial_number = @thesis_serial_number)
BEGIN

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

END
ELSE
SET @success = 0

GO

-- 3) i) view the profile of any student that contains all his/her information.
CREATE PROC  AdminViewStudentProfile
    @student_id INT
AS
SELECT *
FROM STUDENT
WHERE id = @student_id

GO

-- 3) j) issue installments as per the number of installments for a certain payment
-- every six months starting from the entered date.

CREATE PROC AdminIssueInstallPayment
    @payment_id INT,
    @installment_date DATE

AS
Declare @num_of_installments INT, @counter INT
SELECT @num_of_installments = num_of_installments
FROM PAYMENT
WHERE id = @payment_id
SET @counter = @num_of_installments
WHILE @counter > 0
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
    SET @counter = @counter - 1
END

GO

-- 3) k) list the title(s) of accepted publication(s) per thesis.
CREATE PROC AdminListAcceptPublication
AS
SELECT
    P.title, T.title, T.serial_number
FROM PUBLICATION P
    INNER JOIN PUBLISHED_FOR PF ON P.id = PF.publication_id
    INNER JOIN THESIS T ON PF.thesis_serial_number = T.serial_number
WHERE P.is_accepted = 1
ORDER BY T.serial_number

GO

-- 3) l) Add courses and link courses to students.

CREATE PROC AddCourse
    @courseCode VARCHAR(10),
    @credit_hours INT,
    @fees DECIMAL(8,2)

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
    @course_id INT,
    @student_id INT

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
    @student_id INT,
    @course_id INT,
    @grade DECIMAL(5,2)
AS
UPDATE TAKEN_BY
    SET grade = @grade
    WHERE student_id = @student_id AND course_id = @course_id

-- 3) m) view examiners and supervisor(s) names attending a thesis defense taking
-- place on a certain date

GO

CREATE PROC ViewExamSupDefense
    @defense_date DATETIME
AS
    (SELECT E.name
    FROM EXAMINER E INNER JOIN EXAMINED_BY EB ON E.id = EB.examiner_id
    WHERE EB.defense_date = @defense_date)
UNION
    (SELECT S.first_name + ' ' + S.last_name AS s_name
    FROM SUPERVISOR S INNER JOIN SUPERVISED SD ON S.id = SD.supervisor_id
        INNER JOIN THESIS T ON SD.thesis_serial_number = T.serial_number
        INNER JOIN DEFENSE D ON T.serial_number = D.thesis_serial_number
    WHERE D.defense_date = @defense_date)

GO

-- 4) a) Evaluate a student’s progress report, and give evaluation value 0 to 3.
CREATE PROC EvaluateProgressReport
    @supervisor_id INT,
    @thesis_serial_number INT,
    @progress_report_no INT,
    @evaluation_value INT
AS
-- TODO ADD NOT UPDATE
INSERT INTO EVALUATED_BY
    (
    supervisor_id,
    thesis_serial_number,
    report_number,
    evaluation
    )
VALUES
    (
        @supervisor_id,
        @thesis_serial_number,
        @progress_report_no,
        @evaluation_value
        )


GO

-- 4) b) View all my students’s names and years spent in the thesis
CREATE PROC ViewSupStudentsYears
    @supervisor_id INT
AS
-- current date
DECLARE @current_date DATE
SET @current_date = GETDATE()
SELECT
    ST.first_name + ' ' +  ST.last_name AS name,
    DATEDIFF(year, T.start_date, (SELECT MIN(X)
    FROM (VALUES
            (@current_date),
            (T.end_date)) AS VALUE(X))) AS years
    , ST.id AS student_id
FROM
    SUPERVISOR S INNER JOIN SUPERVISED SD ON
    S.id = SD.supervisor_id
    INNER JOIN THESIS T ON SD.thesis_serial_number = T.serial_number
    INNER JOIN STUDENT ST ON T.student_id = ST.id
WHERE S.id = @supervisor_id

-- 4) c) View my profile and update my personal information.
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

-- 4) d)  procedure to find all publication related to a student
CREATE PROC ViewAStudentPublications
    @StudentId INT
AS
SELECT distinct P.*
FROM THESIS T INNER JOIN PUBLISHED_FOR PUB ON (T.serial_number = PUB.thesis_serial_number)
    INNER JOIN PUBLICATION P ON (PUB.publication_id = P.id)
WHERE T.student_id = @StudentId

GO

-- get all reports of a all students I supervise
CREATE PROC ViewAllStudentsReports
    @supervisor_id INT
AS
SELECT R.*, T.title, S.first_name + ' ' + S.last_name AS student_name
FROM THESIS T INNER JOIN SUPERVISED SD ON T.serial_number = SD.thesis_serial_number
    INNER JOIN REPORT R ON T.serial_number = R.thesis_serial_number INNER JOIN STUDENT S ON T.student_id = S.id
WHERE SD.supervisor_id = @supervisor_id
Go
-- 4) e) procedure to add a defense for a gucian student
CREATE PROC AddDefenseGucian
    @ThesisSerialNo INT ,
    @DefenseDate DATETIME ,
    @DefenseLocation VARCHAR(15)
AS
INSERT INTO DEFENSE
    (thesis_serial_number, defense_date, location)
VALUES
    (@ThesisSerialNo, @DefenseDate, @DefenseLocation)

GO

-- 4) e) procedure to add a defense for non-gucian student
CREATE PROC AddDefenseNonGucian
    @ThesisSerialNo INT ,
    @DefenseDate DATETIME ,
    @DefenseLocation VARCHAR(15)
AS
Declare @student_id INT
SELECT @student_id = student_id
FROM THESIS
WHERE THESIS.serial_number = @ThesisSerialNo
IF NOT EXISTS (SELECT T.student_id
FROM TAKEN_BY T
WHERE T.grade <= 50 AND T.student_id = @student_id )
    BEGIN
    INSERT INTO DEFENSE
        (thesis_serial_number, defense_date, location)
    VALUES
        (@ThesisSerialNo, @DefenseDate, @DefenseLocation)

END
ELSE
BEGIN
    RAISERROR('Student should pass all course', 16, 1)
END
GO
-- 4) f) prodecure for adding examiner to some defense
CREATE PROC AddExaminer

    @DefenseDate DATETIME,
    @ExaminerName VARCHAR
(20),
    @National BIT,
    @ThesisSerialNo INT,
    @fieldOfWork VARCHAR
(20)
AS
-- Declare @date DATETIME
Declare @examiner_id INT
-- set @date =  CONVERT(datetime,@DefenseDate,101)
SELECT @examiner_id = id
FROM EXAMINER
WHERE name = @ExaminerName AND field_of_work = @fieldOfWork AND is_national = @National

IF (@examiner_id IS NOT NULL )
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
-- 4) g) prodecure for cancelling thesis if evaluation of last report is zero
CREATE PROC CancelThesis
    @ThesisSerialNo INT
AS
DECLARE @latest_report_number INT
SELECT @latest_report_number = R.report_number
FROM REPORT R
WHERE R.thesis_serial_number = @ThesisSerialNo AND R.report_Date >=ALL(SELECT R1.report_Date
    FROM REPORT R1
    WHERE R1.thesis_serial_number = R.thesis_serial_number)


IF EXISTS (SELECT E.report_number
FROM EVALUATED_BY E
WHERE E.report_number = @latest_report_number AND E.evaluation = 0)
BEGIN
    DELETE FROM THESIS
    WHERE THESIS.serial_number = @ThesisSerialNo
END
select *
from USERS
GO
-- 4) h) procedure for adding grade for thesis
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
CREATE PROC ShowExaminerTheses
    @examiner_id int
AS
SELECT T.serial_number , T.title, Sup.first_name+' '+Sup.last_name AS supervisor_name, St.first_name +' '+St.last_name AS student_name
From EXAMINED_BY Ex INNER JOIN Thesis T on (Ex.thesis_serial_number = T.serial_number) INNER JOIN SUPERVISED Su ON( T.serial_number = Su.thesis_serial_number)
    INNER JOIN SUPERVISOR Sup on (Su.supervisor_id = Sup.id) INNER JOIN STUDENT St on (T.student_id = St.id)
WHERE Ex.examiner_id = @examiner_id
GO
-- 5) a) procedure for adding a grade to defense
CREATE PROC AddDefenseGrade
    @ThesisSerialNo INT ,
    @DefenseDate DATETIME ,
    @grade DECIMAL(5, 2)
AS
UPDATE DEFENSE
SET grade = @grade
WHERE thesis_serial_number = @ThesisSerialNo AND defense_date = @DefenseDate

GO
-- 5) b) procedure to add comments for defense
CREATE PROC AddCommentsGrade
    @ThesisSerialNo INT ,
    @DefenseDate DATETIME ,
    @comments VARCHAR(300)
AS
UPDATE EXAMINED_BY
SET comments = @comments
WHERE thesis_serial_number = @ThesisSerialNo AND defense_date = @DefenseDate

GO
-- 6) a) procedure to view my profile as student
CREATE PROC viewMyProfile
    @studentId INT
AS
IF (EXISTS (SELECT id
FROM GUCIAN
WHERE id = @studentId ) )
BEGIN
    SELECT S.* , G.guc_id
    FROM STUDENT S INNER JOIN GUCIAN G ON (S.id = G.id)
    WHERE S.id = @studentId
END
ELSE
BEGIN
    SELECT S.*
    FROM STUDENT S
    WHERE
id = @studentId
End

GO
-- 6) b) procedure to edit profile as student
CREATE PROC editMyProfile
    @studentID INT,
    @firstName VARCHAR(10),
    @lastName VARCHAR(10),
    @password VARCHAR(10),
    @email VARCHAR(10),
    @address VARCHAR(10),
    @type VARCHAR(10)
AS
UPDATE STUDENT
SET first_name = @firstName,
LAST_NAME = @lastName,
ADDRESS = @address,
TYPE = @type
WHERE id = @studentID

UPDATE USERS
SET PASSWORD = @password,
email = @email
WHERE id = @studentID

GO

-- 6) c) As a Gucian graduate, add my undergraduate ID

CREATE PROC addUndergradID
    @studentID INT,
    @undergradID VARCHAR(10)
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

-- 6) d) As a nonGucian student, view my courses' grades

CREATE PROC ViewCoursesGrades
    @studentID INT
AS
SELECT *
FROM TAKEN_BY TB INNER JOIN COURSE C ON TB.course_id =  C.id
WHERE student_id = @studentID;

GO

-- 6) e) View all my payments and installments

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
WHERE I.installment_date >= GETDATE() AND P.student_id = @studentID;

GO

CREATE PROC ViewMissedInstallments
    @studentID INT
AS
SELECT I.*
FROM PAYMENT P INNER JOIN INSTALLMENT I ON P.id = I.payment_id
WHERE P.student_id = @studentID AND I.is_paid = 0
    AND I.installment_date < GETDATE();

GO

-- 6) f) Add and fill my progress report(s)

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

-- 6) g) View my progress report(s) evaluations

CREATE PROC ViewEvalProgressReport
    @thesisSerialNo INT,
    @progressReportNo INT
AS
SELECT *
FROM EVALUATED_BY
WHERE thesis_serial_number = @thesisSerialNo AND report_number = @progressReportNo

GO

-- 6) h) Add publication

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

-- 6) i) Link publication to my thesis

CREATE PROC linkPubThesis
    @pubID INT,
    @thesisSerialNo INT
AS
INSERT INTO PUBLISHED_FOR
VALUES(@pubID, @thesisSerialNo);


go
-- get all thesis a supervisor supervise
CREATE PROC viewSupThesis
    @supervisor_id INT
AS
SELECT T.*
FROM
    SUPERVISOR S INNER JOIN SUPERVISED S1 ON S.id = S1.supervisor_id
    INNER JOIN THESIS T ON S1.thesis_serial_number = T.serial_number
WHERE S.id = @supervisor_id;


go

CREATE PROC is_GUCian
    @thesisSerialNo INT,
    @output INT OUTPUT
AS
IF EXISTS (SELECT id
from THESIS T inner join GUCIAN G on T.student_id = G.id
where T.serial_number = @thesisSerialNo)
BEGIN
    SET @output = 1
END
ELSE
BEGIN
    SET @output = 0
END


go

CREATE PROC viewExaminer
AS

SELECT *
FROM DEFENSE


SELECT *
FROM EXAMINED_BY

DELETE FROM EXAMINED_BY
DELETE FROM DEFENSE
