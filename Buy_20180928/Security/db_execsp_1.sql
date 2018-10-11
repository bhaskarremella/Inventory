CREATE ROLE [db_execsp]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\svc-shared-test];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\svc-inventory-test];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\RG-MIS-App Dev General];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\RG-MIS-BA General];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\RG-MIS-DB Dev General];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\svc-inventory-prod];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\svc-shared-prod];


GO
ALTER ROLE [db_execsp] ADD MEMBER [UGLYDUCKLING\svc-infa];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\RG-Director General];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\svc-ssis-prod];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\vshah];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\svc-reports-read];


GO
ALTER ROLE [db_execsp] ADD MEMBER [coexist\svc-infa-prod];


GO
ALTER ROLE [db_execsp] ADD MEMBER [CARVANA\RG-DT-SQL-INV-DB-DEV];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\RG-SQL-DBU];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\RG-SQL-OnCall];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\RG-MIS-DB Dev Interns];

