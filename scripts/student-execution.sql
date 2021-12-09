USE pg_database
-- USE CompanyDB;

GO

EXEC AddUndergradID 3, 76

EXEC ViewCoursesGrades 4

EXEC ViewCoursePaymentsInstall 4

EXEC ViewThesisPaymentsInstall 4

EXEC ViewUpcomingInstallments 4

EXEC ViewMissedInstallments 4

EXEC AddProgressReport 2, '2021-5-3'

EXEC FillProgressReport 2, 2, 6, 'This report is the worst'

EXEC ViewEvalProgressReport 2, 2

EXEC AddPublication 'Riemann Hypothesis Solved', '2021-8-7', 'Berlin',
 'GUC', 1

EXEC LinkPubThesis 1, 1

