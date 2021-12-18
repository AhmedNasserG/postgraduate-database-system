USE pg_database;

GO

EXEC StudentRegister 'mazen', 'Nasr', 'student123', 'MET', 0, 'ahmed@student.guc.edu.eg', 'New Cairo'
SELECT * FROM STUDENT;
SELECT * FROM GUCIAN;
SELECT * FROM NON_GUCIAN;
GO

EXEC SupervisorRegister 'Rami', 'Younes', 'supervisor123', 'MET', 'rami@guc.edu.eg'

select * from USERS;
select * from GUCIAN;
SELECT * FROM MOBILE;
GO

DECLARE @success INT
EXEC userLogin '18', 'supervisor123' , @success OUTPUT
PRINT @success

GO

EXEC addMobile '2', '010101010101'

GO

EXEC AdminListSup

GO

EXEC AdminViewSupervisorProfile '10'

GO

EXEC AdminViewAllTheses

GO

EXEC AdminViewStudentThesisBySupervisor

GO

EXEC AdminListNonGucianCourse '1'

GO

EXEC AdminUpdateExtension '1'



----- PLEASE INSERT  YOUR EXECUTION ABOUELYES !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- PS: WITHOUT COPILOT BECAUSE YOU DONT KNOW HOW TO USE IT
-- THANKS BEST REGARDS YOU

GO
exec ViewAStudentPublications 1

GO
exec ViewAStudentPublications 2

GO
exec AddDefenseNonGucian 5 ,'3/4/2021' ,'GUC'

GO
exec AddDefenseNonGucian 8 ,'3/3/2022', 'auc'

GO
exec AddDefenseGucian 6 ,'12/12/2021', 'Harvard'

GO
exec AddExaminer 8,'3/3/2022','Ibrahim Abou Elenein', 0, 'String theory'

GO
exec CancelThesis 1

GO
exec CancelThesis 2

GO

exec AddDefenseGrade 5 ,'3/4/2021' , 75

GO
exec AddCommentsGrade  14,8, '3/3/2022','great'

GO
exec AddGrade 5

GO
exec viewMyProfile 1

GO
exec viewMYProfile 2

GO
exec editMyProfile 1 ,'Dina' , 'Khaled', '555', 'dina@gmail', 'nasrciry', 'phd'

GO

EXEC AddUndergradID 3, 76


GO
EXEC ViewCoursesGrades 1


GO
EXEC ViewCoursePaymentsInstall 1


GO
EXEC ViewThesisPaymentsInstall 2


GO
EXEC ViewUpcomingInstallments 3


GO
EXEC ViewMissedInstallments 2


GO
EXEC AddProgressReport 10, '2021-5-3'


GO
EXEC FillProgressReport 10, 8, 13, 'almost done'


GO
EXEC ViewEvalProgressReport 1, 6


GO
EXEC AddPublication 'Collatz Conjecture solved', '2021-8-9', 'GUC Brain',
 'Cairo', 0

GO

EXEC LinkPubThesis 4, 10
