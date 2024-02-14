DROP TABLE IF EXISTS projet CASCADE;
DROP TABLE IF EXISTS soutient CASCADE;

CREATE TABLE projet(
	pid serial primary key,
	titre varchar(50),
	statut varchar(15),
	requis int
);

CREATE TABLE soutient(
	uid int,
	pid int references projet(pid),
	montant int
);

INSERT INTO projet VALUES
	(1,'Hoverboard','attente',50000),
	(2,'Full body VR','attente',10000),
	(3,'Perpetual motion','attente',500);

INSERT INTO soutient VALUES
	(2,2,6000);


-- Le niveau d'isolation par défault est READ COMMITED sous PostgreSQL

/* 
	BEGIN TRANSACTION isolation level read COMMITTED;

	A : UPDATE projet SET requis = 1000 where pid = 3;

	B : SELECT requis from projet where pid = 3;
	renvoie requis = 500 (pas de dirty read)

	A : COMMIT;

	B : insert into soutient values (1, 3, 500);
		select  requis from projet where pid = 3;
	renvoie requis = 1000 (non repeatable)
		commit;
*/


/* BEGIN TRANSACTION isolation level repeatable read;
	A : UPDATE projet SET requis = 1000 where pid = 3;

	B : SELECT requis from projet where pid = 3;
	renvoie requis = 500 (pas de dirty read)

	A : COMMIT;

	B : insert into soutient values (1, 3, 500);
		select  requis from projet where pid = 3;
	renvoie requis = 500 (repeatable)
		commit;
		select requis from projet where pid = 3;
	renvoie requis = 1000;
*/


/* 
	BEGIN TRANSACTION isolation level serializable;

	A : select sum(montant) from soutient where pid = 2;
	renvoie 6000
		update projet set statut = 'annulé' where pid = 2;
	
	B : insert into soutient values (1, 2, 4000);
		commit;

	A : select sum(montant) from soutient where pid = 2;
	erreur : n'a pas pu sérialiser un accès à cause des dépendances
		de lecture/écriture parmi les transactions

*/


/* 
	Postgres est plus strict dans le mode repeatable read
		dans le case d'une phantom read
*/