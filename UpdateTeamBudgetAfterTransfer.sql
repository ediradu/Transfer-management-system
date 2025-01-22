CREATE TRIGGER UpdateTeamBudgetAfterTransfer
ON transfers
FOR INSERT
AS
BEGIN
    DECLARE @to_team_id INT, @transfer_fee DECIMAL(15, 2);

    SELECT @to_team_id = i.to_team_id, @transfer_fee = i.transfer_fee
    FROM inserted i;

    UPDATE teams
    SET budget = budget - @transfer_fee
    WHERE team_id = @to_team_id;

    PRINT 'Bugetul echipei a fost actualizat.';
END;
