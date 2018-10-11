CREATE ROLE [db_viewdefinition]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [db_viewdefinition] ADD MEMBER [COEXIST\RG-MIS-DB Dev General];


GO
ALTER ROLE [db_viewdefinition] ADD MEMBER [COEXIST\RG-MIS-DevOPS];

