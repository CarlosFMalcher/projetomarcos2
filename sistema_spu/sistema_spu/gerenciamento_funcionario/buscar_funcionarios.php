<?php
include '../conexao.php'; // Incluindo a conexão com o banco de dados

$filtro = $_GET['filtro'] ?? 'todos';
$pesquisa = $_GET['pesquisa'] ?? '';

// Monta a consulta SQL com base nos parâmetros
$sql = "SELECT * FROM funcionarios WHERE 1=1";

if ($filtro !== 'todos') {
    $sql .= " AND departamento = ?";
}
if (!empty($pesquisa)) {
    $sql .= " AND nome LIKE ?";
}

// Prepara e executa a consulta com segurança
$stmt = $conexao->prepare($sql);

if ($filtro !== 'todos' && !empty($pesquisa)) {
    $searchTerm = "%$pesquisa%";
    $stmt->bind_param("ss", $filtro, $searchTerm);
} elseif ($filtro !== 'todos') {
    $stmt->bind_param("s", $filtro);
} elseif (!empty($pesquisa)) {
    $searchTerm = "%$pesquisa%";
    $stmt->bind_param("s", $searchTerm);
}

$stmt->execute();
$result = $stmt->get_result();

$funcionarios = [];
while ($row = $result->fetch_assoc()) {
    $funcionarios[] = $row;
}

// Retorna os dados como JSON
echo json_encode($funcionarios);
?>
