﻿CREATE ROLE [db_showplan]
    AUTHORIZATION [dbo];


GO
ALTER ROLE [db_showplan] ADD MEMBER [COEXIST\RG-MIS-App Dev General];


GO
ALTER ROLE [db_showplan] ADD MEMBER [COEXIST\RG-MIS-DB Dev General];


GO
ALTER ROLE [db_showplan] ADD MEMBER [COEXIST\RG-MIS-DevOPS];


GO
ALTER ROLE [db_showplan] ADD MEMBER [COEXIST\vshah];


GO
ALTER ROLE [db_showplan] ADD MEMBER [CARVANA\RG-DT-SQL-INV-DB-DEV];


GO
ALTER ROLE [db_showplan] ADD MEMBER [COEXIST\RG-SQL-DBU];

