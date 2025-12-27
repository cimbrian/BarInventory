/****** Object:  StoredProcedure [dbo].[AreaCountsById]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Selects single row from dbo.AreaCounts table by identity column.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[AreaCountsById]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        InventoryItemId,
        AreaId,
        FullUnits,
        PartialAmount,
        HasPartial,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.AreaCounts
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[AreaCountsDelete]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Deletes single row from dbo.AreaCounts table by identity column.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[AreaCountsDelete]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM dbo.AreaCounts
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[AreaCountsQuery]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Queries dbo.AreaCounts table.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[AreaCountsQuery]
(
    --+Comment=InventoryItemId
    --+Default=null
    @InventoryItemId int NULL=NULL,
 
    --+Comment=AreaId
    --+Default=null
    @AreaId int NULL=NULL,

    --+Comment=HasPartial
    --+Default=null
    @HasPartial bit NULL=NULL
 
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        InventoryItemId,
        AreaId,
        FullUnits,
        PartialAmount,
        HasPartial,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.AreaCounts
    WHERE
        (@InventoryItemId IS NULL OR InventoryItemId = @InventoryItemId) AND
        (@AreaId IS NULL OR AreaId = @AreaId) AND
        (@HasPartial IS NULL OR HasPartial = @HasPartial) 

    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[AreaCountsUpsert]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Upserts a new record into the dbo.AreaCounts table.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[AreaCountsUpsert]
(
    --+Default=null
    --+Comment=Id
    --+InOut
    @Id int = null out,
 
    --+Required
    --+Default=0
    --+Comment=InventoryItemId
    @InventoryItemId int,
 
    --+Required
    --+Comment=AreaId
    --+Default=0
    @AreaId int,
 
    --+Required
    --+Comment=FullUnits
    --+Default=0
    @FullUnits int,
 
    --+Required
    --+Comment=PartialAmount
    --+Default=0
    @PartialAmount decimal(4,1),
 
    --+Required
    --+Comment=HasPartial
    --+Default=false
    @HasPartial bit
 
)
AS
BEGIN
 
    SET NOCOUNT ON;
    DECLARE @CreatedAt datetime2(7) = GETDATE();
    DECLARE @ModifiedAt datetime2(7) = GETDATE();
    

    IF @Id IS NULL OR (@Id IS NOT NULL AND @Id = 0)
    BEGIN

        INSERT INTO [dbo].[AreaCounts]
        (
            InventoryItemId,
            AreaId,
            FullUnits,
            PartialAmount,
            HasPartial,
            CreatedAt,
            ModifiedAt
        )
        VALUES
        (
            @InventoryItemId,
            @AreaId,
            @FullUnits,
            @PartialAmount,
            @HasPartial,
            @CreatedAt,
            @ModifiedAt
        );
 
        SET @Id = scope_identity();
        IF @@ROWCOUNT=0 OR @Id = 0
        BEGIN
            --+Return=InsertError
            RETURN 2;
        END
        
    END
    ELSE
    BEGIN
 
        UPDATE [dbo].[AreaCounts] SET
            InventoryItemId = @InventoryItemId,
            AreaId = @AreaId,
            FullUnits = @FullUnits,
            PartialAmount = @PartialAmount,
            HasPartial = @HasPartial,
            ModifiedAt = @ModifiedAt
        WHERE
            Id = @Id;
 
        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=UpdateError
            RETURN 3;
        END;
    END
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[BasicCRUDProcedures]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[BasicCRUDProcedures] 
( 
	@SourceSchema varchar(64),
	@SourceTable varchar(64),
	@DestinationSchema varchar(64),
	@AuthorName varchar(256)
)
AS
BEGIN

	SET NOCOUNT ON;
	
	-- Build CRUD procs to kickstart ORM Entities 
	-- Used with SQLPlus.Net ORM for C#
	-- Alan Hyneman

	DECLARE @QueryColumnsTable TABLE
	(
		Id int IDENTITY(1,1),
		OrdinalPostion int,
		RequiredAttribute varchar(32),
		MaxLengthAttribute varchar(32),
		ParameterType varchar(32),
		ColumnName varchar(64),
		IdColumn bit
	);

	DECLARE @StandardColumnsTable TABLE
	(
		Id int IDENTITY(1,1),
		OrdinalPostion int,
		RequiredAttribute varchar(32),
		MaxLengthAttribute varchar(32),
		ParameterType varchar(32),
		ColumnName varchar(64),
		IdColumn bit
	);

	DECLARE @WhereColumnsTable TABLE
	(
		Id int IDENTITY(1,1),
		OrdinalPostion int,
		RequiredAttribute varchar(32),
		MaxLengthAttribute varchar(32),
		ParameterType varchar(32),
		ColumnName varchar(64),
		IdColumn bit
	);

	DECLARE
		@Idx int,
		@QueryMax int,
		@StandardMax int,
		@WhereMax int,
		@RequiredAttribute varchar(32),
		@MaxLengthAttribute varchar(32),
		@ParameterType varchar(32),
		@ColumnName varchar(64),
		@IdColumn bit,
		@Out char(4)

	INSERT INTO @QueryColumnsTable

	SELECT
		ORDINAL_POSITION,
		CASE
			WHEN IS_NULLABLE = 'NO' THEN 
				'--+Required' 
			ELSE NULL 
		END RequiredAttribute,
		CASE
			WHEN DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar', 'binary', 'varbinary') AND CHARACTER_MAXIMUM_LENGTH > 0 THEN
				CONCAT('--+MaxLength=',CHARACTER_MAXIMUM_LENGTH)
			ELSE NULL
		END MaxLengthAttribute,
		CASE 
			WHEN DATA_TYPE IN ('char', 'nchar', 'binary') THEN
				CONCAT(DATA_TYPE,'(',CHARACTER_MAXIMUM_LENGTH,')')
			WHEN DATA_TYPE IN ('char', 'varchar', 'nchar', 'nvarchar', 'binary','varbinary') THEN
				CASE WHEN CHARACTER_MAXIMUM_LENGTH > 0 THEN
					CONCAT(DATA_TYPE,'(',CHARACTER_MAXIMUM_LENGTH,')')
				ELSE
					CONCAT(DATA_TYPE,'(MAX)')
				END
			WHEN DATA_TYPE IN ('decimal', 'numeric') THEN
				CONCAT(DATA_TYPE,'(',NUMERIC_PRECISION,',',NUMERIC_SCALE,')')
			WHEN DATA_TYPE IN ('datetime2') THEN
				CONCAT(DATA_TYPE,'(',DATETIME_PRECISION,')')
			ELSE
				DATA_TYPE
		END ParameterType,
		COLUMN_NAME ColumnName,
		CASE 
			WHEN COLUMNPROPERTY(object_id(TABLE_SCHEMA + '.' + TABLE_NAME), COLUMN_NAME, 'IsIdentity') = 1 THEN
				1
			ELSE
				0
			END IdColumm
	FROM
		INFORMATION_SCHEMA.COLUMNS
	WHERE
		TABLE_SCHEMA = @SourceSchema AND
		TABLE_NAME = @SourceTable
	ORDER BY
		ORDINAL_POSITION;

	INSERT INTO @StandardColumnsTable
		SELECT OrdinalPostion, RequiredAttribute, MaxLengthAttribute, ParameterType, ColumnName, IdColumn 
		FROM @QueryColumnsTable WHERE ParameterType <> 'timestamp'
		ORDER BY OrdinalPostion;

	INSERT INTO @WhereColumnsTable
		SELECT OrdinalPostion, RequiredAttribute, MaxLengthAttribute, ParameterType, ColumnName, IdColumn 
		FROM @QueryColumnsTable WHERE ParameterType not in ('image', 'ntext', 'timestamp', 'text', 'xml')
		ORDER BY OrdinalPostion;

	SELECT @QueryMax = Max(Id) FROM @QueryColumnsTable;
	SELECT @StandardMax = Max(Id) FROM @StandardColumnsTable;
	SELECT @WhereMax = Max(Id) FROM @WhereColumnsTable;

	SET @Idx = 1; 
	PRINT '--+SqlPlus'+'Routine';
	PRINT '    --&Author=' + @AuthorName;
	PRINT '    --&Comment=Inserts a new record into the ' + @SourceSchema + '.' +@SourceTable + ' table.';
	PRINT '    --&SelectType=NonQuery';
	PRINT '--+SqlPlus'+'Routine';
	PRINT 'CREATE PROCEDURE [' + @DestinationSchema + '].[' + @SourceTable + 'Insert]'
	PRINT '('
	WHILE @Idx <= @StandardMax
	BEGIN
		Select @RequiredAttribute = RequiredAttribute, @MaxLengthAttribute = MaxLengthAttribute, @ParameterType = ParameterType, @ColumnName = ColumnName, @IdColumn = IdColumn 
		From @StandardColumnsTable WHERE Id = @Idx;
		IF @IdColumn = 'true' SET @Out = ' out' ELSE SET @Out = null;
		IF @IdColumn = 'false'
		BEGIN
			IF @RequiredAttribute IS NOT NULL PRINT Concat('    ', @RequiredAttribute);
			IF @MaxLengthAttribute IS NOT NULL PRINT Concat('    ', @MaxLengthAttribute);
			PRINT '    --+Comment=' + @ColumnName
		END
		PRINT CONCAT('    @', @ColumnName,' ', @ParameterType,  @Out, (CASE WHEN @Idx < @StandardMax THEN ',' ELSE NULL END));
		PRINT '';
		SET @Idx += 1;
	END;
	PRINT ')'
	PRINT 'AS'
	PRINT 'BEGIN'
	PRINT '';
	PRINT '    SET NOCOUNT ON;'
	PRINT '';
	PRINT '    INSERT INTO [' + @SourceSchema + '].[' + @SourceTable +']'
	PRINT '    ('
	SET @Idx = 1;
	WHILE @Idx <= @StandardMax
	BEGIN
		Select @ColumnName = ColumnName, @IdColumn = IdColumn From @StandardColumnsTable WHERE Id = @Idx;
		IF @IdColumn = 'false' 
		BEGIN
			PRINT Concat('        ', @ColumnName, (CASE WHEN @Idx < @StandardMax THEN ',' ELSE NULL END));
		END;
		SET @Idx += 1;
	END;
	PRINT '    )'
	PRINT '    VALUES'
	PRINT '    ('
	SET @Idx = 1;
	WHILE @Idx <= @StandardMax
	BEGIN
		Select @ColumnName = ColumnName, @IdColumn = IdColumn From @StandardColumnsTable WHERE Id = @Idx;
		IF @IdColumn = 'false'
		BEGIN
			PRINT Concat('        @', @ColumnName, (CASE WHEN @Idx < @StandardMax THEN ',' ELSE NULL END));
		END;
		SET @Idx += 1;
	END;
	PRINT '    );'
	PRINT ''
	Select @ColumnName = ColumnName FROM @StandardColumnsTable WHERE IdColumn = 'True';
	IF @ColumnName IS NOT NULL
	BEGIN
		PRINT '    SET @' + @ColumnName + ' = scope_identity();'
		PRINT ''
	END;
	PRINT '    --+Return=Ok';
	PRINT '    RETURN 1;';
	PRINT '';
	PRINT 'END;';
	/* JBK 01-25-2020 - GO required between stored procedure CREATEs in order to execute in a single transaction */
	PRINT 'GO'
	PRINT ''
	PRINT '------------------------------------------------------------------------------------------------------------------------------';
	PRINT '';
	PRINT '--+SqlPlus'+'Routine';
	PRINT '    --&Author=' + @AuthorName;
	PRINT '    --&Comment=Updates record for the ' + @SourceSchema +'.'+@SourceTable + ' table.';
	PRINT '    --&SelectType=NonQuery';
	PRINT '--+SqlPlus'+'Routine';
	PRINT 'CREATE PROCEDURE [' + @DestinationSchema + '].[' + @SourceTable + 'Update]'
	PRINT '('
	SET @Idx = 1; 
	WHILE @Idx <= @StandardMax
	BEGIN
		Select @RequiredAttribute = RequiredAttribute, @MaxLengthAttribute = MaxLengthAttribute, @ParameterType = ParameterType, @ColumnName = ColumnName, @IdColumn = IdColumn 
		From @StandardColumnsTable WHERE Id = @Idx;
		IF @RequiredAttribute IS NOT NULL PRINT Concat('    ', @RequiredAttribute);
		IF @MaxLengthAttribute IS NOT NULL PRINT Concat('    ', @MaxLengthAttribute);
		PRINT '    --+Comment=' + @ColumnName
		PRINT CONCAT('    @', @ColumnName,' ', @ParameterType,  @Out, (CASE WHEN @Idx < @StandardMax THEN ',' ELSE NULL END));
		PRINT '';
		SET @Idx += 1;
	END;
	PRINT ')'
	PRINT 'AS'
	PRINT 'BEGIN'
	PRINT '';
	PRINT '    SET NOCOUNT ON;'
	PRINT '';
	PRINT '    UPDATE [' + @SourceSchema + '].[' + @SourceTable +'] SET'
	SET @Idx = 1; 
	WHILE @Idx <= @StandardMax
	BEGIN
		Select @ColumnName = ColumnName, @IdColumn = IdColumn, @ParameterType = ParameterType From @StandardColumnsTable WHERE Id = @Idx;
		IF @IdColumn = 'False' AND @ParameterType not in ('timestamp')
		BEGIN
			PRINT Concat('        ', @ColumnName, ' = @', @ColumnName, (CASE WHEN @Idx < @StandardMax THEN ',' ELSE NULL END));
		END;
		SET @Idx += 1;
	END;
	SELECT @ColumnName = ColumnName FROM @StandardColumnsTable WHERE IdColumn = 'TRUE'
	PRINT '    WHERE'
	PRINT CONCAT('        ', @ColumnName, ' = @', @ColumnName)
	PRINT '';
	PRINT '    IF @@ROWCOUNT = 0';
	PRINT '    BEGIN';
	PRINT '        --+Return=NotFound';
	PRINT '        RETURN 0;';
	PRINT '    END;';
	PRINT '';
	PRINT '    --+Return=Ok';
	PRINT '    RETURN 1;';
	PRINT '';
	PRINT 'END;';
	PRINT 'GO'
	PRINT ''
	PRINT '------------------------------------------------------------------------------------------------------------------------------';
	PRINT '';
	PRINT '--+SqlPlus'+'Routine';
	PRINT '    --&Author=' + @AuthorName;
	PRINT '    --&Comment=Selects single row from ' + @SourceSchema +'.'+@SourceTable + ' table by identity column.';
	PRINT '    --&SelectType=SingleRow';
	PRINT '--+SqlPlus'+'Routine';
	PRINT 'CREATE PROCEDURE [' + @DestinationSchema + '].[' + @SourceTable + 'ById]'
	PRINT '('
	Select @ColumnName = ColumnName, @ParameterType = ParameterType From @WhereColumnsTable WHERE IdColumn = 'True';
	PRINT '    --+Required';
	PRINT '    --+Comment=' + @ColumnName;
	PRINT CONCAT('    @', @ColumnName,' ', @ParameterType);
	PRINT ')'
	PRINT 'AS'
	PRINT 'BEGIN'
	PRINT '';
	PRINT '    SET NOCOUNT ON;'
	PRINT '';
	PRINT '    SELECT'
	SET @Idx = 1; 
	WHILE @Idx <= @QueryMax
	BEGIN
		Select @ColumnName = ColumnName From @QueryColumnsTable WHERE Id = @Idx;
		BEGIN
			PRINT Concat('        ', @ColumnName, (CASE WHEN @Idx < @QueryMax THEN ',' ELSE NULL END));
		END;
		SET @Idx += 1;
	END;
	SELECT @ColumnName = ColumnName From @WhereColumnsTable WHERE IdColumn = 'True';
	PRINT '    FROM';
	PRINT CONCAT('        ', @SourceSchema, '.', @SourceTable);
	PRINT '    WHERE';
	PRINT CONCAT('        ', @ColumnName, ' = @', @ColumnName, ';');
	PRINT '';
	PRINT '    IF @@ROWCOUNT = 0';
	PRINT '    BEGIN';
	PRINT '        --+Return=NotFound';
	PRINT '        RETURN 0;';
	PRINT '    END;';
	PRINT '';
	PRINT '    --+Return=Ok';
	PRINT '    RETURN 1;';
	PRINT '';
	PRINT 'END;';
	PRINT 'GO'
	PRINT ''
	PRINT '------------------------------------------------------------------------------------------------------------------------------';
	PRINT '';
	PRINT '--+SqlPlus'+'Routine';
	PRINT '    --&Author=' + @AuthorName;
	PRINT '    --&Comment=Deletes single row from ' + @SourceSchema +'.'+@SourceTable + ' table by identity column.';
	PRINT '    --&SelectType=NonQuery';
	PRINT '--+SqlPlus'+'Routine';
	PRINT 'CREATE PROCEDURE [' + @DestinationSchema + '].[' + @SourceTable + 'Delete]'
	PRINT '('
	Select @ColumnName = ColumnName, @ParameterType = ParameterType From @StandardColumnsTable WHERE IdColumn = 'True';
	PRINT '    --+Required';
	PRINT '    --+Comment=' + @ColumnName;
	PRINT CONCAT('    @', @ColumnName,' ', @ParameterType);
	PRINT ')'
	PRINT 'AS'
	PRINT 'BEGIN'
	PRINT '';
	PRINT '    SET NOCOUNT ON;'
	PRINT '';
	SELECT @ColumnName = ColumnName From @StandardColumnsTable WHERE IdColumn = 'True';
	PRINT CONCAT('    DELETE FROM ', @SourceSchema, '.', @SourceTable);
	PRINT '    WHERE';
	PRINT CONCAT('        ', @ColumnName, ' = @', @ColumnName, ';');
	PRINT '';
	PRINT '    IF @@ROWCOUNT = 0';
	PRINT '    BEGIN';
	PRINT '        --+Return=NotFound';
	PRINT '        RETURN 0;';
	PRINT '    END;';
	PRINT '';
	PRINT '    --+Return=Ok';
	PRINT '    RETURN 1;';
	PRINT '';
	PRINT 'END;';
	PRINT 'GO'
	PRINT '';
	PRINT '------------------------------------------------------------------------------------------------------------------------------';
	PRINT '';
	PRINT '--+SqlPlus'+'Routine';
	PRINT '    --&Author=' + @AuthorName;
	PRINT '    --&Comment=Queries ' + @SourceSchema +'.'+@SourceTable + ' table.';
	PRINT '    --&SelectType=MultiRow';
	PRINT '--+SqlPlus'+'Routine';
	PRINT 'CREATE PROCEDURE [' + @DestinationSchema + '].[' + @SourceTable + 'Query]'
	PRINT '('
	SET @Idx = 1; 
	WHILE @Idx <= @QueryMax
	BEGIN
		Select @ParameterType = ParameterType, @ColumnName = ColumnName, @IdColumn = IdColumn From @WhereColumnsTable WHERE Id = @Idx;
		IF @IdColumn = 'False'
		BEGIN
		PRINT '    --+Comment=' + @ColumnName
		PRINT CONCAT('    @', @ColumnName,' ', @ParameterType, (CASE WHEN @Idx < @QueryMax THEN ',' ELSE NULL END));
		PRINT '';
		END;
		SET @Idx += 1;
	END;
	PRINT ')'
	PRINT 'AS'
	PRINT 'BEGIN'
	PRINT '';
	PRINT '    SET NOCOUNT ON;'
	PRINT '';
	PRINT '    SELECT'
	SET @Idx = 1; 
	WHILE @Idx <= @QueryMax
	BEGIN
		Select @ColumnName = ColumnName From @QueryColumnsTable WHERE Id = @Idx;
		BEGIN
			PRINT Concat('        ', @ColumnName, (CASE WHEN @Idx < @QueryMax THEN ',' ELSE NULL END));
		END;
		SET @Idx += 1;
	END;
	PRINT '    FROM';
	PRINT CONCAT('        ', @SourceSchema, '.', @SourceTable);
	PRINT '    WHERE';
	SET @Idx = 1; 
	WHILE @Idx <= @WhereMax
	BEGIN
		Select @ColumnName = ColumnName, @IdColumn = IdColumn, @ParameterType = ParameterType From @WhereColumnsTable WHERE Id = @Idx;
		IF @IdColumn = 'false' 
		BEGIN
			IF @ParameterType in ('geometry','geography') BEGIN
				PRINT Concat('        (@', @ColumnName, ' IS NULL OR ', @ColumnName, '.STEquals(@', @ColumnName , ') = 1)', (CASE WHEN @Idx < @WhereMax THEN ' AND' ELSE NULL END));
			END ELSE BEGIN
				PRINT Concat('        (@', @ColumnName, ' IS NULL OR ', @ColumnName, ' = @', @ColumnName , ')', (CASE WHEN @Idx < @WhereMax THEN ' AND' ELSE NULL END));
			END
		END;
		SET @Idx += 1;
	END;
	PRINT '    IF @@ROWCOUNT = 0';
	PRINT '    BEGIN';
	PRINT '        --+Return=NotFound';
	PRINT '        RETURN 0;';
	PRINT '    END;';
	PRINT '';
	PRINT '    --+Return=Ok';
	PRINT '    RETURN 1;';
	PRINT '';
	PRINT 'END;';
	PRINT 'GO';
