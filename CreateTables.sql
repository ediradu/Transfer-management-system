USE football_transfers;

CREATE TABLE players (
    player_id INT PRIMARY KEY,
    name NVARCHAR(100),
    nationality NVARCHAR(50),
    position NVARCHAR(30),
    date_of_birth DATE,
    market_value DECIMAL(15, 2)
);

CREATE TABLE teams (
    team_id INT PRIMARY KEY,
    league_id INT FOREIGN KEY REFERENCES leagues(league_id),
    team_name NVARCHAR(100),
    country NVARCHAR(50),
    budget DECIMAL(15, 2)
);

CREATE TABLE leagues (
    league_id INT PRIMARY KEY,
    league_name NVARCHAR(100),
    country NVARCHAR(50)
);

CREATE TABLE contracts (
    contract_id INT PRIMARY KEY,
    player_id INT FOREIGN KEY REFERENCES players(player_id),
    team_id INT FOREIGN KEY REFERENCES teams(team_id),
    start_date DATE,
    end_date DATE,
    salary DECIMAL(15, 2)
);

CREATE TABLE transfers (
    transfer_id INT PRIMARY KEY,
    player_id INT FOREIGN KEY REFERENCES players(player_id),
    from_team_id INT FOREIGN KEY REFERENCES teams(team_id),
    to_team_id INT FOREIGN KEY REFERENCES teams(team_id),
    transfer_fee DECIMAL(15, 2),
    transfer_date DATE,
    contract_duration INT
);

CREATE TABLE player_stats (
    stat_id INT PRIMARY KEY,
    player_id INT FOREIGN KEY REFERENCES players(player_id),
    goals INT,
    assists INT,
    matches_played INT,
    minutes_played INT
);
