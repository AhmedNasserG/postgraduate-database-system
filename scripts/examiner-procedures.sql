use pg_database
go
-- procedure to find all publication related to a student 
CREATE PROC ViewAStudentPublications
    @StudentId INT
AS
SELECT P.*
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
DECLARE @CountOfFailedCourses INT
SELECT @CountOfFailedCourses = COUNT(*)
FROM NON_GUCIAN G INNER JOIN TAKEN_BY T on(G.id = T.student_id)
where G.id = @student_id AND
    (T.grade < 50 OR T.grade IS NULL)
IF (@CountOfFailedCourses = 0)
    BEGIN
    INSERT INTO DEFENSE
        (thesis_serial_number, defense_date, location)
    VALUES
        (@ThesisSerialNo, @DefenseDate, @DefenseLocation)

END
ELSE
BEGIN
    PRINT('student must pass all courses')
END    
