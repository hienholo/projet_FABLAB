const sqlite3 = require('sqlite3').verbose();
const path = require('path');

// Chemin vers la base de données SQLite
const dbPath = path.join(__dirname, 'db', 'bdd.db');

const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Erreur lors de la création/connexion à la base de données :', err);
    process.exit(1); // Arrêter le serveur si une erreur critique se produit
  } else {
    console.log('Connexion à la base de données SQLite réussie.');
  }
});


function getAllLocks() {
    return new Promise((resolve, reject) => {
      db.all('SELECT * FROM porte', [], (err, rows) => {
        if (err) {
          reject(err);
        } else {
          resolve(rows);
        }
      });
    });
}
function getCardIdByUID(uid) {
    return new Promise((resolve, reject) => {
      const query = 'SELECT id_carte AS id FROM carte WHERE code = ?';
      db.get(query, [uid], (err, row) => {
        if (err) {
          reject(err);
        } else {
          resolve(row?.id ?? null);
        }
      });
    });
}
function getAuthorizationEndDate(cardId) {
    return new Promise((resolve, reject) => {
      const query = 'SELECT date_fin AS date FROM utilisateur WHERE id_carte = ?';
      db.get(query, [cardId], (err, row) => {
        if (err) {
          reject(err);
        } else {
          resolve(row?.date ?? null);
        }
      });
    });
}
function getAccessHours(cardId) {
    return new Promise((resolve, reject) => {
      const query = `
        SELECT heure_debut, heure_fin 
        FROM role_porte 
        WHERE id_role = (SELECT id_role FROM utilisateur WHERE id_carte = ?)
      `;
      db.get(query, [cardId], (err, row) => {
        if (err) {
          reject(err);
        } else {
          resolve(row || null);
        }
      });
    });
}
function getHistory() {
    return new Promise((resolve, reject) => {
        const query = `
            SELECT 
                historique.date AS date_historique, 
                porte.nom AS nom_porte, 
                utilisateur.nom AS nom_utilisateur,
                utilisateur.prenom AS prenom_utilisateur
            FROM historique
            INNER JOIN porte ON historique.id_porte = porte.id_porte
            INNER JOIN utilisateur ON historique.id_user = utilisateur.id_user
            ORDER BY historique.date;
        `;
        db.all(query, [], (err, rows) => {
            if (err) {
                reject(err);
            } else {
                resolve(rows);
            }
        });
    });
}
function getHistoryByUser(username) {
    return new Promise((resolve, reject) => {
        const query = `
            SELECT 
                historique.date AS date_historique, 
                porte.nom AS nom_porte, 
                utilisateur.nom AS nom_utilisateur,
                utilisateur.prenom AS prenom_utilisateur
            FROM historique
            INNER JOIN porte ON historique.id_porte = porte.id_porte
            INNER JOIN utilisateur ON historique.id_user = utilisateur.id_user
            WHERE utilisateur.username = ?
            ORDER BY historique.date DESC;
        `;
        db.all(query, [username], (err, rows) => {
            if (err) {
                reject(err);
            } else {
                resolve(rows);
            }
        });
    });
}
function getAllUsers() {
    return new Promise((resolve, reject) => {
      const query = `
        SELECT u.id_user, u.username, u.nom, u.prenom, u.date_debut, u.date_fin, u.desactive, r.nom AS role_nom, c.nom AS carte_nom
        FROM utilisateur u
        LEFT JOIN rôle r ON u.id_role = r.id_role
        LEFT JOIN carte c ON u.id_carte = c.id_carte
      `;
      
      db.all(query, (err, rows) => {
        if (err) {
          console.error('Erreur lors de la récupération des utilisateurs:', err);
          reject('Erreur lors de la récupération des utilisateurs');
        } else {
          resolve(rows || []);  // Renvoie un tableau vide si aucun résultat
        }
      });
    });
  }
