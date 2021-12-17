use pg_database;

exec ViewAStudentPublications 1

exec ViewAStudentPublications 2

exec AddDefenseNonGucian 5 ,'3/4/2021' ,'GUC'

exec AddDefenseNonGucian 8 ,'3/3/2022', 'auc'

exec AddDefenseGucian 6 ,'12/12/2021', 'Harvard'

exec AddExaminer 8,'3/3/2022','Ibrahim Abou Elenein', 0, 'String theory'

exec CancelThesis 1

exec CancelThesis 2


exec AddDefenseGrade 5 ,'3/4/2021' , 75

exec AddCommentsGrade  14,8, '3/3/2022','great'

exec AddGrade 5

exec viewMyProfile 1

exec viewMYProfile 2

exec editMyProfile 1 ,'Dina' , 'Khaled', '555', 'dina@gmail', 'nasrciry', 'phd'

