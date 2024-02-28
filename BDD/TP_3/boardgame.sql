DROP TABLE IF EXISTS partie CASCADE;
DROP TABLE IF EXISTS joueur CASCADE;
DROP TABLE IF EXISTS demande CASCADE;

CREATE TABLE partie(
	pid serial primary key,
	jeu varchar(50),
	nbmin int,
	nbmax int,
	etat varchar(10) default 'ouvert',
	CHECK (nbmin <= nbmax)
);

CREATE TABLE joueur(
	jid serial primary key,
	pseudo varchar(25)
);

CREATE TABLE demande(
	jid int REFERENCES joueur(jid),
	pid int REFERENCES partie(pid),
	date timestamp default now(),
	statut varchar(10) default 'en attente',
	PRIMARY KEY(jid,pid)
);

INSERT INTO partie(jeu,nbmin,nbmax) VALUES
	('La guerre des moutons', 2, 4),
	('La guerre des moutons', 2, 4),
	('Dixit', 2, 5),
	('Elxiir', 4, 10),
	('Scythe',5,5),
	('Scythe',2,5),
	('Spirit Island',2,4),
	('Dominion',2,2),
	('7 wonders',3,7),
	('Ghost Stories',1,5);

INSERT INTO joueur(pseudo) VALUES
	('Alix'),
	('Bobar'),
	('Charpie'),
	('DiAnne'),
	('Eve-il');

INSERT INTO demande(jid,pid) VALUES
	(1,8), (2,8),
	(1,2), (2,2), (3,2);


/*

			READ COMMITTED


		Question 1 : 

	Admin: 	. Compte
			. Ferme
	Joueur: . Verifie que en attente
			. se désiste

	On obtient une partie qui n'a pas assez de joueurs si
	Admin: 	. Compte
	Joueur:	. Verifie que en attente
			. se desiste
	Admin: 	. Ferme

	En repeatable read l'erreur ne persiste pas



	Question 2 : 

	Joueur:	. Vérifie que la partie est 'ouverte'
			. Demande à rejoindre
	Admin:	. Vérifie que la partie est 'ouverte'
			. Change l'état de la partie en 'annulé'

	On obtient une demande en attente pour une partie annulée si
	Joueur:	. Vérifie que la partie est 'ouverte'
	Admin: 	. Vérifie que la partie est 'ouverte'
			. Change l'état de la partie en 'annulé'
	Joueur:	. Demande à rejoindre la partie


*/