CREATE TRIGGER UpdateBudgetForFromTeam
ON transfers
FOR INSERT
AS
BEGIN
    DECLARE @from_team_id INT, @transfer_fee DECIMAL(15, 2);

    SELECT @from_team_id = i.from_team_id, @transfer_fee = i.transfer_fee
    FROM inserted i;

    UPDATE teams
    SET budget = budget + @transfer_fee
    WHERE team_id = @from_team_id;

    PRINT 'Bugetul echipei care pierde jucatorul a fost actualizat.';
END;
