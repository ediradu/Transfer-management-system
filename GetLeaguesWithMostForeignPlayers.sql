CREATE PROCEDURE GetLeaguesWithMostForeignPlayers
AS
BEGIN
    SELECT 
        l.league_id,
        l.league_name,
        COUNT(p.player_id) AS foreign_players_count
    FROM leagues l
    INNER JOIN teams t ON l.league_id = t.league_id
    INNER JOIN contracts c ON t.team_id = c.team_id
    INNER JOIN players p ON c.player_id = p.player_id
    WHERE t.country <> p.nationality
    GROUP BY l.league_id, l.league_name
    HAVING COUNT(p.player_id) >= 2
    ORDER BY foreign_players_count DESC;
END;

EXEC GetLeaguesWithMostForeignPlayers;

