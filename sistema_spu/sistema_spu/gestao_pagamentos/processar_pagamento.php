<?php
include '../conexao.php';

header('Content-Type: application/json'); // Define o tipo de retorno como JSON

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['status' => 'error', 'message' => 'Método inválido.']);
    exit;
}

try {
    // Recebe os dados do POST
    $idFuncionario = $_POST['id_funcionario'] ?? null;
    $idPagamento = $_POST['id_pagamento'] ?? null;
    $tipoPagamento = $_POST['tipo_pagamento'] ?? null;
    $comentario = $_POST['comentario'] ?? null;

    if (!$idPagamento) {
        echo json_encode(['status' => 'error', 'message' => 'ID de pagamento não fornecido.']);
        exit;
    }
    

    // Processa o comprovante, se enviado
    $caminhoComprovante = null;
    if (isset($_FILES['comprovante']) && $_FILES['comprovante']['error'] === 0) {
        $comprovante = $_FILES['comprovante'];
        $nomeArquivo = time() . '_' . basename($comprovante['name']);
        $caminhoComprovante = 'uploads/comprovantes/' . $nomeArquivo;

        // Cria o diretório se não existir
        if (!is_dir('uploads/comprovantes')) {
            mkdir('uploads/comprovantes', 0777, true);
        }

        if (!move_uploaded_file($comprovante['tmp_name'], $caminhoComprovante)) {
            echo json_encode(['status' => 'error', 'message' => 'Erro ao salvar o comprovante.']);
            exit;
        }
    }

    // Atualiza o pagamento no banco de dados
    $sqlPagamento = "UPDATE pagamentos SET status = 'pago' WHERE id_pagamento = ?";
    $stmtPagamento = $conexao->prepare($sqlPagamento);
    $stmtPagamento->bind_param('i', $idPagamento);
    $stmtPagamento->execute();

    // Insere o comprovante no banco de dados
    $sqlComprovante = "INSERT INTO comprovantes_pagamento (id_pagamento, id_funcionario, tipo_pagamento, comentario, caminho_comprovante)
                       VALUES (?, ?, ?, ?, ?)";
    $stmtComprovante = $conexao->prepare($sqlComprovante);
    $stmtComprovante->bind_param('iisss', $idPagamento, $idFuncionario, $tipoPagamento, $comentario, $caminhoComprovante);
    $stmtComprovante->execute();

    echo json_encode(['status' => 'success', 'message' => 'Pagamento realizado com sucesso.']);
} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => 'Erro no servidor: ' . $e->getMessage()]);
}