END
GO
/****** Object:  StoredProcedure [dbo].[ContainerTypesById]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Selects single row from dbo.ContainerTypes table by identity column.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[ContainerTypesById]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        [Name],
        SortOrder,
        IsActive,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.ContainerTypes
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[ContainerTypesDelete]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Deletes single row from dbo.ContainerTypes table by identity column.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[ContainerTypesDelete]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM dbo.ContainerTypes
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[ContainerTypesQuery]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Queries dbo.ContainerTypes table.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[ContainerTypesQuery]
(
    --+Comment=Name
    @Name nvarchar(50),
 
    --+Comment=SortOrder
    @SortOrder int,
 
    --+Comment=IsActive
    @IsActive bit
 
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        [Name],
        SortOrder,
        IsActive,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.ContainerTypes
    WHERE
        (@Name IS NULL OR Name = @Name) AND
        (@SortOrder IS NULL OR SortOrder = @SortOrder) AND
        (@IsActive IS NULL OR IsActive = @IsActive) ;

    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[ContainerTypesUpsert]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Upserts a new record into the dbo.ContainerTypes table.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[ContainerTypesUpsert]
(
    --+Default=null
    --+Comment=Id
    --+InOut
    @Id int = null out,

    --+Required
    --+MaxLength=50
    --+Comment=Name
    --+Default=""
    @Name nvarchar(50),
 
    --+Required
    --+Comment=SortOrder
    --+Default=0
    @SortOrder int,
 
    --+Required
    --+Comment=IsActive
    --+Default=true
    @IsActive bit
 
)
AS
BEGIN
 
    SET NOCOUNT ON;
    DECLARE @CreatedAt datetime2(7) = GETDATE();
    DECLARE @ModifiedAt datetime2(7) = GETDATE();
    IF @Id IS NULL SET @Id=0;
 
    IF @Id IS NULL OR (@Id IS NOT NULL AND @Id = 0)
    BEGIN

        INSERT INTO [dbo].[ContainerTypes]
        (
            [Name],
            SortOrder,
            IsActive,
            CreatedAt,
            ModifiedAt
        )
        VALUES
        (
            @Name,
            @SortOrder,
            @IsActive,
            @CreatedAt,
            @ModifiedAt
        );
 
        SET @Id = scope_identity();

        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=InsertError
            RETURN 2;
        END;

   END
   ELSE
   BEGIN
 
        UPDATE [dbo].[ContainerTypes] SET
            [Name] = @Name,
            SortOrder = @SortOrder,
            IsActive = @IsActive,
            ModifiedAt = @ModifiedAt
        WHERE
            Id = @Id;
 
        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=UpdateError
            RETURN 3;
        END;
    END

    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventoryAreasById]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Selects single row from dbo.InventoryAreas table by identity column.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventoryAreasById]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        Name,
        ShortCode,
        SortOrder,
        IsActive,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.InventoryAreas
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventoryAreasDelete]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Deletes single row from dbo.InventoryAreas table by identity column.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventoryAreasDelete]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM dbo.InventoryAreas
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventoryAreasQuery]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Queries dbo.InventoryAreas table.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventoryAreasQuery]
(
    --+Comment=Name
    --+Default=null
    @Name nvarchar(100) NULL=NULL,
 
    --+Comment=ShortCode
    --+Default=null
    @ShortCode nvarchar(10) NULL=NULL,
 
    --+Comment=IsActive
    --+Default=null
    @IsActive bit NULL=NULL

)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        [Name],
        ShortCode,
        SortOrder,
        IsActive,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.InventoryAreas
    WHERE
        (@Name IS NULL OR [Name] = @Name) AND
        (@ShortCode IS NULL OR ShortCode = @ShortCode) AND
        (@IsActive IS NULL OR IsActive = @IsActive) 
        
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventoryAreasUpsert]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Upserts a new record into the dbo.InventoryAreas table.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventoryAreasUpsert]
(
    
    --+Default=null
    --+Comment=Id
    --+InOut
    @Id int = null out,

    --+Required
    --+MaxLength=100
    --+Default=""    
    --+Comment=Name
    @Name nvarchar(100),
 
    --+Required
    --+MaxLength=10
    --+Comment=ShortCode
    --+Default=""
    @ShortCode nvarchar(10),
 
    --+Required
    --+Comment=SortOrder
    --+Default=0
    @SortOrder int,
 
    --+Required
    --+Comment=IsActive
    --+Default=true
    @IsActive bit
 
)
AS
BEGIN
 
    SET NOCOUNT ON;

    DECLARE @CreatedAt datetime2(7) = GETDATE(),  @ModifiedAt datetime2(7)=GETDATE();
    IF @Id IS NULL OR (@Id IS NOT NULL AND @Id = 0)
    BEGIN
 
        INSERT INTO [dbo].[InventoryAreas]
        (
            Name,
            ShortCode,
            SortOrder,
            IsActive,
            CreatedAt,
            ModifiedAt
        )
        VALUES
        (
            @Name,
            @ShortCode,
            @SortOrder,
            @IsActive,
            @CreatedAt,
            @ModifiedAt
        );
 
        SET @Id = scope_identity();

        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=InsertError
            RETURN 2;
        END;

    END
    ELSE
    BEGIN
    
        UPDATE [dbo].[InventoryAreas] SET
            Name = @Name,
            ShortCode = @ShortCode,
            SortOrder = @SortOrder,
            IsActive = @IsActive,
            ModifiedAt = @ModifiedAt
        WHERE
            Id = @Id
 
        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=UpdateError
            RETURN 3;
        END;
     END

    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventoryFrequenciesById]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Selects single row from dbo.InventoryFrequencies table by identity column.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventoryFrequenciesById]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        [Name],
        SortOrder,
        IsActive,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.InventoryFrequencies
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventoryFrequenciesDelete]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Deletes single row from dbo.InventoryFrequencies table by identity column.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventoryFrequenciesDelete]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM dbo.InventoryFrequencies
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventoryFrequenciesQuery]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Queries dbo.InventoryFrequencies table.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventoryFrequenciesQuery]
(
    --+Comment=Name
    @Name nvarchar(50) NULL=NULL,
 
    --+Comment=SortOrder
    @SortOrder int NULL=NULL,
 
    --+Comment=IsActive
    @IsActive bit NULL=NULL
 
)
AS
BEGIN
 
    SET NOCOUNT ON;

    IF @Name IS NOT NULL AND @Name='' SET @Name=NULL;
 
    SELECT
        Id,
        [Name],
        SortOrder,
        IsActive,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.InventoryFrequencies
    WHERE
        (@Name IS NULL OR Name = @Name) AND
        (@SortOrder IS NULL OR SortOrder = @SortOrder) AND
        (@IsActive IS NULL OR IsActive = @IsActive);

    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventoryFrequenciesUpsert]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Upserts a new record into the dbo.InventoryFrequencies table.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventoryFrequenciesUpsert]
(
    --+Default=null
    --+Comment=Id
    --+InOut
    @Id int = null out,

    --+Required
    --+MaxLength=50
    --+Comment=Name
    --+Default=""
    @Name nvarchar(50),
 
    --+Required
    --+Comment=SortOrder
    --+Default=0
    @SortOrder int,
 
    --+Required
    --+Comment=IsActive
    --+Default=true
    @IsActive bit
 
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DECLARE @CreatedAt datetime2(7) = GETDATE();
    DECLARE @ModifiedAt datetime2(7) = GETDATE();
    IF @Id IS NULL OR (@Id IS NOT NULL AND @Id = 0)
    BEGIN

        INSERT INTO [dbo].[InventoryFrequencies]
        (
            [Name],
            SortOrder,
            IsActive,
            CreatedAt,
            ModifiedAt
        )
        VALUES
        (
            @Name,
            @SortOrder,
            @IsActive,
            @CreatedAt,
            @ModifiedAt
        );
 
        SET @Id = scope_identity();

        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=InsertError
            RETURN 2;
        END;

    END
    ELSE
    BEGIN

        UPDATE [dbo].[InventoryFrequencies] SET
            [Name] = @Name,
            SortOrder = @SortOrder,
            IsActive = @IsActive,
            CreatedAt = @CreatedAt,
            ModifiedAt = @ModifiedAt
        WHERE
            Id = @Id;
 
        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=UpdateError
            RETURN 3;
        END

    END 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventoryItemsById]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Selects single row from dbo.InventoryItems table by identity column.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventoryItemsById]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        SessionId,
        ProductId,
        UnitCost,
        StartingQuantity,
        ReceivedQuantity,
        ReceivedCost,
        ComputerSold,
        CreditedProduct,
        LastCountedAt,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.InventoryItems
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventoryItemsDelete]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Deletes single row from dbo.InventoryItems table by identity column.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventoryItemsDelete]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM dbo.InventoryItems
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventoryItemsQuery]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Queries dbo.InventoryItems table.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventoryItemsQuery]
(
    --+Comment=SessionId
    --+Default=null
    @SessionId int NULL=NULL,
 
    --+Comment=ProductId
    --+Default=null
    @ProductId int NULL=NULL
 

 
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        SessionId,
        ProductId,
        UnitCost,
        StartingQuantity,
        ReceivedQuantity,
        ReceivedCost,
        ComputerSold,
        CreditedProduct,
        LastCountedAt,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.InventoryItems
    WHERE
        (@SessionId IS NULL OR SessionId = @SessionId) AND
        (@ProductId IS NULL OR ProductId = @ProductId) 
      
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventoryItemsUpsert]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Upserts a new record into the dbo.InventoryItems table.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventoryItemsUpsert]
(
    
    --+Comment=Id
    --+Default=null
    --+InOut
    @Id int = null out,
 
    --+Required
    --+Comment=SessionId
    --+Default=0
    @SessionId int,
 
    --+Required
    --+Comment=ProductId
    --+Default=0
    @ProductId int,
 
    --+Required
    --+Comment=UnitCost
    --+Default=0
    @UnitCost decimal(10,2),
 
    --+Required
    --+Comment=StartingQuantity
    --+Default=0
    @StartingQuantity decimal(10,2),
 
    --+Required
    --+Comment=ReceivedQuantity
    --+Default=0
    @ReceivedQuantity decimal(10,2),
 
    --+Required
    --+Comment=ReceivedCost
    --+Default=0
    @ReceivedCost decimal(10,2),
 
    --+Required
    --+Comment=ComputerSold
    --+Default=0
    @ComputerSold decimal(10,2),
 
    --+Required
    --+Comment=CreditedProduct
    --+Default=0
    @CreditedProduct decimal(10,2),
 
    --+Comment=LastCountedAt
    --+Default=null
    @LastCountedAt datetime2(7) NULL=NULL
)
AS
BEGIN
 
    SET NOCOUNT ON;
    DECLARE @CreatedAt datetime2(7) = GETDATE();
    DECLARE @ModifiedAt datetime2(7) = GETDATE();
    IF @Id IS NULL OR (@Id IS NOT NULL AND @Id = 0)
    BEGIN

        INSERT INTO [dbo].[InventoryItems]
        (
            SessionId,
            ProductId,
            UnitCost,
            StartingQuantity,
            ReceivedQuantity,
            ReceivedCost,
            ComputerSold,
            CreditedProduct,
            LastCountedAt,
            CreatedAt,
            ModifiedAt
        )
        VALUES
        (
            @SessionId,
            @ProductId,
            @UnitCost,
            @StartingQuantity,
            @ReceivedQuantity,
            @ReceivedCost,
            @ComputerSold,
            @CreditedProduct,
            @LastCountedAt,
            @CreatedAt,
            @ModifiedAt
        );
 
        SET @Id = scope_identity();
        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=InsertError
            RETURN 2;
        END;

    END
    ELSE
    BEGIN
 
        UPDATE [dbo].[InventoryItems] SET
            SessionId = @SessionId,
            ProductId = @ProductId,
            UnitCost = @UnitCost,
            StartingQuantity = @StartingQuantity,
            ReceivedQuantity = @ReceivedQuantity,
            ReceivedCost = @ReceivedCost,
            ComputerSold = @ComputerSold,
            CreditedProduct = @CreditedProduct,
            LastCountedAt = @LastCountedAt,
            ModifiedAt = @ModifiedAt
        WHERE
            Id = @Id
 
        IF @@ROWCOUNT = 3
        BEGIN
            --+Return=UpdateError
            RETURN 0;
        END;

    END
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventorySessionsById]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Selects single row from dbo.InventorySessions table by identity column.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventorySessionsById]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        SessionName,
        SessionDate,
        CompletedAt,
        Frequency,
        Notes,
        IsComplete,
        CountedBy,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.InventorySessions
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventorySessionsDelete]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Deletes single row from dbo.InventorySessions table by identity column.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventorySessionsDelete]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM dbo.InventorySessions
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventorySessionsQuery]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Queries dbo.InventorySessions table.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventorySessionsQuery]
(
    --+Comment=SessionName
    --+Default=null
    @SessionName nvarchar(200) NULL=NULL,
 
    --+Comment=IsComplete
    --+Default=null
    @IsComplete bit NULL=NULL,
 
    --+Comment=CountedBy
    --+Default=null
    @CountedBy nvarchar(100) NULL=NULL
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        SessionName,
        SessionDate,
        CompletedAt,
        Frequency,
        Notes,
        IsComplete,
        CountedBy,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.InventorySessions
    WHERE
        (@SessionName IS NULL OR SessionName = @SessionName) AND
        (@IsComplete IS NULL OR IsComplete = @IsComplete) AND
        (@CountedBy IS NULL OR CountedBy = @CountedBy);
    
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[InventorySessionsUpsert]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Upserts a new record into the dbo.InventorySessions table.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[InventorySessionsUpsert]
(
    
    --+Comment=Id
    --+Default=null
    --+InOut
    @Id int = null out,
 
    --+Required
    --+MaxLength=200
    --+Comment=SessionName
    --+Default=""
    @SessionName nvarchar(200),
 
    --+Required
    --+Comment=SessionDate
    --+Default=System.DateTime.Now
    @SessionDate datetime2(7),
 
    --+Comment=CompletedAt
    --+Default=null
    @CompletedAt datetime2(7),
 
    --+Required
    --+Comment=Frequency
    --+Default=0
    @Frequency int,
 
    --+Comment=Notes
    --+Default=null
    @Notes nvarchar(MAX),
 
    --+Required
    --+Comment=IsComplete
    --+Default=true
    @IsComplete bit,
 
    --+Required
    --+MaxLength=100
    --+Comment=CountedBy
    @CountedBy nvarchar(100)
 
)
AS
BEGIN
 
    SET NOCOUNT ON;
    DECLARE @CreatedAt datetime2(7) = GETDATE();
    DECLARE @ModifiedAt datetime2(7) = GETDATE();
    IF @Id IS NULL OR (@Id IS NOT NULL AND @Id = 0)
    BEGIN

 
        INSERT INTO [dbo].[InventorySessions]
        (
            SessionName,
            SessionDate,
            CompletedAt,
            Frequency,
            Notes,
            IsComplete,
            CountedBy,
            CreatedAt,
            ModifiedAt
        )
        VALUES
        (
            @SessionName,
            @SessionDate,
            @CompletedAt,
            @Frequency,
            @Notes,
            @IsComplete,
            @CountedBy,
            @CreatedAt,
            @ModifiedAt
        );
 
        SET @Id = scope_identity();
        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=InsertError
            RETURN 2;
        END;
    END
    ELSE
    BEGIN
 
        UPDATE [dbo].[InventorySessions] SET
            SessionName = @SessionName,
            SessionDate = @SessionDate,
            CompletedAt = @CompletedAt,
            Frequency = @Frequency,
            Notes = @Notes,
            IsComplete = @IsComplete,
            CreatedAt = @CreatedAt,
            ModifiedAt = @ModifiedAt
        WHERE
            Id = @Id
 
        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=UpdateError
            RETURN 3;
        END;
    END
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[LossRecordsById]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Selects single row from dbo.LossRecords table by identity column.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[LossRecordsById]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        SessionId,
        ProductId,
        LossType,
        Quantity,
        EstimatedValue,
        Reason,
        RecordedBy,
        OccurredAt,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.LossRecords
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[LossRecordsDelete]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Deletes single row from dbo.LossRecords table by identity column.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[LossRecordsDelete]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM dbo.LossRecords
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[LossRecordsQuery]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Queries dbo.LossRecords table.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[LossRecordsQuery]
(
    --+Comment=SessionId
    --+Default=null
    @SessionId int NULL=NULL,
 
    --+Comment=ProductId
    --+Default=null
    @ProductId int NULL=NULL,
 
    --+Comment=LossType
    --+Default=null
    @LossType int NULL=NULL
 
   
 
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        SessionId,
        ProductId,
        LossType,
        Quantity,
        EstimatedValue,
        Reason,
        RecordedBy,
        OccurredAt,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.LossRecords
    WHERE
        (@SessionId IS NULL OR SessionId = @SessionId) AND
        (@ProductId IS NULL OR ProductId = @ProductId) AND
        (@LossType IS NULL OR LossType = @LossType);

    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[LossRecordsUpsert]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Upserts a new record into the dbo.LossRecords table.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[LossRecordsUpsert]
(
    --+Comment=Id
    --+Default=null
    --+InOut
    @Id int = null out,
 
    --+Required
    --+Comment=SessionId
    --+Default=0
    @SessionId int,
 
    --+Required
    --+Comment=ProductId
    --+Default=0
    @ProductId int,
 
    --+Required
    --+Comment=LossType
    --+Default=0
    @LossType int,
 
    --+Required
    --+Comment=Quantity
    @Quantity decimal(10,2),
 
    --+Required
    --+Comment=EstimatedValue
    @EstimatedValue decimal(10,2),
 
    --+MaxLength=500
    --+Comment=Reason
    --+Default=null
    @Reason nvarchar(500),
 
    --+MaxLength=100
    --+Comment=RecordedBy
    --+Default=null
    @RecordedBy nvarchar(100),
 
    --+Required
    --+Comment=OccurredAt
    --+Default=System.DateTime.Now
    @OccurredAt datetime2(7)
 
)
AS
BEGIN
 
    SET NOCOUNT ON;
    
    DECLARE @CreatedAt datetime2(7) = GETDATE();
    DECLARE @ModifiedAt datetime2(7) = GETDATE()
 
    IF @Id IS NULL OR (@Id IS NOT NULL AND @Id = 0)
    BEGIN

        INSERT INTO [dbo].[LossRecords]
        (
            SessionId,
            ProductId,
            LossType,
            Quantity,
            EstimatedValue,
            Reason,
            RecordedBy,
            OccurredAt,
            CreatedAt,
            ModifiedAt
        )
        VALUES
        (
            @SessionId,
            @ProductId,
            @LossType,
            @Quantity,
            @EstimatedValue,
            @Reason,
            @RecordedBy,
            @OccurredAt,
            @CreatedAt,
            @ModifiedAt
        );
 
        SET @Id = scope_identity();

        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=InsertError
            RETURN 2;
        END;

    END
    ELSE
    BEGIN
 
        UPDATE [dbo].[LossRecords] SET
            SessionId = @SessionId,
            ProductId = @ProductId,
            LossType = @LossType,
            Quantity = @Quantity,
            EstimatedValue = @EstimatedValue,
            Reason = @Reason,
            RecordedBy = @RecordedBy,
            OccurredAt = @OccurredAt,
            ModifiedAt = @ModifiedAt
        WHERE
            Id = @Id;
 
        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=UpdateError
            RETURN 3;
        END;
    END
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[LossTypesById]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Selects single row from dbo.LossTypes table by identity column.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[LossTypesById]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        [Name],
        SortOrder,
        IsActive,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.LossTypes
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[LossTypesDelete]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Deletes single row from dbo.LossTypes table by identity column.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[LossTypesDelete]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM dbo.LossTypes
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[LossTypesQuery]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Queries dbo.LossTypes table.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[LossTypesQuery]
(
    --+Comment=Name
    --+Default=null
    @Name nvarchar(50) NULL=NULL,
 
    --+Comment=SortOrder
    --+Default=null
    @SortOrder int NULL=NULL,
 
    --+Comment=IsActive
    --+Default=null
    @IsActive bit NULL=NULL
 
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        [Name],
        SortOrder,
        IsActive,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.LossTypes
    WHERE
        (@Name IS NULL OR Name = @Name) AND
        (@SortOrder IS NULL OR SortOrder = @SortOrder) AND
        (@IsActive IS NULL OR IsActive = @IsActive);

    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[LossTypesUpsert]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Upserts a new record into the dbo.LossTypes table.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[LossTypesUpsert]
(

    --+Comment=Id
    --+Default=null
    --+InOut
    @Id int = null out,
 
    --+Required
    --+MaxLength=50
    --+Comment=Name
    --+Default=""
    @Name nvarchar(50),
 
    --+Required
    --+Comment=SortOrder
    --+Default=0
    @SortOrder int,
 
    --+Required
    --+Comment=IsActive
    --+Default=true
    @IsActive bit
)
AS
BEGIN
 
    SET NOCOUNT ON;
    DECLARE @CreatedAt datetime2(7) = GETDATE(),  @ModifiedAt datetime2(7)=GETDATE();
    
    IF @Id IS NULL OR (@Id IS NOT NULL AND @Id = 0)
    BEGIN
 
        INSERT INTO [dbo].[LossTypes]
        (
            [Name],
            SortOrder,
            IsActive,
            CreatedAt,
            ModifiedAt
        )
        VALUES
        (
            @Name,
            @SortOrder,
            @IsActive,
            @CreatedAt,
            @ModifiedAt
        );
 
        SET @Id = scope_identity();
        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=InsertError
            RETURN 2;
        END;

    END
    ELSE
    BEGIN 
        UPDATE [dbo].[LossTypes] SET
            [Name] = @Name,
            SortOrder = @SortOrder,
            IsActive = @IsActive,
            ModifiedAt = @ModifiedAt
        WHERE
            Id = @Id
 
        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=UpdateError
            RETURN 3;
        END;
    END

    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[ProductCategoriesById]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Selects single row from dbo.ProductCategories table by identity column.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[ProductCategoriesById]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        Name,
        SortOrder,
        IsActive,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.ProductCategories
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[ProductCategoriesDelete]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Deletes single row from dbo.ProductCategories table by identity column.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[ProductCategoriesDelete]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM dbo.ProductCategories
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[ProductCategoriesQuery]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Queries dbo.ProductCategories table.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[ProductCategoriesQuery]
(
    --+Comment=Name
    --+Default=null
    @Name nvarchar(50) NULL=NULL,
 
    --+Comment=SortOrder
    --+Default=null
    @SortOrder int NULL=NULL,
 
    --+Comment=IsActive
    --+Default=null
    @IsActive bit NULL=NULL
 
)
AS
BEGIN
 
    SET NOCOUNT ON;
    IF @Name IS NOT NULL AND @Name='' SET @Name=NULL;
 
    SELECT
        Id,
        Name,
        SortOrder,
        IsActive,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.ProductCategories
    WHERE
        (@Name IS NULL OR Name = @Name) AND
        (@SortOrder IS NULL OR SortOrder = @SortOrder) AND
        (@IsActive IS NULL OR IsActive = @IsActive);

    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[ProductCategoriesUpsert]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Upserts a new record into the dbo.ProductCategories table.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[ProductCategoriesUpsert]
(
    --+Comment=Id
    --+Default=null
    --+InOut
    @Id int = null out,
 
    --+Required
    --+MaxLength=50
    --+Comment=Name
    --+Default=""
    @Name nvarchar(50),
 
    --+Required
    --+Comment=SortOrder
    --+Default=0
    @SortOrder int,
 
    --+Required
    --+Comment=IsActive
    --+Default=true
    @IsActive bit
 
 
)
AS
BEGIN
 
    SET NOCOUNT ON;
    DECLARE @CreatedAt datetime2(7) = GETDATE();
    DECLARE @ModifiedAt datetime2(7) = GETDATE();
    IF @Id IS NULL OR (@Id IS NOT NULL AND @Id = 0)
    BEGIN

        INSERT INTO [dbo].[ProductCategories]
        (
            [Name],
            SortOrder,
            IsActive,
            CreatedAt,
            ModifiedAt
        )
        VALUES
        (
            @Name,
            @SortOrder,
            @IsActive,
            @CreatedAt,
            @ModifiedAt
        );
 
        SET @Id = scope_identity();
        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=InsertError
            RETURN 2;
        END;

    END
    ELSE
        BEGIN
        UPDATE [dbo].[ProductCategories] SET
            Name = @Name,
            SortOrder = @SortOrder,
            IsActive = @IsActive,
            ModifiedAt = @ModifiedAt
        WHERE
            Id = @Id;
 
        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=UpdateError
            RETURN 3;
        END;
    END
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[ProductsById]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Selects single row from dbo.Products table by identity column.
    --&SelectType=SingleRow
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[ProductsById]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        Name,
        Brand,
        Category,
        ContainerType,
        SizeDescription,
        UnitCost,
        UnitPrice,
        ServingsPerUnit,
        Barcode,
        Sku,
        IsActive,
        SortOrder,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.Products
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[ProductsDelete]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Deletes single row from dbo.Products table by identity column.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE PROCEDURE [dbo].[ProductsDelete]
(
    --+Required
    --+Comment=Id
    @Id int
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    DELETE FROM dbo.Products
    WHERE
        Id = @Id;
 
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[ProductsQuery]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

------------------------------------------------------------------------------------------------------------------------------
 
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Queries dbo.Products table.
    --&SelectType=MultiRow
--+SqlPlusRoutine
CREATE   PROCEDURE [dbo].[ProductsQuery]
(
    --+Comment=Name
    --+Default=null
    @Name nvarchar(200) NULL=NULL,
 
    --+Comment=Brand
    --+Default=null
    @Brand nvarchar(200) NULL=NULL,
 
    --+Comment=Category
    --+Default=null
    @Category int NULL=NULL,
 
    --+Comment=ContainerType
    --+Default=null
    @ContainerType int NULL=NULL,
 
    --+Comment=Barcode
    --+Default=null
    @Barcode nvarchar(50) NULL=NULL,
 
    --+Comment=Sku
    --+Default=null
    @Sku nvarchar(50) NULL=NULL,
 
    --+Comment=IsActive
    --+Default=null
    @IsActive bit NULL=NULL
 
    
)
AS
BEGIN
 
    SET NOCOUNT ON;
 
    SELECT
        Id,
        Name,
        Brand,
        Category,
        ContainerType,
        SizeDescription,
        UnitCost,
        UnitPrice,
        ServingsPerUnit,
        Barcode,
        Sku,
        IsActive,
        SortOrder,
        CreatedAt,
        ModifiedAt
    FROM
        dbo.Products
    WHERE
        (@Name IS NULL OR Name = @Name) AND
        (@Brand IS NULL OR Brand = @Brand) AND
        (@Category IS NULL OR Category = @Category) AND
        (@ContainerType IS NULL OR ContainerType = @ContainerType) AND
        (@Barcode IS NULL OR Barcode = @Barcode) AND
        (@Sku IS NULL OR Sku = @Sku) AND
        (@IsActive IS NULL OR IsActive = @IsActive);
    IF @@ROWCOUNT = 0
    BEGIN
        --+Return=NotFound
        RETURN 0;
    END;
 
    --+Return=Ok
    RETURN 1;
 
END;
GO
/****** Object:  StoredProcedure [dbo].[ProductsUpsert]    Script Date: 12/27/2025 2:48:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--+SqlPlusRoutine
    --&Author=Kirk Barrett
    --&Comment=Upserts a new record into the dbo.Products table.
    --&SelectType=NonQuery
--+SqlPlusRoutine
CREATE    PROCEDURE [dbo].[ProductsUpsert]
(

    --+Comment=Id
    --+Default=null
    --+InOut
    @Id int = null out,
 
    --+Required
    --+MaxLength=200
    --+Comment=Name
    --+Default=""
    @Name nvarchar(200),
 
    --+Required
    --+MaxLength=200
    --+Comment=Brand
    --+Default=""
    @Brand nvarchar(200),
 
    --+Required
    --+Comment=Category
    --+Default=1
    @Category int,
 
    --+Required
    --+Comment=ContainerType
    --+Default=0
    @ContainerType int,
 
    --+Required
    --+MaxLength=50
    --+Comment=SizeDescription
    --+Default=""
    @SizeDescription nvarchar(50),
 
    --+Required
    --+Comment=UnitCost
    --+Default=0
    @UnitCost decimal(10,2),
 
    --+Required
    --+Comment=UnitPrice
    --+Default=0
    @UnitPrice decimal(10,2),
 
    --+Comment=ServingsPerUnit
    --+Default=0
    @ServingsPerUnit decimal(10,2),
 
    --+MaxLength=50
    --+Comment=Barcode
    --+Default=null
    @Barcode nvarchar(50),
 
    --+MaxLength=50
    --+Comment=Sku
    --+Default=null
    @Sku nvarchar(50),
 
    --+Required
    --+Comment=IsActive
    --+Default=true
    @IsActive bit,
 
    --+Required
    --+Comment=SortOrder
    --+Default=0
    @SortOrder int
 
    
 
)
AS
BEGIN
 
    SET NOCOUNT ON;
    
    DECLARE @CreatedAt datetime2(7) = GETDATE();
    DECLARE @ModifiedAt datetime2(7) = GETDATE()
    
    IF @Id IS NULL OR (@Id IS NOT NULL AND @Id = 0)
    BEGIN
 
        INSERT INTO [dbo].[Products]
        (
            [Name],
            Brand,
            Category,
            ContainerType,
            SizeDescription,
            UnitCost,
            UnitPrice,
            ServingsPerUnit,
            Barcode,
            Sku,
            IsActive,
            SortOrder,
            CreatedAt,
            ModifiedAt
        )
        VALUES
        (
            @Name,
            @Brand,
            @Category,
            @ContainerType,
            @SizeDescription,
            @UnitCost,
            @UnitPrice,
            @ServingsPerUnit,
            @Barcode,
            @Sku,
            @IsActive,
            @SortOrder,
            @CreatedAt,
            @ModifiedAt
        );
 
        SET @Id = scope_identity();
        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=InsertError
            RETURN 2;
        END;

    END
    ELSE
    BEGIN
        UPDATE [dbo].[Products] SET
            [Name] = @Name,
            Brand = @Brand,
            Category = @Category,
            ContainerType = @ContainerType,
            SizeDescription = @SizeDescription,
            UnitCost = @UnitCost,
            UnitPrice = @UnitPrice,
            ServingsPerUnit = @ServingsPerUnit,
            Barcode = @Barcode,
            Sku = @Sku,
            IsActive = @IsActive,
            SortOrder = @SortOrder,
            ModifiedAt = @ModifiedAt
        WHERE
            Id = @Id;
 
        IF @@ROWCOUNT = 0
        BEGIN
            --+Return=UpdateError
            RETURN 3;
        END;
    END 

    --+Return=Ok
    RETURN 1;
 
END;
GO
USE [master]
GO
ALTER DATABASE [BarInventory] SET  READ_WRITE 
GO
