drop trigger if exists check_trigger on test;

CREATE OR REPLACE FUNCTION check_test()
RETURNS trigger as
$$
    DECLARE
        test_row test%ROWTYPE;

    BEGIN

        if NEW.a % 2 = 0 then 
            raise NOTICE 'id : %, a : %, b : % || % (a) est pair', NEW.id, NEW.a, NEW.b, NEW.a;
        end if;

        if NEW.b % 2 = 0 then
            raise NOTICE 'id : %, a : %, b : % || % (b) est pair', NEW.id, NEW.a, NEW.b, NEW.b; 
            raise NOTICE 'Annulation de l''insertion';
            RETURN NULL;
        end if;

        if NEW.a = NEW.b then
            raise exception 'Cas : a == b || % = %', NEW.a, New.b;
        end if;

    RETURN NEW;
    END;

$$ language plpgsql;

CREATE TRIGGER check_trigger
BEFORE INSERT
ON test
FOR EACH ROW
EXECUTE PROCEDURE check_test()


-- Avec un ROLLBACK on annule les changements
-- Avec un COMMIT les changements sur la tabels ont appliqués
-- Lors d'un RAISE EXCEPTION lors d'un transaction les prochaines commandes ne 
        -- sont pas pris en compte, et nous fait terminer par un ROLLBACK 