<?php
require '../conexao.php'; // Inclua o arquivo de conexão com o banco de dados

// Dados do gráfico de pagamentos por departamento
$sqlPagamentos = "SELECT departamento, SUM(valor) AS total FROM pagamentos 
                  JOIN funcionarios ON pagamentos.id_funcionario = funcionarios.id_funcionario 
                  GROUP BY departamento";
$resultPagamentos = $conexao->query($sqlPagamentos);

$graficoPagamentos = [];
if ($resultPagamentos->num_rows > 0) {
    while ($row = $resultPagamentos->fetch_assoc()) {
        $graficoPagamentos['labels'][] = $row['departamento'];
        $graficoPagamentos['valores'][] = $row['total'];
    }
}

// Dados do gráfico de quantidade de funcionários por departamento
$sqlFuncionarios = "SELECT departamento, COUNT(*) AS total FROM funcionarios GROUP BY departamento";
$resultFuncionarios = $conexao->query($sqlFuncionarios);

$graficoFuncionarios = [];
if ($resultFuncionarios->num_rows > 0) {
    while ($row = $resultFuncionarios->fetch_assoc()) {
        $graficoFuncionarios['labels'][] = $row['departamento'];
        $graficoFuncionarios['valores'][] = $row['total'];
    }
}

// Retorna os dados em formato JSON
header('Content-Type: application/json');
echo json_encode([
    'graficoPagamentos' => $graficoPagamentos,
    'graficoFuncionarios' => $graficoFuncionarios,
]);

$conexao->close();
?>
