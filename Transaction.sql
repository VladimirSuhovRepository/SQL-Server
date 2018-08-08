DECLARE @SearchHistoryLastId INT = 16000000;
DECLARE @AccessHistoryLastId INT = 16000000;
DECLARE @UpdateFrame INT = 100000;


DECLARE @StartUpdateId INT;
DECLARE @EndUpdateId INT;


SET @EndUpdateId = @AccessHistoryLastId;
SET @StartUpdateId = @AccessHistoryLastId - @UpdateFrame;

WHILE (@EndUpdateId > 0)
BEGIN

	BEGIN TRY

		BEGIN TRANSACTION

  			PRINT FORMATMESSAGE('Start update AccessHistory Ids > %d and <= %d', @StartUpdateId, @EndUpdateId);
		
			UPDATE [dbo].[AccessHistory]
			SET [RequestTime] = ([RequestTime] AT TIME ZONE 'Mountain Standard Time') AT TIME ZONE 'UTC'
			WHERE [Id] > @StartUpdateId AND [Id] <= @EndUpdateId;

			SET @EndUpdateId = @EndUpdateId - @UpdateFrame;
			SET @StartUpdateId = @StartUpdateId - @UpdateFrame;

		COMMIT TRANSACTION

	END TRY

	BEGIN CATCH 

		ROLLBACK TRANSACTION 
		PRINT 'Error detected, all changes reversed'

		SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage
	END CATCH

END



SET @EndUpdateId = @SearchHistoryLastId;
SET @StartUpdateId = @SearchHistoryLastId - @UpdateFrame;

WHILE (@EndUpdateId > 0)
BEGIN

	BEGIN TRY

		BEGIN TRANSACTION

  			PRINT FORMATMESSAGE('Start update SearchHistory Ids > %d and <= %d', @StartUpdateId, @EndUpdateId);
		
			UPDATE [dbo].[SearchHistory]
			SET [RequestTime] = ([RequestTime] AT TIME ZONE 'Mountain Standard Time') AT TIME ZONE 'UTC',
			[ResponseTime] = ([ResponseTime] AT TIME ZONE 'Mountain Standard Time') AT TIME ZONE 'UTC'
			WHERE [Id] > @StartUpdateId AND [Id] <= @EndUpdateId;

			SET @EndUpdateId = @EndUpdateId - @UpdateFrame;
			SET @StartUpdateId = @StartUpdateId - @UpdateFrame;

		COMMIT TRANSACTION

	END TRY

	BEGIN CATCH 

		ROLLBACK TRANSACTION 
		PRINT 'Error detected, all changes reversed'

		SELECT
		ERROR_NUMBER() AS ErrorNumber,
		ERROR_SEVERITY() AS ErrorSeverity,
		ERROR_STATE() AS ErrorState,
		ERROR_PROCEDURE() AS ErrorProcedure,
		ERROR_LINE() AS ErrorLine,
		ERROR_MESSAGE() AS ErrorMessage
	END CATCH

END
