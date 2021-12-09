-- USE CompanyDB
USE pg_database

GO

-- As a Gucian graduate, add my undergraduate ID

CREATE PROC AddUndergradID
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
SELECT grade
FROM TAKEN_BY
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

CREATE PROC AddPublication
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

CREATE PROC LinkPubThesis
    @pubID INT,
    @thesisSerialNo INT
AS
INSERT INTO PUBLISHED_FOR
VALUES(@pubID, @thesisSerialNo);