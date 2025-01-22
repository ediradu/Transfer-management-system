CREATE PROCEDURE GetTopPlayersByLeague
AS
BEGIN
    SELECT 
        l.league_name,
        t.team_name,
        p.name AS player_name,
        ps.goals,
        ps.matches_played,
        AVG(ps.minutes_played / NULLIF(ps.matches_played, 0)) AS avg_minutes_per_match
    FROM leagues l
    INNER JOIN teams t ON l.league_id = t.league_id
    INNER JOIN contracts c ON t.team_id = c.team_id
    INNER JOIN players p ON c.player_id = p.player_id
    INNER JOIN player_stats ps ON p.player_id = ps.player_id
    WHERE ps.matches_played >= 10
    GROUP BY l.league_name, t.team_name, p.name, ps.goals, ps.matches_played
    HAVING AVG(ps.minutes_played / NULLIF(ps.matches_played, 0)) > 60
    ORDER BY ps.goals DESC;
END;

EXEC GetTopPlayersByLeague