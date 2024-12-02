
-----------Zad1
create procedure zad1
    @agentid as int, @idlock as int, @missionnazwa as varchar(30), @nagroda as int
as
    DECLARE @DataKoniec date
    SELECT @DataKoniec = DataKoniec
    FROM Agent
    WHERE Id = @agentId;

IF (@DataKoniec IS NULL)
   BEGIN
       PRINT 'Agent o podanym ID jest aktywny';
       RETURN;
   END;
   else
       begin
           Print 'Agent o podanym ID jest nieaktywny';
       end
IF NOT EXISTS (SELECT 1 FROM Lokalizacja WHERE Id = @idlock)
   BEGIN
       PRINT 'Lokalizacja o podanym ID nie istnieje.';
       RETURN;
   END;
if not EXISTS(SELECT 1 from Agent where Id = @agentid)
    begin
        print 'Agent o podanym id nie istnieje'
    end;
    INSERT INTO Misja (Nazwa, Nagroda, Opis, Agent_Id, Lokalizacja_Id)
    VALUES (@missionnazwa, @nagroda, NULL, @agentid, @idlock);
    PRINT 'Misja została zarejestrowana.';



--Zad2
CREATE TRIGGER zad2
ON Agent
AFTER DELETE, UPDATE, INSERT
AS
BEGIN
   IF EXISTS (SELECT 1 FROM deleted d
              JOIN  Misja t ON d.Id= t.id
              WHERE d.DataKoniec IS NULL)
   BEGIN
       ROLLBACK;
       RAISERROR ('Nie można usunąć agentów którzy jeszcze pracują', 15, 1);
   END
   IF UPDATE(Pseudonim)
   BEGIN
       ROLLBACK;
       RAISERROR ('Nie można zmienić pseudonimu agenta', 15, 1);
   END
   IF EXISTS (SELECT 1 FROM inserted i
              WHERE i.DataKoniec < i.DataStart)
   BEGIN
       ROLLBACK;
       RAISERROR ('Nie można wstawić agenta z datą odejścia wcześniejszą niż data zatrudnienia.', 15, 1);
   END
END;


drop procedure zad1
drop trigger zad2

