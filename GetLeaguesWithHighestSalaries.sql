CREATE PROCEDURE GetLeaguesWithHighestSalaries
AS
BEGIN
    SELECT 
        l.league_id,
        l.league_name,
        SUM(c.salary) AS total_salaries,
        AVG(c.salary) AS average_salary
    FROM leagues l
    INNER JOIN teams t ON l.league_id = t.league_id
    INNER JOIN contracts c ON t.team_id = c.team_id
    WHERE YEAR(c.end_date) = YEAR(GETDATE()) - 1
    GROUP BY l.league_id, l.league_name
    ORDER BY total_salaries DESC;
END;

EXEC GetLeaguesWithHighestSalaries;
