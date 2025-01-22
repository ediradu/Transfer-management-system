CREATE TRIGGER ValidateContractDuration
ON contracts
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @start_date DATE, @end_date DATE;

    SELECT @start_date = i.start_date, @end_date = i.end_date
    FROM inserted i;

    IF DATEDIFF(YEAR, @start_date, @end_date) < 1
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Contractul nu poate avea o durata mai mica de 1 an.';
    END;
END;
