<?php
header('Content-Type: application/json');

// Inclui a conexão com o banco de dados
require '../conexao.php';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$banco", $usuario, $senha);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Erro na conexão com o banco de dados.']);
    exit;
}

// Verifica se o método HTTP é POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Método inválido. Use POST.']);
    exit;
}

// Captura os dados enviados
$input = json_decode(file_get_contents('php://input'), true);

if (!isset($input['id_funcionario'], $input['nome'], $input['cargo'], $input['departamento'], $input['data_admissao'], $input['status'])) {
    echo json_encode(['success' => false, 'message' => 'Dados incompletos.']);
    exit;
}

// Atribui os dados às variáveis
$id_funcionario = $input['id_funcionario'];
$nome = $input['nome'];
$cargo = $input['cargo'];
$departamento = $input['departamento'];
$data_admissao = $input['data_admissao'];
$status = $input['status'];

try {
    // Atualiza o registro no banco de dados
    $query = "UPDATE funcionarios SET nome = :nome, cargo = :cargo, departamento = :departamento, data_admissao = :data_admissao, status = :status WHERE id_funcionario = :id_funcionario";
    $stmt = $pdo->prepare($query);

    $stmt->bindParam(':nome', $nome);
    $stmt->bindParam(':cargo', $cargo);
    $stmt->bindParam(':departamento', $departamento);
    $stmt->bindParam(':data_admissao', $data_admissao);
    $stmt->bindParam(':status', $status);
    $stmt->bindParam(':id_funcionario', $id_funcionario, PDO::PARAM_INT);

    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'Funcionário atualizado com sucesso.']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Erro ao atualizar o funcionário.']);
    }
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Erro ao executar a consulta.']);
}

?>