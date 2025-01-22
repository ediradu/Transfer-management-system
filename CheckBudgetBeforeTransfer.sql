CREATE TRIGGER CheckBudgetBeforeTransfer
ON transfers
FOR INSERT
AS
BEGIN
    DECLARE @team_id INT, @transfer_fee DECIMAL(15, 2), @budget DECIMAL(15, 2);

    SELECT @team_id = i.to_team_id, @transfer_fee = i.transfer_fee
    FROM inserted i;

    SELECT @budget = budget
    FROM teams
    WHERE team_id = @team_id;

    IF @transfer_fee > @budget
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Transferul nu poate fi realizat. Buget insuficient.';
    END
END;
