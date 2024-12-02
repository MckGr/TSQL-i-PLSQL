--Zad2
CREATE OR REPLACE TRIGGER zad2
    BEFORE DELETE OR INSERT OR UPDATE ON OSOBA_
    FOR EACH Row
DECLARE
BEGIN
    IF DELETING AND :NEW.NAZWISKO = 'Kowalski' THEN
        DBMS_OUTPUT.PUT_LINE(-20500, 'Nie można usunąć osoby o nazwisku "Kowalski"');
    END IF;
    IF (inserting or updating) and LENGTH(:NEW.PESEL) <> 11 then
        DBMS_OUTPUT.PUT_LINE(-20500, 'Numer PESEL musi mieć 11 znaków');
    END IF;
END;
--Zad1
CREATE OR REPLACE PROCEDURE zad1(
    procPESEL IN VARCHAR,
    procImie IN VARCHAR2,
    procNazwisko IN VARCHAR2
)
AS
    id INT;
BEGIN
    SELECT IdOsoby INTO id FROM OSOBA_ WHERE PESEL = procPESEL;
    IF id IS not NULL THEN
        RAISE_APPLICATION_ERROR(-20500, 'Osoba o podanym PESEL już istnieje');
    SELECT MAX(IdOsoby) + 1 INTO id FROM OSOBA_;
    INSERT INTO OSOBA_ (IdOsoby, PESEL, IMIE, NAZWISKO)
    VALUES (id, procPESEL, procImie, procNazwisko);
    COMMIT;
    END IF;
END;
