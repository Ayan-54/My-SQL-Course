-- Football Match exercise
 
/*
The FootballMatch table shows the EPL matches played in 2024/25 season as of 16th March 2025
 
Important Columns
Date - Match Date (dd/mm/yy)
Time - Time of match kick off
HomeTeam- Home Team
AwayTeam - Away Team
FTHG -Full Time Home Team Goals
FTAG - Full Time Away Team Goals
FTR - Full Time Result (H=Home Win, D=Draw, A=Away Win)
 
Full details at https://zomalex.co.uk/datasets/football_match_dataset.html
*/
 
SELECT
    fm.Date
    , fm.HomeTeam
    , fm.AwayTeam
    , fm.FTHG
    , fm.FTAG
    , fm.FTR
FROM
    FootballMatch fm;
 
/*
How many games have been played?.  
- In total
- By each team
- By Month
*/
 
-- How many goals have been scored in total
 
-- How many goals have been scored by each team?

SELECT
    fm.Date
    , fm.HomeTeam
    , fm.AwayTeam
    , fm.FTHG
    , fm.FTAG
    , fm.FTR
FROM
    FootballMatch fm;
SELECT
    *
FROM
    FootballMatch fm;

SELECT
    DATENAME(MONTH,fm.Date) AS Month_Name,
    DATENAME(YEAR,fm.Date) AS YEAR_Name,
    MONTH(fm.[Date]) AS Month_No,
    COUNT(*) AS NumberOfMatches
FROM    
    FootballMatch fm
GROUP BY 
    MONTH(fm.[Date]),
    DATENAME(MONTH,fm.DATE),
    DATENAME(YEAR,fm.DATE)
ORDER BY 
    YEAR_Name DESC,
    Month_No DESC;
    




SELECT MONTh('2025-05-13') AS MONTH;
SELECT DATENAME(MONTH,'2025-05-13') AS MONTH;



SELECT 
    HomeTeam AS HT,
    SUM(FTHG) AS Total_HT --- Number of Home
FROM FootballMatch
GROUP BY HomeTeam, FTHG
ORDER BY HT;

SELECT 
    AwayTeam AS AT,
    SUM(FTAG) AS Total_AT ---- Number of Aaway
FROM FootballMatch
GROUP BY AwayTeam, FTAG
ORDER BY AT;

----




WITH CTE_Goals_Scored AS (
    SELECT 
        AwayTeam AS T,
        SUM(FTAG) AS Goals_Scored
    FROM FootballMatch
    GROUP BY AwayTeam
    
    UNION ALL

    SELECT 
        HomeTeam AS T,
        SUM(FTHG) AS Goals_Scored
    FROM FootballMatch
    GROUP BY HomeTeam
)
SELECT 
    T AS Team,
    SUM(Goals_Scored) AS Total_Goals
FROM CTE_Goals_Scored 
GROUP BY 
    T
ORDER BY 
    T;




SELECT 
        AwayTeam AS T,
        SUM(FTAG) AS Goals_Scored
INTO #League_Table
FROM FootballMatch
GROUP BY AwayTeam
    
UNION ALL

SELECT 
        HomeTeam AS T,
        SUM(FTHG) AS Goals_Scored
FROM FootballMatch
GROUP BY HomeTeam;

SELECT 
    T AS Team,
    SUM(Goals_Scored) AS Total_Goals
FROM #League_Table t
GROUP BY 
    T
ORDER BY 
    T;



DROP TABLE IF EXISTS #LeagueTable;
 
SELECT
    fm.HomeTeam as Team, 
    COUNT(*) AS Played,

    CASE 
        fm.FTR WHEN 'H' THEN 1 ELSE 0 
    END AS Won,

    SUM(fm.FTHG) AS GF,
    SUM(fm.FTAG) as GA
INTO #LeagueTable
FROM
    FootballMatch fm
group by fm.HomeTeam 
UNION ALL
SELECT
    fm.AwayTeam,

    CASE
        fm.FTR WHEN 'A' THEN 1 ELSE 0 
    END AS Won,

    COUNT(*) AS Played,
    SUM(fm.FTAG),
    SUM(fm.FTHG) as GA
FROM
    FootballMatch fm
group by fm.AwayTeam
 
--SELECT * FROM #LeagueTable;
 
SELECT 
    SUM(Played) AS Played,
    t.Team As Team,
    SUM(T.GF) as GF,
    SUM(T.GA) as GA
FROM #LeagueTable t
    group by t.Team
    order by t.Team;
 









DROP TABLE IF EXISTS #LeagueTable;
 
SELECT
    fm.HomeTeam AS Team
    ,COUNT(*) AS Played
    ,CASE WHEN fm.FTR = 'H' THEN 1 ELSE 0 END AS Won
    ,fm.FTHG AS GF
    ,fm.FTAG AS GA
INTO #LeagueTable
    FROM FootballMatch fm
UNION ALL
SELECT
        fm.AwayTeam
        ,COUNT(*) AS Played
        ,CASE WHEN fm.FTR = 'A' THEN 1 ELSE 0 END AS Won
        ,fm.FTAG
        ,fm.FTHG
FROM  FootballMatch fm
 
--SELECT * FROM #LeagueTable;
 
SELECT
    t.Team AS Team
    ,SUM(Played) AS Played
    ,SUM(t.Won) AS Won
    ,SUM(T.GF) AS GF    
    ,SUM(T.GA) AS GA
FROM
    #LeagueTable t
GROUP BY t.Team
ORDER BY t.Team;


DROP TABLE IF EXISTS #LeagueTable;
 
SELECT
    fm.HomeTeam AS Team
    ,CASE WHEN fm.FTR = 'H' THEN 1 ELSE 0 END AS Won
    ,CASE WHEN fm.FTR = 'D' THEN 1 ELSE 0 END AS Drawn
    ,fm.FTHG AS GF
    ,fm.FTAG AS GA
INTO #LeagueTable
    FROM FootballMatch fm
UNION ALL
SELECT
    fm.AwayTeam
    ,CASE WHEN fm.FTR = 'A' THEN 1 ELSE 0 END AS Won
    ,CASE WHEN fm.FTR = 'D' THEN 1 ELSE 0 END AS Drawn
    ,fm.FTAG
    ,fm.FTHG
FROM  FootballMatch fm
 
--SELECT * FROM #LeagueTable;
 
SELECT
    t.Team AS Team
    ,count(*) AS Played
    ,SUM(t.Drawn) AS Drawn
    ,SUM(t.Won) AS Won
    ,SUM(T.GF) AS GF    
    ,SUM(T.GA) AS GA
FROM
    #LeagueTable t
GROUP BY t.Team
ORDER BY t.Team;

SE

