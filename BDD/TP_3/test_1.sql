BEGIN;

-- Sélectionner le nombre de joueurs pour la partie donnée
SELECT COUNT(*) INTO nb_joueurs FROM demande WHERE pid = 8;

-- Sélectionner nbmin pour la partie donnée
SELECT nbmin INTO nb_min_partie FROM partie WHERE pid = 8 AND etat = 'ouvert';

-- Mettre à jour l'état de la partie si le nombre de joueurs est supérieur ou égal à nbmin
UPDATE partie SET etat = 'fermé' WHERE pid = 8 AND nb_joueurs >= nb_min_partie;

COMMIT;
