const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const jwt = require('jwt-simple');
const bcrypt = require('bcryptjs');
const bodyParser = require('body-parser');


const app = express();
app.use(bodyParser.json());

// Connexion à la base SQLite
const db = new sqlite3.Database('fablab.db', (err) => {
    if (err) console.error(err.message);
    console.log('Connecté à la base SQLite.');
});

// Clé secrète JWT

const SECRET_KEY = '111011101110111';

//  Route Login
app.post('/login', (req, res) => {
    const { username, mdp } = req.body;
    db.get('SELECT * FROM utilisateur WHERE username = ?', [username], (err, user) => {
        if (err) return res.status(500).json({ error: err.message });
        if (!user || !bcrypt.compareSync(mdp, user.mdp)) {
            return res.status(401).json({ error: 'Identifiants incorrects' });
        }
        const token = jwt.encode({ id_user: user.id_user, role: user.id_role }, SECRET_KEY);
        res.json({ token });
    });
});

// Route Protégée
app.get('/protected', (req, res) => {
    const token = req.headers['authorization']?.split(' ')[1];
    if (!token) return res.status(401).json({ error: 'Token manquant' });

    try {
        const decoded = jwt.decode(token, SECRET_KEY);
        db.get('SELECT * FROM utilisateur WHERE id_user = ?', [decoded.id_user], (err, user) => {
            if (err || !user) return res.status(401).json({ error: 'Utilisateur invalide' });
            res.json({ message: 'Accès autorisé', user });
        });
    } catch (error) {
        res.status(401).json({ error: 'Token invalide' });
    }
});

// Démarrer le serveur
app.listen(3000, () => {
    console.log('Serveur démarré sur http://'+config.ip+':3000');
});
