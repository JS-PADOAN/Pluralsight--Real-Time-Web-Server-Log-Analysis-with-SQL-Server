-- Performance analysis
WITH WeeklyPerformance AS (
  SELECT 
    DATEPART(week, [DATE]) AS WeekOfYear, 
    AVG([TimeTaken]) AS AverageResponseTime 
  FROM 
    dbo.IISLOG 
  GROUP BY 
    DATEPART(week, [DATE])
)
SELECT 
  CURRENTdata.WeekOfYear, 
  CURRENTdata.AverageResponseTime AS CurrentWeekAvgTime, 
  PREVIOUS.AverageResponseTime AS PreviousWeekAvgTime,
  CASE 
    WHEN CURRENTdata.AverageResponseTime > PREVIOUS.AverageResponseTime THEN 'Degradation'
    WHEN CURRENTdata.AverageResponseTime < PREVIOUS.AverageResponseTime THEN 'Improvement'
    ELSE 'No Change'
  END AS PerformanceChange
FROM 
  WeeklyPerformance AS CURRENTdata
  INNER JOIN WeeklyPerformance AS PREVIOUS ON CURRENTdata.WeekOfYear = PREVIOUS.WeekOfYear + 1
order by WeekOfYear







-- Moving Average of Response Times
WITH DateResponseTimes AS (
  SELECT 
    [DATE], 
    AVG([TimeTaken]) AS AvgResponseTime 
  FROM 
    dbo.IISLOG 
  GROUP BY 
    [DATE]
),
MovingAverages AS (
  SELECT 
    [DATE], 
    AvgResponseTime,
    AVG(AvgResponseTime) OVER (ORDER BY [DATE] ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS SevenDayMovingAvg
  FROM 
    DateResponseTimes
)
SELECT 
  [DATE], 
  AvgResponseTime, 
  SevenDayMovingAvg 
FROM 
  MovingAverages
ORDER BY 
  [DATE];






-- Moving Average of Traffic Volume
WITH DailyVisits AS (
  SELECT 
    [DATE], 
    COUNT(*) AS NumberOfVisits 
  FROM 
    dbo.IISLOG 
  GROUP BY 
    [DATE]
),
MovingAverages AS (
  SELECT 
    [DATE], 
    NumberOfVisits,
    AVG(NumberOfVisits) OVER (ORDER BY [DATE] ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS SevenDayMovingAvg
  FROM 
    DailyVisits
)
SELECT 
  [DATE], 
  NumberOfVisits, 
  SevenDayMovingAvg 
FROM 
  MovingAverages
ORDER BY 
  [DATE];










-- Moving Average of Error Rates
WITH ErrorRates AS (
  SELECT 
    [DATE], 
    SUM(CASE WHEN [HttpStatus] >= 400 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS ErrorRate
  FROM 
    dbo.IISLOG 
  GROUP BY 
    [DATE]
),
MovingAverages AS (
  SELECT 
    [DATE], 
    ErrorRate,
    AVG(ErrorRate) OVER (ORDER BY [DATE] ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS SevenDayMovingAvg
  FROM 
    ErrorRates
)
SELECT 
  [DATE], 
  ErrorRate, 
  SevenDayMovingAvg 
FROM 
  MovingAverages
ORDER BY 
  [DATE];