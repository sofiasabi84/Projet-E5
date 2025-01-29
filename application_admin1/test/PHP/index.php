<?php
$host = 'localhost'; // Nom de l'hôte (ou adresse IP du serveur)
$db_name = 'administrateur'; // Nom de votre base de données
$username = 'sofia'; // Nom d'utilisateur pour MySQL
$password = 'sofia'; // Mot de passe pour MySQL

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Erreur de connexion : " . $e->getMessage());
}
?>
