USE pg_database;

GO

EXEC AddUndergradID 3, 76

EXEC ViewCoursesGrades 1

EXEC ViewCoursePaymentsInstall 1

EXEC ViewThesisPaymentsInstall 2

EXEC ViewUpcomingInstallments 3

EXEC ViewMissedInstallments 2

EXEC AddProgressReport 10, '2021-5-3'

EXEC FillProgressReport 10, 8, 13, 'almost done'

EXEC ViewEvalProgressReport 1, 6

EXEC AddPublication 'Collatz Conjecture solved', '2021-8-9', 'GUC Brain',
 'Cairo', 0

EXEC LinkPubThesis 5, 10

