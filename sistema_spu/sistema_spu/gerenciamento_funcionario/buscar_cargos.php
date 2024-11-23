<?php
include '../conexao.php'; // Caminho correto para o arquivo de conexão

// Consulta para obter os cargos distintos
$sql = "SELECT DISTINCT cargo FROM funcionarios";
$result = $conexao->query($sql);

$cargos = [];
if ($result) {
    while ($row = $result->fetch_assoc()) {
        $cargos[] = $row['cargo'];
    }
}

// Define o tipo de resposta como JSON
header('Content-Type: application/json');
echo json_encode($cargos);
?>
