DROP TABLE if EXISTS test CASCADE;

CREATE TABLE test(
    id serial primary key,
    a int,
    b int
);

INSERT INTO test(a, b) values (1, 1), (2, 2);

/* Question 2 :

    Prédiction : Une erreur

        T2 attend T1 pour modifier (1, 1)
        et T1 attend T2 pour modifier (2, 2)

    On observe une erreur, deadlock (bloquage mortel)

    L'erreur survient aussi en REPEATABLE READ
*/


/* Question 3 :

    (en read committed)
    Prédiction : (3, 1) (4, 2)

    -- BEGIN TRANSACTION isolation level REPEATABLE READ;

    Résultat : (2, 1) (3, 2)
    Pour l'update de T2 : 
        ERREUR:  n'a pas pu sérialiser un accès à cause d'une mise à jour en parallèle
        -> ROLLBACK

    Seules les données validées (par un commit) peuvent être lues
    Deux lectures de la même données renvoient la même valeur 
        (en repeatable read)

*/


/* Question 4 : 

    Prediction : On supprime la deuxième ligne 
        car T1 n'est pas commit avant T2

    Résultat : (2, 1) (3, 2) Rien n'est supprimé ce que je trouve surprenant

    T2 marque au début les endroits où a = 2
    puis supprime à la fin si ces mes endroits ont a = 2
    mais ne supprime de lignes non marqués

    On aurait pu imaginer que T2 supprime les lignes où
    a = 2 à la fin

*/