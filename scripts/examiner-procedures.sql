use pg_database
go
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
If NOT EXISTS(SELECT E.id
From EXAMINER E
where E.name = @ExaminerName and E.field_of_work = @fieldOfWork and E.is_national = @National)
BEGIN
    INSERT INTO EXAMINER
        (name, is_national, field_of_work)
    VALUES
        (@ExaminerName, @National, @fieldOfWork)
    INSERT INTO EXAMINED_BY
        (examiner_id, thesis_serial_number, defense_date)
    VALUES
        (
            SCOPE_IDENTITY(),
            @ThesisSerialNo ,
            @DefenseDate
    )
END
ELSE
BEGIN
    Declare @examiner_id INT
    SELECT @examiner_id = id
    From EXAMINER
    where name = @ExaminerName and field_of_work = @fieldOfWork and is_national = @National

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
    @ThesisSerialNo INT,
    @grade DECIMAL
AS
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
SELECT *
FROM STUDENT
WHERE
id = @studentId

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