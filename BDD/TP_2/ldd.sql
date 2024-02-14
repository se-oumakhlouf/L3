DROP TABLE if exists truc;

BEGIN;

CREATE TABLE truc(
    id serial primary key,
    a int
);

-- la table est initialisée

-- ROLLBACK;
-- la table disparait après le ROLLBACK

-- COMMIT;
-- la table est toujours présente