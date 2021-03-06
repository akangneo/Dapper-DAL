USE [DapperDalDb]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 05/31/2013 00:23:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](64) NOT NULL,
	[Description] [nvarchar](512) NULL,
	[Address] [nvarchar](128) NULL,
	[Zip] [nvarchar](5) NULL,
	[Balance] [decimal](15, 2) NULL,
	[Registered] [datetime] NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[spCustomerListByPageGet]    Script Date: 05/31/2013 00:23:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[spCustomerListByPageGet](@startIndex INT, @endIndex INT, @count INT OUT)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @tab TABLE (Id INT)
	
	SET @Count = (
	        SELECT COUNT(Id)
	        FROM   dbo.Customer
	    );
	
	WITH CustomerCTE(Id, RowNumber) AS 
	(
	    SELECT c.Id AS Id,
	           ROW_NUMBER() OVER(ORDER BY c.Registered DESC, c.Id) AS 'RowNumber'
	    FROM   dbo.Customer c
	)
	INSERT INTO @tab
	SELECT Id
	FROM   CustomerCTE
	WHERE  RowNumber BETWEEN @startIndex AND @endIndex		
	
	SELECT c.[Id]
      ,c.[Name]
      ,c.[Description]
      ,c.[Address]
      ,c.[Zip]
      ,c.[Balance]
      ,c.[Registered]
	FROM   dbo.Customer      c,
	       @tab subTable
	WHERE  c.Id = subTable.Id
END
GO
