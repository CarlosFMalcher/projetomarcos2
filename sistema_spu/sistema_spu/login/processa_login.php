<?php
// Inclui o arquivo de conexão
require '../conexao.php';

// Verifica se o formulário foi enviado
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Recupera os dados do formulário
    $email = $_POST['email'];
    $senha = $_POST['senha'];
    $tipo_usuario = $_POST['tipo_usuario'];

    // Proteção contra SQL Injection
    $email = $conexao->real_escape_string($email);
    $senha = $conexao->real_escape_string($senha);
    $tipo_usuario = $conexao->real_escape_string($tipo_usuario);

    // Consulta para verificar o usuário
    $sql = "SELECT * FROM usuarios WHERE email = '$email' AND tipo_usuario = '$tipo_usuario'";
    $resultado = $conexao->query($sql);

    if ($resultado->num_rows > 0) {
        $usuario = $resultado->fetch_assoc();

        // Verifica a senha simples
        if ($senha === $usuario['senha']) {
            session_start();
            $_SESSION['usuario'] = $usuario;
            header("Location: /sistema_spu/dashboard/dashboard.html");
            exit();
        } else {
            echo "<script>alert('Senha incorreta.'); window.location.href = 'login.html';</script>";
        }
    } else {
        echo "<script>alert('Usuário não encontrado ou tipo de usuário incorreto.'); window.location.href = 'login.html';</script>";
    }
} else {
    echo "<script>alert('Acesso inválido.'); window.location.href = 'login.html';</script>";
}
?>
