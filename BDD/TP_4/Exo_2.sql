drop table if exists test cascade;

CREATE TABLE test(
    id serial primary key,
    a int,
    b int
);


insert into test (a, b) values (1, 1), (2, 2), (3, 3);

/* Question 1 : Il n'y a besoin que d'un seul bloc

 id | a | b | ctid  |   xmin   | xmax 
----+----+---+-------+----------+------
  1 | 1 | 1 | (0,1) | 37371511 |    0
  2 | 2 | 2 | (0,2) | 37371511 |    0
  3 | 3 | 3 | (0,3) | 37371511 |    0
(3 lignes)

*/

INSERT INTO test(a,b)
    SELECT round(random()*10), round(random()*100)
    FROM generate_series (1,10000);

/* Question 2 :

selym.oumakhlouf_db=> select *, ctid, xmin, xmax from test where id > 9990;
  id   | a  | b  |  ctid   |   xmin   | xmax 
-------+----+----+---------+----------+------
  9991 |  3 | 81 | (54,1)  | 37371565 |    0
  9992 |  0 | 58 | (54,2)  | 37371565 |    0
  9993 |  5 | 86 | (54,3)  | 37371565 |    0
  9994 |  1 | 82 | (54,4)  | 37371565 |    0
  9995 |  5 | 50 | (54,5)  | 37371565 |    0
  9996 | 10 | 44 | (54,6)  | 37371565 |    0
  9997 |  9 | 60 | (54,7)  | 37371565 |    0
  9998 |  2 | 30 | (54,8)  | 37371565 |    0
  9999 |  2 | 63 | (54,9)  | 37371565 |    0
 10000 |  5 | 93 | (54,10) | 37371565 |    0
 10001 |  8 | 66 | (54,11) | 37371565 |    0
 10002 |  1 | 65 | (54,12) | 37371565 |    0
 10003 |  9 | 43 | (54,13) | 37371565 |    0
(13 lignes)

*/


/* Question 3 : 55 blocs sont utilisés pour stocker la table d'enregistrements
                10000 / 55 ≈ 181
                En moyenne il y a 180 enregistrements par bloc
*/


/* Question 4 :
    ctid, xmin, xmax, table oid, cmax, cmin : 24 octets
    id, a, b         : 12 octets + padding = 16 octets
    ligne            : 24 + 16 = 40 octets
    bloc             : 40 * 180 = 7200

    Un bloc fait environ 8 Ko
*/
