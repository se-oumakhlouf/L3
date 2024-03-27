drop table if exists test cascade;

CREATE TABLE test(
    id serial primary key,
    a int,
    b int
);


/* Question 1 : 
        ctid est la localisation physique de l'objet dans la table
        xmin est l'ID de la transaction qui a créé
        xmaxest l'ID de la transaction qui a supprimé
*/

insert into test (a, b) values (1, 2), (3, 4), (5, 6), (10, 10);

/* Question 2 :

    selym.oumakhlouf_db=> select *, ctid, xmin, xmax from test;
    id | a  | b  | ctid  |   xmin   | xmax 
    ----+----+----+-------+----------+------
    1 |  1 |  2 | (0,1) | 37370819 |    0
    2 |  3 |  4 | (0,2) | 37370819 |    0
    3 |  5 |  6 | (0,3) | 37370819 |    0
    4 | 10 | 10 | (0,4) | 37370819 |    0
    (4 lignes)

*/

/* Question 3 : xmin prend la valeur de l'id de la transaction
                    (insertion)

BEGIN;

T1 : INSERT INTO test (a, b) values (1, 1), (2, 2);
T2 : INSERT INTO test (a, b) values (3, 3), (4, 4);

COMMIT;
*/

insert into test (a, b) values (1, 1), (2, 2), (3, 3), (4, 4);

/* Question 4 : Les lignes qui devaient être supprimé par T1 sont marqué par le xmax de T1
                Et les transactions supprimé par T1 ont bien été supprimé

BEGIN;

T1 : Delete from test where a = 1;
T2 : delete from test where a = 2;

T1 : rollback;
T2 : commit;
*/


/* Question 5 : Avant Commit :  Dans T1 on observe que les ctid changent
                Dans T2, les lignes qui vont être modifiés ont un xmax
                                insertion de la ligne avec un ctid (0, 11) et les ctid
                                modifier dans T1 ne sont pas encore modifié

                Après Commit : Les ctid sont modifiés et les xmin prennent les valeurs de xmax         

BEGIN;

T1 : Update test set b = 10 where a = 1;
T2 : insert into test (a, b) values (5, 5);

commit;


T1 : 
 id | a  | b  |  ctid  |   xmin   | xmax 
----+----+----+--------+----------+------
  2 |  3 |  4 | (0,2)  | 37371408 |    0
  3 |  5 |  6 | (0,3)  | 37371408 |    0
  4 | 10 | 10 | (0,4)  | 37371408 |    0
  6 |  2 |  2 | (0,6)  | 37371409 |    0
  7 |  3 |  3 | (0,7)  | 37371409 |    0
  8 |  4 |  4 | (0,8)  | 37371409 |    0
  1 |  1 | 10 | (0,9)  | 37371410 |    0
  5 |  1 | 10 | (0,10) | 37371410 |    0
(8 lignes)


T2 :
 id | a  | b  |  ctid  |   xmin   |   xmax   
----+----+----+--------+----------+----------
  1 |  1 |  2 | (0,1)  | 37371408 | 37371410
  2 |  3 |  4 | (0,2)  | 37371408 |        0
  3 |  5 |  6 | (0,3)  | 37371408 |        0
  4 | 10 | 10 | (0,4)  | 37371408 |        0
  5 |  1 |  1 | (0,5)  | 37371409 | 37371410
  6 |  2 |  2 | (0,6)  | 37371409 |        0
  7 |  3 |  3 | (0,7)  | 37371409 |        0
  8 |  4 |  4 | (0,8)  | 37371409 |        0
  9 |  5 |  5 | (0,11) | 37371420 |        0
(9 lignes)


Après commit : 
 id | a  | b  |  ctid  |   xmin   | xmax 
----+----+----+--------+----------+------
  2 |  3 |  4 | (0,2)  | 37371408 |    0
  3 |  5 |  6 | (0,3)  | 37371408 |    0
  4 | 10 | 10 | (0,4)  | 37371408 |    0
  6 |  2 |  2 | (0,6)  | 37371409 |    0
  7 |  3 |  3 | (0,7)  | 37371409 |    0
  8 |  4 |  4 | (0,8)  | 37371409 |    0
  1 |  1 | 10 | (0,9)  | 37371410 |    0
  5 |  1 | 10 | (0,10) | 37371410 |    0
  9 |  5 |  5 | (0,11) | 37371420 |    0
(9 lignes)


                

*/