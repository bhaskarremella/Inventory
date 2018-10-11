CREATE ROLE [db_execsp]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\RG-MIS-DB Dev General];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\RG-MIS-BA General];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\svc-shared-dev];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\RG-MIS-App Dev General];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\svc-inventory-dev];


GO
ALTER ROLE [db_execsp] ADD MEMBER [COEXIST\svc-powerapps-dev];

