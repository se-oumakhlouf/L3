-- JOUEUR
BEGIN;
select etat from partie where pid = 8;
    -- Si etat pas 'ouvert', on arrete
delete from demande where jid = 1 and pid = 8;

-- Admin
BEGIN;
select etat, nbmin, nbmax from partie where pid = 8;
    -- etat 'ouvert' sinon on arrete
select count(*) from demande where pid = 8;
    -- si on ne trouve pas un counr entre nbmin et nbmax, on arrete
update partie set etat = 'fermé' where pid = 8;
update demande set statu = 'validé' where pid = 8;
