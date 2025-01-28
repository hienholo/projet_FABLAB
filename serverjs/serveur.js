const express = require('express');
const path = require('path');
const session = require('express-session');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');
const {
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
} = require('./function_db');

const app = express();
const PORT = 33000;

// Configuration des sessions
app.use(session({
  secret: 'votre_secret_session',
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false } // Assurez-vous de passer à `true` en production si HTTPS est activé
}));
// Middleware pour servir les fichiers statiques
app.use(express.static(path.join(__dirname, 'public')));
// Middleware pour analyser les données POST (si besoin)
app.use(express.urlencoded({ extended: true }));
//Middleware pour initialiser l'utilisateur connecté
app.use((req, res, next) => {
  res.locals.isLoggedIn = req.session?.isLoggedIn || false; // Détermine si l'utilisateur est connecté
  res.locals.role = req.session?.role || null; // Récupère le rôle de l'utilisateur
  res.locals.username = req.session?.username  || null
  next();
});
// Middleware pour le parsing des formulaires
app.use(bodyParser.urlencoded({ extended: true }));
// Middleware pour log des requêtes (optionnel, utile pour le debug)
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});
// Gestion des erreurs non capturées
app.use((err, req, res, next) => {
  console.error('Erreur inattendue :', err);
  res.status(500).json({ status: 'error', message: 'Erreur inattendue' });
});

app.set('views', __dirname + "\\views");
app.set('view engine', '.ejs'); // Vous pouvez aussi utiliser "pug" ou "handlebars" si besoin

// Différentes Routes : 
app.get('/', (req, res) => {
  res.render('index', {
    isLoggedIn: req.session?.isLoggedIn,
    username: req.session?.username,
    role: req.session?.role
  });
});
app.get('/login', (req, res) => {
  res.render('login', {
    isLoggedIn: req.session?.isLoggedIn,
    role: req.session?.role ,
    message: null
  });
});
app.post('/login', async (req, res) => {
  const { username, password } = req.body;

  try {
      const user = await VerifiePassword(username);

      if (user) {
          const isPasswordValid = await bcrypt.compare(password, user.mdp);

          if (isPasswordValid) {
              req.session.isLoggedIn = true;
              req.session.role = user.role; // Ou utilisez le nom du rôle
              req.session.username = user.username;
              return res.redirect('/');
          }
      }

      res.render('login', { message: 'Identifiants invalides. Veuillez réessayer.' });
  } catch (err) {
      console.error("Erreur lors de la vérification :", err);
      res.render('login', { message: 'Erreur interne. Veuillez réessayer plus tard.' });
  }
});
app.get('/logout', (req, res) => {
  req.session.isLoggedIn = false; // L'utilisateur est maintenant connecté
  req.session.role = null;
  req.session.username = null
  res.redirect('/');
});
app.get('/dashboard', async (req, res) => {
  try {
    const locks = await getAllLocks();
    res.render('dashboard', { locks });
  } catch (error) {
    console.error('Erreur lors de la récupération des serrures:', error);
    res.render('dashboard', { locks: [] });
  }
});
app.get('/historique', async (req, res) => {
  try {
    let history;
    if (req.session.role === 'admin') {
        history = await getHistory(); // Fonction pour récupérer tout l'historique
    } else {
        history = await getHistoryByUser(req.session.username); // Fonction pour l'utilisateur connecté
    }

    // Extraire les utilisateurs et les portes pour les filtres
    const users = [...new Set(history.map(entry => entry.nom_utilisateur))];
    const doors = [...new Set(history.map(entry => entry.nom_porte))];

    // Rendre la page avec les données
    res.render('historique', {
        history,
        users,
        doors,
        isAdmin: req.session.role === 'admin'
    });
} catch (err) {
    console.error("Erreur lors de la récupération de l'historique :", err.message);
    res.status(500).send("Erreur serveur.");
}
});
app.get('/users', (req, res) => {
  // Appel des fonctions avec des Promises
  getAllUsers()
    .then(users => {
      return Promise.all([users, getRoles(), getCartes()]);  // Attendre que les 3 Promises soient résolues
    })
    .then(([users, roles, cartes]) => {
      res.render('users', {
        users,
        roles,
        cartes,
        message: req.query.message,
        error_message: req.query.error_message,
        currentDate: new Date().toISOString().split('T')[0]  // Format de la date pour input
      });
    })
    .catch(error => {
      console.error(error);  // Affiche l'erreur dans la console
      res.status(500).send('Erreur lors de la récupération des utilisateurs');
    });
});
app.post('/users', async (req, res) => {
  if (req.body.action === 'add') {
      const { username, nom, prenom, mdp, date_debut, date_fin, role, carte } = req.body;
      let hashedPassword = await bcrypt.hash(mdp, 10);
      const success = await addUser(username, nom, prenom, hashedPassword, date_debut, date_fin, role, carte);

      if (success === 'exists') {
          res.redirect(`/users?error_message=Cet utilisateur existe déjà `);
      } else if (success === 'added') {
          res.redirect('/users?message=Utilisateur ajouté avec succès');
      } else {
          res.redirect('/users?error_message=Erreur lors de l\'ajout de l\'utilisateur');
      }
  }

  if (req.body.action === 'delete' && req.body.username) {
      const success = await deactivateUser(req.body.username);
      if (success) {
          res.redirect('/users?message=Utilisateur désactivé avec succès');
      } else {
          res.redirect('/users?error_message=Erreur lors de la désactivation de l\'utilisateur');
      }
  }

  if (req.body.action === 'reactive' && req.body.username) {
    const success = await reactivateUser(req.body.username);
    if (success) {
        res.redirect('/users?message=Utilisateur résactivé avec succès');
    } else {
        res.redirect('/users?error_message=Erreur lors de la réactivation de l\'utilisateur');
    }
  }
  if (req.body.action === 'edit' && req.body.username) {
      res.redirect(`/edit_users?username=${req.body.username}`);
  }
  
});
app.get('/edit_users', (req, res) => {
  const { username } = req.query;
  if (!username) {
      return res.redirect('/users?error_message=Utilisateur introuvable');
  }
  // Récupération des données de l'utilisateur
  getUserByUsername(username)
      .then(user => {
          if (!user) {
              return res.redirect('/users?error_message=Utilisateur introuvable');
          }

          return Promise.all([user, getRoles(), getCartes()]);
      })
      .then(([user, roles, cartes]) => {
          res.render('edit_users', {
              user,
              roles,
              cartes,
              errorMessage: null
          });
      })
      .catch(error => {
          console.error(error);
          res.status(500).send('Erreur lors de la récupération des données utilisateur');
      });
});
app.post('/edit_users', async (req, res) => {
  const { username, nom, prenom, mdp, date_debut, date_fin, role, carte } = req.body;

  if (!username || !nom || !prenom || !date_debut || !role || !carte) {
      return res.redirect('/users?error_message=Tous les champs obligatoires ne sont pas remplis.');
  }

  let hashedPassword = null;

    if (mdp) {
        try {
            const saltRounds = 10; // Plus le nombre est élevé, plus c'est sécurisé (et lent)
            hashedPassword = await bcrypt.hash(mdp, saltRounds);
        } catch (err) {
            console.error("Erreur lors du hashage du mot de passe :", err);
            return res.redirect('/users?error_message=Erreur interne.');
        }
    }

  const success = await updateUser(username, nom, prenom, hashedPassword, date_debut, date_fin, role, carte);
  if (success) {
      res.redirect('/users?message=Utilisateur mis à jour avec succès');
  } else {
      res.redirect('/users?error_message=Erreur lors de la mise à jour de l\'utilisateur');
  }
});



