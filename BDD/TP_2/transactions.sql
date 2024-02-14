DROP TABLE IF EXISTS test CASCADE;

CREATE TABLE test(
    id serial primary key,
    a int,
    b int
);

INSERT INTO test(a, b) values (1, 2)
returning id; -- id = 1


-- INSERT INTO test(id, a, b) values (1, 3, 4); 

/*    
    ERREUR:  la valeur d'une clé dupliquée rompt la contrainte unique « test_pkey »
    DÉTAIL : La clé « (id)=(1) » existe déjà.
*/

BEGIN;
INSERT INTO test(a, b) values (1, 3);
INSERT INTO test(a,b) VALUES (1,4);
INSERT INTO test(a,b) VALUES (1,5);
SELECT * from test;
ROLLBACK;

-- Règle de l'atomicité : chaque transaction est effectuée en entier ou pas du
-- tout; pas d’exécutions partielles


/*
    BEGIN;
    INSERT INTO test(a, b) values (1, 3);
    INSERT INTO test(a,b) VALUES (1,4);
    INSERT INTO test(a,b) VALUES (1,5);
    SELECT * from test;
*/
-- fermeture du terminal pour simuler un crash
-- effet de ROLLBACK


BEGIN;
INSERT INTO test(a, b) values (1, 3);
INSERT INTO test(a,b) VALUES (1,4);
INSERT INTO test(a,b) VALUES (1,5);
SELECT * from test;
COMMIT;
-- id est incrémenter même après le rollback


BEGIN;
INSERT INTO test(a, b) values (2, 5);
INSERT INTO test(id, a, b) values (8, 9, 10);
-- erreur : duplication de primary key
SELECT * from test;
-- erreur : la transaction est annulée, les commandes sont ignoreées
--      jusqu'à la fin du bloc de la transaction
ROLLBACK;


BEGIN;
INSERT INTO test(a, b) values (2, 5);
INSERT INTO test(id, a, b) values (8, 9, 10);
-- erreur : duplication de primary key
SELECT * from test;
-- erreur : la transaction est annulée, les commandes sont ignoreées
--      jusqu'à la fin du bloc de la transaction
COMMIT;
-- nouveau BEGIN pour inserer les valeurs en changeant la 'PK'
-- puis COMMIT;
-- (2, 5) a pour id 9 et (9, 10) a pour id 8

