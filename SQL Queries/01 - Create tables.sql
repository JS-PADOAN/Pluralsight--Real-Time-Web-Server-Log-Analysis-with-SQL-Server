USE [pluralsightDemo]
GO

/****** Object:  Table [dbo].[IISLOGStaging]    Script Date: 4/18/2024 10:31:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[IISLOGStaging](
	[DATE] [date] NULL,
	[TIME] [time](7) NULL,
	[clientIp] [varchar](48) NULL,
	[HttpMethod] [varchar](8) NULL,
	[HttpUri] [varchar](255) NULL,
	[HttpStatus] [int] NULL,
	[HttpResponseSize] [int] NULL,
	[TimeTaken] [int] NULL,
	[clientUserAgent] [varchar](1024) NULL
) ON [PRIMARY]
GO




USE [pluralsightDemo]
GO

/****** Object:  Table [dbo].[IISLOG]    Script Date: 4/18/2024 10:30:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[IISLOG](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DATE] [date] NULL,
	[TIME] [time](7) NULL,
	[clientIp] [varchar](48) NULL,
	[HttpMethod] [varchar](8) NULL,
	[HttpUri] [varchar](255) NULL,
	[HttpStatus] [int] NULL,
	[HttpResponseSize] [int] NULL,
	[TimeTaken] [int] NULL,
	[clientUserAgent] [varchar](1024) NULL,
 CONSTRAINT [PK_IISLOG] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

