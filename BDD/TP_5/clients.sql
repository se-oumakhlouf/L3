DROP TABLE IF EXISTS client CASCADE;

CREATE TABLE client(
	numcli serial primary key,
	nom varchar(25),
	prenom varchar(25),
	prenom2 varchar(25),
	prenom3 varchar(25),
	age int,
	ville varchar(25),
	tel varchar(10)
);


-- Exo 1

/* Question 1:
	Index :
    	"client_pkey" PRIMARY KEY, btree (numcli)
*/


/* Question 2:
	a - \timing \i clients_fill.sql 
		Chronométrage activé.
		COPY 248954
		Durée : 1355,965 ms (00:01,356)
		ALTER SEQUENCE
		Temps : 1,980 ms

	b - create index idx_nom on client using btree (nom);
		\i clients_fill.sql 
		COPY 248954
		Durée : 2926,167 ms (00:02,926)
		ALTER SEQUENCE
		Temps : 2,436 ms

	c - create index hash_nom on client using hash (nom);
		ATTENTION:  les index hash ne sont pas journalisés, leur utilisation est donc déconseillée
		\i clients_fill.sql 
		COPY 248954
		Durée : 2600,473 ms (00:02,600)
		ALTER SEQUENCE
		Temps : 2,267 ms

	d - create index b_nom on client using btree (nom);
		create index h_nom on client using hash (nom);
		create index b_tel on client using btree (tel);
		create index h_tel on client using hash (tel);
		\i clients_fill.sql 
		COPY 248954
		Durée : 6814,802 ms (00:06,815)
		ALTER SEQUENCE
		Temps : 2,255 ms

	e - drop index client_pkey
		ERREUR:  n'a pas pu supprimer index client_pkey car il est requis par contrainte client_pkey sur table client
		ASTUCE : Vous pouvez supprimer contrainte client_pkey sur table client à la place.

		En enlevant la clé primaire :
		\i clients_fill.sql 
		COPY 248954
		Temps : 640,099 ms
		ALTER SEQUENCE
		Temps : 2,023 ms
*/


/* Question 3:
	SELECT relpages, reltuples FROM pg_class WHERE relname = 'client';

	client :
	relpages | reltuples 
	----------+-----------
		2409 |    248954
	(1 ligne)

	b_nom :							h_nom :
	relpages | reltuples 			 	relpages  | reltuples 
	---------+-----------				----------+-----------
		951  |    248954					 1601 |    248954


	b_tel : 						h_tel :
	relpages | reltuples 				 relpages | reltuples
	---------+-----------				----------+-----------		
		1238 |    248954				     1300 |    248954


	Les index sont denses car on a le même nombre de reltuples à chaque fois
 */


-- Exo 2:

/* Question 1:
	create index b_nom on client using btree (nom);
	create index h_nom on client using hash (nom);
	create index b_tel on client using btree (tel);
	create index h_tel on client using hash (tel);

	\i clients_fill.sql
 */


/* Question 2:
	explain select * from client;

							QUERY PLAN                           
	---------------------------------------------------------------
	Seq Scan on client  (cost=0.00..4898.54 rows=248954 width=54)
	(1 ligne)

	Il effectue une recherche ligne à ligne (scan on client)
 */


