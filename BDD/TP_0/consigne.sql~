--  TP d'échauffement. Ce TP avait originellement servi de TP noté en filière INFO 1 à l'ESIPE.
--
--	Consigne originale
-----------------------
--	Utilisez le script soiree_exam.sql afin de créer la base de données qui sera utilisée pour les questions suivantes.
--	Prenez le temps de vous familiariser avec les différentes tables et leur contenu avant de commencer à répondre aux questions.
--	Pour chaque question, donnez la requête SQL permettant d'obtenir le résultat demandé. 
--  Ajoutez en commentaire le nombre de lignes renvoyées par cette requête. Si la requête renvoie une seule ligne, précisez également la ligne renvoyée.
--  Soignez la présentation (indentation, nom des variables, etc.) de vos requêtes. La lisibilité de votre travail sera prise en compte.
--	A la fin du TP, déposez votre fichier dans la zone de rendu prévue à cet effet sur elearning.
--  Pensez à enregistrer régulièrement votre travail afin de ne pas le perdre en cas de panne.
--
--
--1. La liste de toutes les personnes, avec tous leurs attributs.
	select * from personne;
	-- 1000 lignes

--2. La liste des villes où il y a une soirée, sans doublons.
	select distinct lieu from soiree;
	-- 28 lignes


--3. La liste des modèles de déguisements que l'on peut acheter pour moins de 24 euros.
	select modele from vendre
	where prix < 24;
	-- 33 lignes

--4. La personne la plus jeune inscrite dans la base de données.
	select * from personne
	order by age limit 1; 
	-- 1 ligne : 
	--  surnom |  nom   | prenom  | age | taille 
	--  ------+--------+---------+-----+--------
 	--  tal714 | Ivanov | Talissa |  10 |    115


--5. La liste des magasins qui vendent le costume ang82.
	select nomMag from vendre
	where modele = 'ang82';
	-- 0 ligne


--6. Les soirées (idS, lieu, date) où au moins une personne ne porte pas de déguisement.
	select distinct participe.idS, lieu, date from participe natural join soiree
	where avatar is NULL;
	-- 30 lignes
	

--7. Les personnes (surnom, nom, prenom) qui ont participé à la fois à une soirée à Marseille et à une soirée à Reims.
	select surnom, nom, prenom from participe natural join personne natural join soiree
	where lieu = 'Marseille'
	intersect
	select surnom, nom, prenom from participe natural join personne natural join soiree
	where lieu = 'Reims';
	-- 0 ligne car il n'y a aucune soirée à Reims


--8. Les costumes (modele, avatar) que l'on ne trouve pas en taille XL.
	select distinct modele, avatar from vendre natural join deguisement
	where taille <> 'XL';
	-- 49 lignes


--9. Les personnes (surnom, prenom, nom) qui sont allées à une soirée (idS) déguisées en un personnage portant leur prénom.
	select surnom, prenom, nom from participe natural join personne
	where prenom like avatar;
	-- 1 ligne : 
	-- surnom | prenom |   nom   
	--	--------+--------+---------
 	-- aur375 | Aurore | Scherer


--10. La liste des personnes (surnom) qui sont allées à une soirée à Paris en étant déguisées en Jon Snow.
	select surnom from participe natural join soiree
	where lieu = 'Paris'
	AND avatar = 'Jon Snow';
	-- 1 ligne
	 /* 
	 	surnom 
		--------
 		emi923 
 		*/



--11*. Le prix le plus bas d'un costume de vampire.
	select prix from deguisement natural join vendre
	where avatar = 'vampire'
	order by prix limit 1;
	-- O ligne
	-- aucun costume de vampire n'est a vendre dans la base de données


--12*. La liste des soirées (ids, lieu, date) qui ont eu au moins 100 participants, triée par nombre de participants décroissant.
select idS, lieu, date from soiree natural join participe
group by idS
having count(idS) >= 100
order by count(idS) desc;
-- 0 ligne
-- la soirée avec le plus de participants a 94 participants


--13*. La liste des avatars disponibles dans le commerce avec pour chacun le nom du magasin le moins cher pour l'acheter (quel que soit le modèle ou la taille).
	select avatar, nomMag, min(prix) as prix from natura join vendre
	group by avatar, nomMag
	order by prix;
	-- faux, un prix par magasin avec ça, et non un prix par avatar


--14*. Le nombre de participants de chaque âge. La liste devra être ordonnée par âges croissants.



--15*. La liste de toutes les soirées (ids, lieu, date) avec pour chacune la recette totale des entrées, triée par recette décroissante.



--16*. La liste des soirées (ids, lieu, date), avec pour chacune le nombre total de participants, triée par nombre de participants décroissant.



--17*. La liste des villes où sont uniquement organisées des soirées de faible affluence (au plus 30 participants).



--18*. La liste des participants (surnom), avec pour chacun la fréquentation moyenne des soirées auxquelles il participe.



--19*. La liste des organisateurs de soirées (surnom, nom, prenom), avec pour chacun la date et le lieu de la soirée qui lui a rapporté le plus d'argent.



--20*. La liste des soirées (ids, lieu, date) où apparaissent tous les avatars qui sont disponibles dans au moins un magasin.