function reactivateUser(username) {
    return new Promise((resolve, reject) => {
        const query = `
            UPDATE utilisateur
            SET date_fin = NULL, desactive=0
            WHERE username = ?;
        `;
        db.run(query, [username], function(err) {
            if (err) {
                reject(err);
            } else {
                resolve(true);
            }
        });
    });
}
function deactivateUser(username) {
    return new Promise((resolve, reject) => {
        const query = `
            UPDATE utilisateur
            SET date_fin = ?, desactive=1
            WHERE username = ?;
        `;
        const date_fin = new Date().toISOString().split('T')[0];  // Date du jour
        db.run(query, [date_fin, username], function(err) {
            if (err) {
                reject(err);
            } else {
                resolve(true);
            }
        });
    });
}
function addUser(username, nom, prenom, password, date_debut, date_fin, role, carte) {
    return new Promise((resolve, reject) => {
        const query = `
            INSERT INTO utilisateur (username, nom, prenom, mdp, date_debut, date_fin, id_role, id_carte)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?);
        `;
        db.run(query, [username, nom, prenom, password, date_debut, date_fin, role, carte], function(err) {
            if (err) {
                if (err.message.includes("UNIQUE constraint failed")) {
                    resolve('exists');  // Utilisateur déjà existant mais inactif
                } else {
                    reject(err);
                }
            } else {
                resolve('added');
            }
        });
    });
}
function getRoles() {
    return new Promise((resolve, reject) => {
      const query = 'SELECT * FROM rôle';  // Vérifiez que la table "rôle" contient des données
      db.all(query, (err, rows) => {
        if (err) {
          console.error('Erreur lors de la récupération des rôles:', err);
          reject('Erreur lors de la récupération des rôles');
        } else {
          resolve(rows || []);  // Renvoie un tableau vide si aucun résultat
        }
      });
    });
}
function getCartes() {
    return new Promise((resolve, reject) => {
      const query = 'SELECT * FROM carte';  // Vérifiez que la table "carte" contient des données
      db.all(query, (err, rows) => {
        if (err) {
          console.error('Erreur lors de la récupération des cartes:', err);
          reject('Erreur lors de la récupération des cartes');
        } else {
          resolve(rows || []);  // Renvoie un tableau vide si aucun résultat
        }
      });
    });
}
function getUserByUsername(username) {
  return new Promise((resolve, reject) => {
      db.get("SELECT * FROM utilisateur WHERE username = ?", [username], (err, row) => {
          if (err) {
            reject(err);
          } else {
            resolve(row);
          }
      });
  });
};
async function updateUser(username, nom, prenom, password, date_debut, date_fin, role, carte) {
  const query = password
      ? `UPDATE utilisateur SET nom = ?, prenom = ?, mdp = ?, date_debut = ?, date_fin = ?, id_role = ?, id_carte = ? WHERE username = ?`
      : `UPDATE utilisateur SET nom = ?, prenom = ?, date_debut = ?, date_fin = ?, id_role = ?, id_carte = ? WHERE username = ?`;

  const params = password
      ? [nom, prenom, password, date_debut, date_fin || null, role, carte, username]
      : [nom, prenom, date_debut, date_fin || null, role, carte, username];
  
  return new Promise((resolve, reject) => {
      db.run(query, params, function (err) {
        if (err) reject(err);
        else resolve(this.changes > 0);
      });
  });
}
function VerifiePassword(username) {
  return new Promise((resolve, reject) => {
    db.get("SELECT utilisateur.id_user, utilisateur.username, utilisateur.mdp, rôle.nom AS role FROM utilisateur JOIN rôle ON utilisateur.id_role = rôle.id_role WHERE utilisateur.username = ?", [username], (err, row) => {
        if (err) {
          reject(err);
        } else {
          resolve(row);
        }
    });
});
}
function GetUserByUID(cardId) {
  return new Promise((resolve, reject) => {
    const query = `SELECT id_user FROM utilisateur WHERE id_carte = ?;`;
    
    db.get(query,[cardId], (err, row) => {
      if (err) {
        console.error('Erreur lors de la récupération des utilisateurs:', err);
        reject('Erreur lors de la récupération des utilisateurs');
      } else {
        resolve(row?.id_user || null);  // Renvoie un tableau vide si aucun résultat
      }
    });
  });
}
function GetPorteByRole(roleID) {
  return new Promise((resolve, reject) => {
    const query = `SELECT id_porte FROM role_porte WHERE id_role = ?;`;
    
    db.get(query,[roleID], (err, row) => {
      if (err) {
        console.error('Erreur lors de la récupération des utilisateurs:', err);
        reject('Erreur lors de la récupération des utilisateurs');
      } else {
        resolve(row?.id_porte || null);  // Renvoie un tableau vide si aucun résultat
      }
    });
  });
}
function GetRoleByUID(cardID) {
  return new Promise((resolve, reject) => {
    const query = `SELECT id_role FROM utilisateur WHERE id_carte = ?;`;
    
    db.get(query,[cardID], (err, row) => {
      if (err) {
        console.error('Erreur lors de la récupération des utilisateurs:', err);
        reject('Erreur lors de la récupération des utilisateurs');
      } else {
        resolve(row?.id_role || null);  // Renvoie un tableau vide si aucun résultat
      }
    });
  });
}
function AjoutAccesHistorique(date, id_user, id_porte) {
  return new Promise((resolve, reject) => {
    const query = `INSERT INTO historique (date, id_user, id_porte) VALUES (?, ?, ?);`;

    db.run(query, [date, id_user, id_porte], function (err) {
      if (err) {
        console.error('Erreur lors de l\'insertion dans l\'historique:', err);
        reject('Erreur lors de l\'insertion dans l\'historique');
      } else {
        resolve(this.lastID); // Renvoie l'ID de la ligne insérée
      }
    });
  });
}

 module.exports = {
  getCardIdByUID,
  getAuthorizationEndDate,
  getAccessHours,
  getAllLocks,
  getHistory,
  getHistoryByUser,
  getAllUsers,
  reactivateUser,
  deactivateUser,
  addUser,
  getRoles,
  getCartes,
  getUserByUsername,
  updateUser,
  VerifiePassword,
  GetUserByUID,
  GetPorteByRole,
  GetRoleByUID,
  AjoutAccesHistorique
}