/* Question 3:
	a - explain select nom from client;

		                          QUERY PLAN                          
		--------------------------------------------------------------
		Seq Scan on client  (cost=0.00..4898.54 rows=248954 width=7)
		(1 ligne)

	b - explain select nom, prenom from client where numcli = 96224;

										QUERY PLAN                                 
		---------------------------------------------------------------------------
		Index Scan using client_pkey on client  (cost=0.42..8.44 rows=1 width=14)
		Index Cond: (numcli = 96224)
		(2 lignes)

		recherche avec l'index sur la clé primaire

	c - explain select nom, prenom from client where tel = '0341460953';

									QUERY PLAN                              
		---------------------------------------------------------------------
		Index Scan using h_tel on client  (cost=0.00..8.02 rows=1 width=14)
		Index Cond: ((tel)::text = '0341460953'::text)
		(2 lignes)

		recherche en utilisant la table de hachage sur le téléphone car égalité

	d - explain SELECT nom, prenom FROM client WHERE tel < '07' AND tel > '06';

										QUERY PLAN                                    
		---------------------------------------------------------------------------------
		Bitmap Heap Scan on client  (cost=745.41..3524.64 rows=24682 width=14)
		Recheck Cond: (((tel)::text < '07'::text) AND ((tel)::text > '06'::text))
		->  Bitmap Index Scan on b_tel  (cost=0.00..739.24 rows=24682 width=0)
				Index Cond: (((tel)::text < '07'::text) AND ((tel)::text > '06'::text))
		(4 lignes)

		recherche avec le b-tree sur le téléphone car inégalité

	e - explain select prenom from client where nom = 'Delauney';

									QUERY PLAN                               
		------------------------------------------------------------------------
		Bitmap Heap Scan on client  (cost=30.32..2124.34 rows=1277 width=7)
		Recheck Cond: ((nom)::text = 'Delauney'::text)
		->  Bitmap Index Scan on b_nom  (cost=0.00..30.00 rows=1277 width=0)
				Index Cond: ((nom)::text = 'Delauney'::text)
		(4 lignes)

		recherche avec b-tree sur le nom alors que c'est une égalité

	f - explain select prenom from client where nom < 'Delauney';

										QUERY PLAN                                 
		---------------------------------------------------------------------------
		Bitmap Heap Scan on client  (cost=1091.15..4091.65 rows=47320 width=7)
		Recheck Cond: ((nom)::text < 'Delauney'::text)
		->  Bitmap Index Scan on b_nom  (cost=0.00..1079.32 rows=47320 width=0)
				Index Cond: ((nom)::text < 'Delauney'::text)
		(4 lignes)

		recherche avec b-tree sur nom
*/

/* Question 4:

	a - explain select prenom, tel from client where nom < 'Delauney';

										QUERY PLAN                                 
		---------------------------------------------------------------------------
		Bitmap Heap Scan on client  (cost=1091.15..4091.65 rows=47320 width=18)
		Recheck Cond: ((nom)::text < 'Delauney'::text)
		->  Bitmap Index Scan on b_nom  (cost=0.00..1079.32 rows=47320 width=0)
				Index Cond: ((nom)::text < 'Delauney'::text)
		(4 lignes)


	b - explain select prenom, tel from client where nom > 'Delauney';

									QUERY PLAN                           
		---------------------------------------------------------------
		Seq Scan on client  (cost=0.00..5520.93 rows=201634 width=18)
		Filter: ((nom)::text > 'Delauney'::text)
		(2 lignes)

	Dans la 'a', recherche avec b-tree car D se trouve rapidement, donc il n'y aura pas bcp de lignes dans la réponse
	Dans la 'b', recherche par ligne car il va y avoir beaucoup de lignes dans la réponse


	---------------------------------

	create index b_p2 on client using btree (prenom2);
	create index h_p2 on client using hash (prenom2);
	create index b_p3 on client using btree (prenom3);
	create index h_p3 on client using hash (prenom3); 

	explain select prenom2, tel from client where prenom2 < 'Delauney';
	explain select prenom3, tel from client where prenom2 > 'Delauney';
*/

/* Question 5:

	a - explain select nom, prenom, prenom2, prenom3 from client where tel is NULL;

									QUERY PLAN                               
		------------------------------------------------------------------------
		Bitmap Heap Scan on client  (cost=71.20..2587.80 rows=2423 width=28)
		Recheck Cond: (tel IS NULL)
		->  Bitmap Index Scan on b_tel  (cost=0.00..70.59 rows=2423 width=0)
				Index Cond: (tel IS NULL)
		(4 lignes)

		Il y a très peu de lignes où tel est NULL donc on utilise b-tree

	b - explain select nom, prenom, prenom2, prenom3 from client where tel is not null;

	                          	QUERY PLAN                           
		---------------------------------------------------------------
		Seq Scan on client  (cost=0.00..4898.54 rows=246531 width=28)
		Filter: (tel IS NOT NULL)
		(2 lignes)

		Il y a beaucoup de lignes il y aura donc beaucoup de blocs si on effectue une recherche pas index
		Il est donc préférable de directement chercher ligne par ligne
*/



-- Exo 3

/* Question 1:

	create index idx_b on client using btree (nom, prenom);
	create index idx_h on client using hash (nom, prenom);

	Cela ne marche pas en hash
*/

/* Question 2:
	L'index sur plusieurs colonnes prend plus de places (plus de blocs)
*/

/* Question 3:

	a - On utilise l'index, logique car recherche sur le couple

	b - On utilise l'index

	c - On n'utilise pas l'index
*/

/* Question 4:

	explain select prenom from client where nom = 'Delacour';

	avant VACUUM :
		BitMap heap scan
	après :
		recherche par l'index
 */

