CREATE TABLE IF NOT EXISTS utilisateur (
    id_user INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    nom TEXT,
    prenom TEXT,
    mdp TEXT NOT NULL,
    date_debut TEXT NOT NULL,
    date_fin TEXT,
    id_role INTEGER NOT NULL,
    id_carte INTEGER NOT NULL,
    desactive BOOLEAN DEFAULT 0,
    FOREIGN KEY (id_role) REFERENCES rôle (id_role),
    FOREIGN KEY (id_carte) REFERENCES carte (id_carte)
);

CREATE TABLE IF NOT EXISTS rôle (
    id_role INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT
);

CREATE TABLE IF NOT EXISTS porte (
    id_porte INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT
);

CREATE TABLE IF NOT EXISTS historique (
    date TEXT,
    id_user INTEGER,
    id_porte INTEGER,
    PRIMARY KEY (id_user, id_porte,date),
    FOREIGN KEY (id_porte) REFERENCES porte (id_porte),
    FOREIGN KEY (id_user) REFERENCES utilisateur (id_user)
);

CREATE TABLE IF NOT EXISTS carte (
    id_carte INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT NOT NULL,
    nom TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS role_porte(
    id_role INTEGER NOT NULL,
    id_porte INTEGER NOT NULL,
    heure_debut TEXT,
    heure_fin TEXT,
    PRIMARY KEY (id_role, id_porte),
    FOREIGN KEY (id_role) REFERENCES rôle (id_role),
    FOREIGN KEY (id_porte) REFERENCES porte (id_porte)
);

INSERT OR IGNORE INTO rôle (id_role, nom)
VALUES (1, "RH"),(2,"developpeur"),(3,"administrateur");
