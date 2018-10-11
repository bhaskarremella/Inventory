CREATE ROLE [db_showplan]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [db_showplan] ADD MEMBER [COEXIST\RG-MIS-DB Dev General];


GO
ALTER ROLE [db_showplan] ADD MEMBER [COEXIST\RG-MIS-DevOPS];

