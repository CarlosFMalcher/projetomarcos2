<?php
include '../conexao.php'; // Caminho correto para o arquivo de conexão

// Consulta para obter os departamentos distintos
$sql = "SELECT DISTINCT departamento FROM funcionarios";
$result = $conexao->query($sql);

$departamentos = [];
if ($result) {
    while ($row = $result->fetch_assoc()) {
        $departamentos[] = $row['departamento'];
    }
}

// Define o tipo de resposta como JSON
header('Content-Type: application/json');
echo json_encode($departamentos);
?>
