    -- Question 1

BEGIN TRANSACTION isolation level serializable;

-- Admin
select etat, nbmin, nbmax from partie where pid = 8;
    -- etat 'ouvert' sinon on arrete
select count(*) from demande where pid = 8;
    -- si on ne trouve pas un count entre nbmin et nbmax, on arrete

-- JOUEUR
select etat from partie where pid = 8;
    -- Si etat pas 'ouvert', on arrete
delete from demande where jid = 1 and pid = 8;

-- Admin
update partie set etat = 'fermé' where pid = 8;
update demande set statut = 'validé' where pid = 8;



    -- Question 2

BEGIN TRANSACTION isolation level serializable;

-- Joueur
select etat from partie where pid = 8;
    -- Si état est 'fermé' on arrete

-- Admin
select etat from partie where pid = 8;
    -- Si état est 'fermé' on arrete
update partie set etat = 'annulée' where pid = 8;
update demande set statut = 'refusé' where pid = 8;

-- Joueur
insert into demande(jid, pid) values (5, 8);



    -- Question 3

BEGIN TRANSACTION isolation level repeatable read;

-- Admin 1
select etat from partie where pid = 8;

-- Admin 2
select etat from partie where pid = 8;
update partie set etat = 'fermé' where pid = 8;
update demande set statut = 'validé' where pid = 8;    

-- Admin 1 
update partie set etat = 'annulée' where pid = 8;
update demande set statut = 'refusé' where pid = 8 and statut = 'en attente';



    -- Question 4



-- Joueur 1
BEGIN TRANSACTION isolation level serializable;
select etat from partie where pid = 1;
insert into demande(jid, pid) values (4, 1);

-- Joueur 2
BEGIN TRANSACTION isolation level serializable;
select etat from partie where pid = 1;
insert into demande(jid, pid) values (5, 1);
COMMIT;

-- Admin 
BEGIN TRANSACTION isolation level repeatable serializable;
select etat from partie where pid = 1;
update partie set etat = 'fermé' where pid = 1;
UPDATE demande 
SET statut = 'validé' WHERE jid IN (SELECT jid FROM demande WHERE pid = 1 ORDER BY date LIMIT 4);

-- Joueur 1
COMMIT;

-- Admin
update demande set statut = 'refusé' where pid = 1 and statut = 'en attente';
COMMIT;
