CREATE TRIGGER CheckBudgetForToTeam
ON transfers
FOR INSERT
AS
BEGIN
    DECLARE @to_team_id INT, @transfer_fee DECIMAL(15, 2), @budget DECIMAL(15, 2);

    SELECT @to_team_id = i.to_team_id, @transfer_fee = i.transfer_fee
    FROM inserted i;

    SELECT @budget = t.budget
    FROM teams t
    WHERE t.team_id = @to_team_id;

    IF @transfer_fee > @budget
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Bugetul echipei care primeste jucatorul este insuficient.';
    END;
END;
