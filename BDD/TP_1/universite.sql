DROP TABLE IF EXISTS etudiant CASCADE;
DROP TABLE IF EXISTS cours CASCADE;
DROP TABLE IF EXISTS examen CASCADE;

CREATE TABLE etudiant (
	numEtud serial PRIMARY KEY,
	nom varchar(25) NOT NULL,
	prenom varchar(25) NOT NULL,
	numlic int
);

INSERT INTO etudiant(nom,prenom,numlic) VALUES
	('Potter', 'Harry', 2),
	('Granger', 'Hermione', 2),
	('Lovegood', 'Luna', 1),
	('Weasley', 'Ronald', 2),
	('Delacour', 'Fleur', 2);

CREATE TABLE cours (
	codeCours serial PRIMARY KEY,
	intitule varchar(60),
	ects int
);

INSERT INTO cours(intitule, ects) VALUES
	('Métamorphose', 20),
	('Potions', 15),
	('Défense contre les forces du mal', 15),
	('Enchanement', 20),
	('Points de jury', 60);

CREATE TABLE examen (
	numEtud int REFERENCES etudiant(numEtud),
	codeCours int REFERENCES cours(codeCours),
	note numeric(3,1),
	PRIMARY KEY (numEtud,codeCours)
);

INSERT INTO examen VALUES
	(1,1,12),
	(1,2,12),
	(1,3,12),
	(1,4,12),
	(5,4,15);

CREATE VIEW nouveauL3 AS
(
	SELECT numEtud, nom
	FROM etudiant NATURAL JOIN examen NATURAL JOIN cours
	WHERE note >= 10 AND numLic = 2
	GROUP BY numEtud, nom
	HAVING sum(ects) >= 60
);


CREATE OR REPLACE FUNCTION pointsJury() RETURNS TRIGGER AS
$$
	DECLARE 
		etu etudiant%ROWTYPE; deja int; jury int;

	BEGIN
	SELECT * INTO etu FROM etudiant WHERE numEtud = NEW.numEtud;
	IF NOT FOUND THEN 
		RAISE NOTICE 'L''étudiant n''existe pas.' ; RETURN NULL ;
	END IF;
	IF etu.numLic != 2 THEN 
		RAISE NOTICE 'L''étudiant n''est pas en L2.' ; RETURN NULL ; 
	END IF ;

	SELECT numEtud INTO deja FROM nouveauL3 WHERE numEtud = NEW.numEtud;
	IF FOUND THEN
		RAISE NOTICE '% passe déjà en L3.', etu.nom; RETURN NULL ;
	END IF;

	SELECT codeCours INTO jury FROM cours WHERE intitule = 'Points de jury';
	-- S'il n'exite pas, création avec 10 ects
	if not found THEN
		INSERT INTO cours VALUES (intitule, 10);
	end if;
	

	INSERT INTO examen VALUES (etu.numEtud, jury, 10);
	/*
	SELECT * into etu from etudiant
	where numEtud = NEW.numEtud;
	if sum(ects) < 60 then 
		raise notice 'Pas assez de points %', etu.numEtud;
	end if;
	*/
	RETURN NEW ;
	END ;
$$
LANGUAGE plpgsql;

CREATE TRIGGER insereL3
INSTEAD OF INSERT ON nouveauL3
FOR EACH ROW 
EXECUTE PROCEDURE pointsJury();
