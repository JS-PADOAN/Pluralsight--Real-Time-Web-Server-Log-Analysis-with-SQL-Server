

-- Number of Visits per Day
SELECT [DATE], COUNT(*) AS NumberOfVisits
FROM dbo.IISLOG
GROUP BY [DATE]
ORDER BY [DATE];

-- Most Popular Pages
SELECT [HttpUri], COUNT(*) AS Visits
FROM dbo.IISLOG
GROUP BY [HttpUri]
ORDER BY Visits DESC;

-- Peak Traffic Times
SELECT [TIME], COUNT(*) AS NumberOfVisits
FROM dbo.IISLOG
GROUP BY [TIME]
ORDER BY NumberOfVisits DESC;


SELECT 
    CAST([DATE] AS DATETIME) + DATEADD(MINUTE, (DATEPART(HOUR, [TIME]) * 60 + DATEPART(MINUTE, [TIME])) / 10 * 10, 0) AS TimeWindow,
    COUNT(*) AS NumberOfVisits
FROM dbo.IISLOG
GROUP BY 
    CAST([DATE] AS DATETIME) + DATEADD(MINUTE, (DATEPART(HOUR, [TIME]) * 60 + DATEPART(MINUTE, [TIME])) / 10 * 10, 0)
ORDER BY NumberOfVisits DESC;




-- Unique Visitors per Day
SELECT [DATE], COUNT(DISTINCT clientIp) AS UniqueVisitors
FROM dbo.IISLOG
GROUP BY [DATE]
ORDER BY [DATE];













-- Status Code Distribution
SELECT [HttpStatus], COUNT(*) AS NumberOfRequests
FROM dbo.IISLOG
GROUP BY [HttpStatus]
ORDER BY NumberOfRequests DESC;



-- Traffic Source Analysis
SELECT [clientIp], COUNT(*) AS NumberOfVisits
FROM dbo.IISLOG
GROUP BY [clientIp]
ORDER BY NumberOfVisits DESC;

-- Performance Metrics
SELECT 
  AVG([HttpResponseSize]) AS AvgResponseSize,
  AVG([TimeTaken]) AS AvgTimeTaken
FROM dbo.IISLOG;


SELECT 
  [DATE],
  AVG([HttpResponseSize]) AS AvgResponseSize,
  AVG([TimeTaken]) AS AvgTimeTaken
FROM dbo.IISLOG
GROUP BY [DATE]
ORDER BY [DATE];









-- Bounce Rate

-- Step 1: Identify sessions with a single request (potential bounces)
WITH SessionCounts AS (
  SELECT 
    clientIp, 
    [DATE], 
    COUNT(*) AS PageViews
  FROM dbo.IISLOG
  GROUP BY clientIp, [DATE]
),
Bounces AS (
  SELECT 
    [DATE], 
    COUNT(*) AS BounceCount
  FROM SessionCounts
  WHERE PageViews = 1
  GROUP BY [DATE]
),
TotalSessions AS (
  SELECT 
    [DATE], 
    COUNT(*) AS TotalSessionCount
  FROM SessionCounts
  GROUP BY [DATE]
)
-- Step 2: Calculate bounce rate
SELECT 
  TotalSessions.[DATE], 
  CAST(BounceCount AS FLOAT) / TotalSessionCount AS BounceRate
FROM TotalSessions
JOIN Bounces ON TotalSessions.[DATE] = Bounces.[DATE]
ORDER BY TotalSessions.[DATE];











-- New vs Returning Visitors

-- Step 1: Flag each visit as new or returning
WITH VisitorStatus AS (
  SELECT 
    clientIp, 
    [DATE],
    CASE 
      WHEN MIN([DATE]) OVER (PARTITION BY clientIp) = [DATE] THEN 'New'
      ELSE 'Returning'
    END AS VisitorType
  FROM dbo.IISLOG
)
-- Step 2: Count new and returning visits per day
SELECT 
  [DATE], 
  SUM(CASE WHEN VisitorType = 'New' THEN 1 ELSE 0 END) AS NewVisitors,
  SUM(CASE WHEN VisitorType = 'Returning' THEN 1 ELSE 0 END) AS ReturningVisitors
FROM VisitorStatus
GROUP BY [DATE]
ORDER BY [DATE];
