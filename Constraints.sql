-- Constrangeri pentru tabela players
ALTER TABLE players
ADD CONSTRAINT chk_market_value CHECK (market_value > 0);

-- Constrangeri pentru tabela teams
ALTER TABLE teams
ADD CONSTRAINT chk_budget CHECK (budget > 0);

-- Constrangeri pentru tabela contracts
ALTER TABLE contracts
ADD CONSTRAINT chk_salary_positive CHECK (salary > 0),
    CONSTRAINT chk_contract_dates CHECK (start_date < end_date);

-- Constrangeri pentru tabela transfers
ALTER TABLE transfers
ADD CONSTRAINT chk_transfer_fee CHECK (transfer_fee >= 0),
    CONSTRAINT chk_transfer_dates CHECK (contract_duration > 0);

-- Constrangeri pentru tabela leagues
ALTER TABLE leagues
ADD CONSTRAINT chk_league_name CHECK (LEN(league_name) > 0);

ALTER TABLE teams
ADD CONSTRAINT unique_team_name UNIQUE (team_name);

ALTER TABLE leagues
ADD CONSTRAINT unique_league_name UNIQUE (league_name);

ALTER TABLE contracts
ADD CONSTRAINT unique_player_team UNIQUE (player_id, team_id);
