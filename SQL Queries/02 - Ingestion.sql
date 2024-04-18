BULK INSERT IISLOGStaging
FROM 'C:\temp\fakeIISLog.txt'
WITH(
	FIELDTERMINATOR = ' ',  -- Field delimiter
	ROWTERMINATOR = '\n',   -- Row delimiter
	FIRSTROW = 1            -- If you have a header row, this should be 2
);


INSERT INTO [dbo].[IISLOG]
           ([DATE]
           ,[TIME]
           ,[clientIp]
           ,[HttpMethod]
           ,[HttpUri]
           ,[HttpStatus]
           ,[HttpResponseSize]
           ,[TimeTaken]
           ,[clientUserAgent])
     Select [DATE]
           ,[TIME]
           ,[clientIp]
           ,[HttpMethod]
           ,[HttpUri]
           ,[HttpStatus]
           ,[HttpResponseSize]
           ,[TimeTaken]
           ,[clientUserAgent] from IISLOGStaging
GO

delete from IISLOGStaging