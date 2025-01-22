<?php
include 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'];
    $password = $_POST['password'];

    $stmt = $conn->prepare("SELECT * FROM admin WHERE email = :email AND password = :password");
    $stmt->bindParam(':email', $email);
    $stmt->bindParam(':password', $password);
    $stmt->execute();

    if ($stmt->rowCount() > 0) {
        echo json_encode(['status' => 'success', 'message' => 'Connexion réussie']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Identifiants incorrects']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Requête invalide']);
}
?>
