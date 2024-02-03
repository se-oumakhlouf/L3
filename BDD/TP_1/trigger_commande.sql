drop trigger if exists stock_trigger on contient;

CREATE OR REPLACE FUNCTION verif_stock() 
RETURNS TRIGGER AS
$$
	DECLARE 
		sto stocke%ROWTYPE;
		mag int;

	BEGIN

	SELECT idmag INTO mag FROM facture WHERE idfac = NEW.idfac;
	if not found then
		raise exception 'le magasin n''existe pas';
	end if;
	RAISE NOTICE 'La facture concerne le magasin %.', mag;

	SELECT * INTO sto FROM stocke WHERE idmag = mag AND idpro = NEW.idpro;
	IF NOT FOUND THEN
		RAISE exception 'Le produit % n''est pas disponible dans le magasin %.', sto.idpro, mag;
	END IF;
	if NEW.quantite > sto.quantite then
		raise exception 'quantité demandé trop élevé | demande : %, stocke : %', NEW.quantite, sto.quantite;
	end if;
	
	update stocke set quantite = sto.quantite - NEW.quantite 
	where idmag = mag and idpro = NEW.idpro;

	update 
	
	-- faire question 4;

	RETURN NEW;
	END;
$$ language plpgsql;

CREATE TRIGGER stock_trigger
BEFORE INSERT
ON contient
FOR EACH ROW
EXECUTE PROCEDURE verif_stock();
