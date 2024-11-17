const express = require('express');
const bodyParser = require('body-parser');
const sqlite3 = require('sqlite3').verbose(); // SQLite3

const app = express();
const port = 3000;

// Ouvrir ou créer la base de données SQLite
const db = new sqlite3.Database('./esp_data.db', (err) => {
  if (err) {
    console.error('Erreur lors de l\'ouverture de la base de données', err.message);
  } else {
    console.log('Connecté à la base de données SQLite');
  }
});

// Créer la table si elle n'existe pas
db.run(`CREATE TABLE IF NOT EXISTS sensor_data (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    temperature REAL NOT NULL,
    humidity REAL NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)`);

// Middleware pour parser les données JSON
app.use(bodyParser.json());

// Point d'entrée pour recevoir les données de l'ESP32
app.post('/api/data', (req, res) => {
  const { temperature, humidity } = req.body;

  if (temperature !== undefined && humidity !== undefined) {
    // Insérer les données dans la table
    const query = `INSERT INTO sensor_data (temperature, humidity) VALUES (?, ?)`;
    db.run(query, [temperature, humidity], function(err) {
      if (err) {
        console.error('Erreur lors de l\'insertion dans la base de données', err.message);
        res.status(500).send('Erreur serveur');
      } else {
        res.status(200).send('Données enregistrées avec succès');
      }
    });
  } else {
    res.status(400).send('Données manquantes');
  }
});

// Lancer le serveur
app.listen(port, () => {
  console.log(`Serveur en écoute sur http://192.168.94.249:${port}`);
});
