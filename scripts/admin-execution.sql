EXEC StudentRegister 'Ahmed', 'Nasser', 'student123', 'MET', 1, 'ahmed@student.guc.edu.eg', 'New Cairo'

EXEC SupervisorRegister 'Slim', 'Abdelnadder', 'supervisor123', 'MET', 'slim@guc.edu.eg', 'New Cairo'

DECLARE @success INT, @Type INT
EXEC userLogin '2', 'supervisor123' , @success OUTPUT, @Type OUTPUT
PRINT @success
PRINT @Type

EXEC addMobile '2', '010101010101'

EXEC AdminListSup

EXEC AdminViewSupervisorProfile '2'

EXEC AdminViewAllTheses

EXEC AdminViewStudentThesisBySupervisor

EXEC AdminListNonGucianCourse '1'

EXEC AdminUpdateExtension '1'