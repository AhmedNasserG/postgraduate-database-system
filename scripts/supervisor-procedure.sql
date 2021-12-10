
------------- ADMIN -----------------

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
            (SELECT course_id
            FROM THESIS
            WHERE serial_number = @thesis_serial_number)
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
WHERE student_id = @student_id
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
WHERE payment_id = @payment_id

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
            WHERE payment_id = @payment_id)
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
    @course_id int,
    @credit_hours int,
    @fees decimal(7,2)

AS
INSERT INTO COURSE
    (
    course_id,
    credit_hours,
    fees
    )
VALUES
    (
        @course_id,
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
    @defense_date DATE
AS

SELECT
    E.name, S2.name
EXAMINER E INNER JOIN EXAMINED_BY EB ON E.id = EB.examiner_id
INNER JOIN THESIS T
ON EB.thesis_serial_number = T.serial_number
WHERE T.defense_date = @defense_date INNER JOIN
SUPERVISED S ON T.serial_number = S.thesis_serial_number INNER JOIN
SUPERVISOR S2 ON S.supervisor_id = S2.id

GO


--------- supervisor ------------
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
CREAE
PROC ViewSupStudentsYears
    @supervisor_id INT
AS
-- current date
DECLARE @current_date DATE
SET @current_date = GETDATE()

SELECT
    S.name,
    DATEDIFF(year, S.start_date, @current_date) AS years
SUPERVISED S INNER JOIN SUPERVISED S2 ON
    S.id = S2.supervisor_id
    INNER JOIN THESIS T ON S2.thesis_serial_number = T.serial_number
    INNER JOIN STUDENT S3 ON T.student_id = S3.id

-- View my profile and update my personal information.
CREATE PROC SupViewProfile
    @supervisor_id INT
AS
SELECT *
FROM SUPERVISOR
WHERE supervisor_id = @supervisor_id
    GO

CREATE PROC UpdateSupProfile
    @supervisor_id INT,
    @name VARCHAR(20),
    @faculty VARCHAR(20)

AS

UPDATE SUPERVISOR
    SET name = @name,
    faculty = @faculty
    WHERE supervisor_id = @supervisor_id

    GO


