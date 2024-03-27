drop table if exists test cascade;

CREATE TABLE test(
    id serial primary key,
    a int,
    b int
);


INSERT INTO test(a,b)
    SELECT round(random()*10), round(random()*100)
    FROM generate_series (1,10000);

analyze test;
SELECT relpages, reltuples FROM pg_class WHERE relname = 'test';


/* Question 1 : 
 relpages | reltuples 
----------+-----------
       55 |     10000
(1 ligne)
*/

delete from test where a < 5;
analyze test;
SELECT relpages, reltuples FROM pg_class WHERE relname = 'test';

/* Question 2 : Il y a toujours 55 blocs car c'est de la réorganisation différée

delete from test where a < 5;
DELETE 4550

analyze test;
SELECT relpages, reltuples FROM pg_class WHERE relname = 'test';
 relpages | reltuples 
----------+-----------
       55 |      5450
(1 ligne)

*/

insert into test (a, b)
    select 99, round(random() * 100)
    from generate_series (1, 4000);

analyze test;
SELECT relpages, reltuples FROM pg_class WHERE relname = 'test';

/* Question 3 : On a maintenant 76 blocs. Les nouveaux enregistrements ont été inséré
                    dans les nouveaux blocs

 relpages | reltuples 
----------+-----------
       76 |      9545
(1 ligne)

select *, ctid, xmin, xmax from test where a = 99;
  id   | a  |  b  |   ctid   |   xmin   | xmax 
-------+----+-----+----------+----------+------
 10001 | 99 |  47 | (54,11)  | 37371866 |    0
 10002 | 99 |  86 | (54,12)  | 37371866 |    0
 10003 | 99 |  83 | (54,13)  | 37371866 |    0
 10004 | 99 |  76 | (54,14)  | 37371866 |    0
................... (not the entire result)
*/

update test set b = b + 1 where a = 99;
analyze test;
SELECT relpages, reltuples FROM pg_class WHERE relname = 'test';

/* Question 4 : Il y a maintenant 98 blocs pour le même nombre de lignes

 relpages | reltuples 
----------+-----------
       98 |      9545
(1 ligne)


select *, ctid, xmin, xmax from test where a = 99;
  id   | a  |  b  |   ctid   |   xmin   | xmax 
-------+----+-----+----------+----------+------
 10001 | 99 |  48 | (75,126) | 37371911 |    0
 10002 | 99 |  87 | (75,127) | 37371911 |    0
 10003 | 99 |  84 | (75,128) | 37371911 |    0
 10004 | 99 |  77 | (75,129) | 37371911 |    0
................... (not the entire result)
*/

truncate test restart identity;
-- la table est à présent vide

/* Question 5 : Tout les blocs ont été supprimés

 relpages | reltuples 
----------+-----------
        0 |         0
(1 ligne)

*/


INSERT INTO test(a,b)
    SELECT round(random()*10), round(random()*100)
    FROM generate_series (1,10000);

delete from test where id < 5001;
   
analyze test;
SELECT relpages, reltuples FROM pg_class WHERE relname = 'test';

/* Question 6 : Après suppression on a 55 blocs et 5000 lignes

 relpages | reltuples 
----------+-----------
       55 |      5000
(1 ligne)
*/


truncate test restart identity;

INSERT INTO test(a,b)
    SELECT round(random()*10), round(random()*100)
    FROM generate_series (1,10000);

delete from test where id > 5000;
   
analyze test;
SELECT relpages, reltuples FROM pg_class WHERE relname = 'test';

/* Question 7 : Après suppression on a 55 blocs et 5000 lignes
                C'est donc la même chose que la question précédente

 relpages | reltuples 
----------+-----------
       55 |      5000
(1 ligne)
*/


truncate test restart identity;

INSERT INTO test(a,b)
    SELECT round(random()*10), round(random()*100)
    FROM generate_series (1,10000);

delete from test where id < 5001;
vacuum verbose test;
   
analyze test;
SELECT relpages, reltuples FROM pg_class WHERE relname = 'test';

/* 
 relpages | reltuples 
----------+-----------
       55 |      5000
(1 ligne)
*/

----

truncate test restart identity;

INSERT INTO test(a,b)
    SELECT round(random()*10), round(random()*100)
    FROM generate_series (1,10000);

delete from test where id > 5000;
vacuum verbose test;
   
analyze test;
SELECT relpages, reltuples FROM pg_class WHERE relname = 'test';

/*  relpages | reltuples 
----------+-----------
       28 |      5000
(1 ligne)
*/

-- Question 8 : Lorsque l'on supprime les 5000 dernières lignes ont observe qu'il y a moins de blocs


-- Question 2 avec vacuum full

INSERT INTO test(a,b)
    SELECT round(random()*10), round(random()*100)
    FROM generate_series (1,10000);

delete from test where a < 5;
vacuum full;
analyze test;
SELECT relpages, reltuples FROM pg_class WHERE relname = 'test';

/* 
 relpages | reltuples 
----------+-----------
       46 |      8357
(1 ligne)
*/


-- Question 3 avec vacuum full

insert into test (a, b)
    select 99, round(random() * 100)
    from generate_series (1, 4000);

vacuum full;

analyze test;
SELECT relpages, reltuples FROM pg_class WHERE relname = 'test';

/*  relpages | reltuples 
----------+-----------
       67 |     12357
(1 ligne)
*/


-- Question 4 avec vacuum full

update test set b = b + 1 where a = 99;
vacuum full;
analyze test;
SELECT relpages, reltuples FROM pg_class WHERE relname = 'test';

/*
 relpages | reltuples 
----------+-----------
       67 |     12357
(1 ligne)
*/