drop trigger if exists stock_trigger on contient;

CREATE OR REPLACE FUNCTION verif_stock() 
RETURNS TRIGGER AS
$$
	DECLARE 
		sto stocke%ROWTYPE;
		mag int;

	BEGIN

	-- vérifier que le magasin existe
	SELECT idmag INTO mag FROM facture WHERE idfac = NEW.idfac;
	if not found then
		raise exception 'le magasin n''existe pas';
	end if;
	RAISE NOTICE 'La facture concerne le magasin %.', mag;

	-- vérifier que le produit est disponible dans le magasin
	SELECT * INTO sto FROM stocke WHERE idmag = mag AND idpro = NEW.idpro;
	IF NOT FOUND THEN
		RAISE exception 'Le produit % n''est pas disponible dans le magasin %.', sto.idpro, mag;
	END IF;

	-- vérifier que la quantité demandée est disponible dans le stock
	if NEW.quantite > sto.quantite then
		raise exception 'La quantité demandé (%) est trop élevée. Stock disponible : %', NEW.quantite, sto.quantite;
	end if;

	-- Mise à jour du prix unitaire sur la facture au prix actuel du magasin
	New.prixUnit := sto.prixUnit;
	
	update stocke set quantite = sto.quantite - NEW.quantite 
	where idmag = mag and idpro = NEW.idpro;

	RETURN NEW;
	END;
$$ language plpgsql;

CREATE TRIGGER stock_trigger
BEFORE INSERT
ON contient
FOR EACH ROW
EXECUTE PROCEDURE verif_stock();