app.get('/check-badge', async (req, res) => {
  const uid = req.query.uid;

  if (!uid) {
    console.warn('UID manquant dans la requête.');
    return res.status(400).json({ status: 'error', message: 'UID manquant' });
  }

  try {
    // Étape 1 : Vérification de l'UID existent dans la base
    const cardId = await getCardIdByUID(uid);
    if (!cardId) {
      console.log(`Badge ${uid} non autorisé.`);
      return res.json({ status: 'fail', message: 'Badge non autorisé' });
    }

    // Étape 2 : Vérification de la date de fin si l'uid de la carte correspond à un utilisateur qui a accès à la porte
    const authorizationEndDate = await getAuthorizationEndDate(cardId);
    const currentDate = getCurrentDate();
    if (authorizationEndDate && new Date(authorizationEndDate) <= new Date(currentDate)) {
      console.log(`Badge ${uid} non autorisé (date expirée).`);
      return res.json({ status: 'fail', message: 'Badge non autorisé' });
    }

    // Étape 3 : Vérification des heures d'accès si la porte n'est pas vérouillé 
    const accessHours = await getAccessHours(cardId);
    if (!accessHours) {
      console.log(`Badge ${uid} non autorisé (aucune heure définie).`);
      return res.json({ status: 'fail', message: 'Badge non autorisé' });
    }

    const currentHour = new Date().getHours();
    const startHour = parseTimeString(accessHours.heure_debut).getHours();
    const endHour = parseTimeString(accessHours.heure_fin).getHours();

    if (currentHour >= startHour && currentHour < endHour) {
      // Ajout dans la base de donnée de l'accès de l'utilisateur
      const dates = getCurrentDateWithHour();
      const id_user = await GetUserByUID(cardId);
      const id_role = await GetRoleByUID(cardId)
      const id_porte = await GetPorteByRole(id_role)
      await AjoutAccesHistorique(dates,id_user,id_porte);
      console.log(`Badge ${uid} autorisé.`);
      return res.json({ status: 'success', message: 'Badge autorisé' });
    } else {
      console.log(`Badge ${uid} non autorisé (hors des heures d'accès).`);
      return res.json({ status: 'fail', message: 'Badge non autorisé' });
    }
  } catch (error) {
    console.error('Erreur lors de la vérification du badge :', error);
    return res.status(500).json({ status: 'error', message: 'Erreur interne du serveur' });
  }
});
const getCurrentDate = () => {
  const date = new Date();
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // Les mois commencent à 0
  const day = String(date.getDate()).padStart(2, '0');

  return `${year}-${month}-${day}`;
};
const getCurrentDateWithHour = () => {
  const date = new Date();
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0'); // Les mois commencent à 0
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0'); // Ajout des heures
  const minutes = String(date.getMinutes()).padStart(2, '0'); // Ajout des minutes
  const seconds = String(date.getSeconds()).padStart(2, '0'); // Ajout des secondes

  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
};
function parseTimeString(timeString) {
  // Extraire les heures et les minutes
  const timeParts = timeString.replace('H', ':').split(':');
  const hours = parseInt(timeParts[0], 10); // Partie des heures
  const minutes = timeParts[1] ? parseInt(timeParts[1], 10) : 0; // Partie des minutes (par défaut 0)
  // Créer un objet Date représentant cette heure aujourd'hui
  const now = new Date();
  now.setHours(hours, minutes, 0, 0); // Réglage des heures, minutes, secondes, millisecondes
  return now;
}



// Démarrer le serveur
app.listen(PORT, () => {
  console.log(`Serveur en écoute sur http://192.168.221.249:33000/`);
});
