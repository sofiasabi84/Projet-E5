const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');

const app = express();
const port = 3000;

// Middleware pour parser le body des requêtes en JSON
app.use(bodyParser.json());

// Configuration de la connexion à MySQL
const db = mysql.createConnection({
  host: '10.52.2.100', // Remplacez par l'IP de votre serveur MySQL
  user: 'sofia',         // Nom d'utilisateur de la base de données
  password: 'sofia',     // Mot de passe de la base de données
  database: 'administrateur'            // Nom de la base de données
});

// Connexion à MySQL
db.connect((err) => {
  if (err) {
    console.error('Erreur de connexion à MySQL:', err);
    return;
  }
  console.log('Connecté à la base de données MySQL');
});

// verifier la connexion à la base de données
app.get('/user', (req, res) => {
  const sql = 'SELECT * FROM utilisateur';
  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).send(err);
    }
    res.json(results);
  });
});

// Endpoint pour ajouter une nouvelle nation
app.post('/inscription', async (req, res) => {
  const { email, password, confirm_password, nom, prenom} = req.body;

  try {
    const hashPassword = await bcrypt.hash(password, 10);

    const sql ='INSERT INTO utilisateur (email, password, confirm_password, nom, prenom) VALUES (?, ?, ?, ?, ?)';
    db.query(sql, [email, hashPassword, confirm_password, nom, prenom], (err, result) => {
      if (err) {
        return res.status(500).send(err);
      }
      res.json({ id: result.insertId, email, password, confirm_password, nom, prenom });
    });
  } catch (error) {
    res.status(500).send('Erreur lors de l\'inscription');
  }
});

// Routes pour gérer la connexion
app.post('/connexion', async (req, res) => {
    const { email, password } = req.body;
  
    if (!email || !password) {
      return res.status(400).json({ message: 'Email et mot de passe requis' });
    }
    const sql = 'SELECT * FROM `utilisateur` WHERE email = ?';
    db.query(sql, [email], async (err, results) => {
      if (err) {
        return res.status(500).send(err);
      }
      if (results.length === 0) {
        return res.status(401).json({ message: 'Email ou mot de passe incorrect' });
      }
  
      const utilisateur = results[0];
  
      bcrypt.compare(password, utilisateur.password, (err, result) => {
        if (err) {
          return res.status(500).send(err);
        }
        if (!result) {
          return res.status(401).json({ message: 'Email ou mot de passe incorrect' });
        }
  
        res.json({ message: 'Connexion réussie', utilisateur });
  
      });
    });
  });
  

// Démarrage du serveur
app.listen(port, () => {
  console.log(`Serveur API en écoute sur http://localhost:${port}`);
});
