USE pg_database;

GO

EXEC StudentRegister 'Ahmed', 'Nasser', 'student123', 'MET', 1, 'ahmed@student.guc.edu.eg', 'New Cairo'

EXEC SupervisorRegister 'Slim', 'Abdelnadder', 'supervisor123', 'MET', 'slim@guc.edu.eg'

DECLARE @success INT
EXEC userLogin '18', 'supervisor123' , @success OUTPUT
PRINT @success

EXEC addMobile '2', '010101010101'

EXEC AdminListSup

EXEC AdminViewSupervisorProfile '10'

EXEC AdminViewAllTheses

EXEC AdminViewStudentThesisBySupervisor

EXEC AdminListNonGucianCourse '1'

EXEC AdminUpdateExtension '1'