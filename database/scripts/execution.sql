USE pg_database;
SELECT * from users
GO
SELECT * from NON_GUCIAN

EXEC StudentRegister 'mazen', 'Nasr', 'student123', 'MET', 0, 'ahmed@student.guc.edu.eg', 'New Cairo'

GO

EXEC SupervisorRegister 'Rami', 'Younes', 'supervisor123', 'MET', 'rami@guc.edu.eg'
GO

DECLARE @success INT
EXEC userLogin '18', 'supervisor123' , @success OUTPUT
PRINT @success
SELECT @success as 'Success bit'

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

GO

DECLARE @success INT
EXEC AdminIssueThesisPayment 10, 15000, 3, 0.5, @success

GO

EXEC AdminViewStudentProfile 2

GO

EXEC AdminIssueInstallPayment 11, '1/1/2021'

GO

EXEC AdminListAcceptPublication

GO

EXEC AddCourse '502', 6, 10000

GO

EXEC linkCourseStudent 6, 7

GO

EXEC addStudentCourseGrade 7, 6, 88

GO

EXEC ViewExamSupDefense '2/2/2021'

GO

EXEC EvaluateProgressReport 12, 4, 4, 3

GO

EXEC ViewSupStudentsYears 13

GO

EXEC SupViewProfile 12

GO

EXEC UpdateSupProfile 17, 'Hany', 'El Sharkawy'

GO

EXEC ViewAStudentPublications 1

GO

EXEC ViewAStudentPublications 2

GO

EXEC AddDefenseNonGucian 5 ,'3/4/2021' ,'GUC'

GO

EXEC AddDefenseNonGucian 8 ,'3/3/2022', 'auc'

GO

EXEC AddDefenseGucian 6 ,'12/12/2021', 'Harvard'

GO

EXEC AddExaminer 8,'3/3/2022','Ibrahim Abou Elenein', 0, 'String theory'

GO

EXEC CancelThesis 1

GO

EXEC CancelThesis 2

GO

EXEC AddDefenseGrade 2 ,'3/3/2021' , 75

GO

EXEC AddCommentsGrade  8, '3/3/2022','great'

GO

EXEC AddGrade 5

GO

EXEC viewMyProfile 1

GO

EXEC viewMYProfile 2

GO

EXEC editMyProfile 1 ,'Dina' , 'Khaled', '555', 'dina@gmail', 'nasrciry', 'phd'

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

EXEC FillProgressReport 10, 7, 13, 'almost done'


EXEC ViewEvalProgressReport 1, 6

GO

