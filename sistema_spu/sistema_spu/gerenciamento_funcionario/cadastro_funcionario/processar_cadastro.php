<?php
include '../../conexao.php';

$response = ['status' => 'error', 'message' => ''];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nome = $_POST['nome'];
    $email = $_POST['email'];
    $senha = $_POST['senha'];
    $cargo = $_POST['cargo'];
    $departamento = $_POST['departamento'];
    $dataAdmissao = $_POST['dataAdmissao'];
    $status = $_POST['status'];

    // Insere o funcionário
    $sqlFuncionario = "INSERT INTO funcionarios (nome, email, senha, cargo, departamento, data_admissao, status) 
                       VALUES ('$nome', '$email', '$senha', '$cargo', '$departamento', '$dataAdmissao', '$status')";
    if ($conexao->query($sqlFuncionario) === TRUE) {
        $idFuncionario = $conexao->insert_id; // Obtém o ID do funcionário

        // Processa os documentos enviados
        if (!empty($_FILES['documentos']['name'])) {
            foreach ($_FILES['documentos']['name'] as $tipoDocumento => $nomeArquivo) {
                if ($_FILES['documentos']['error'][$tipoDocumento] === UPLOAD_ERR_OK) {
                    if (!is_dir('uploads')) {
                        mkdir('uploads', 0777, true);
                    }
                    $caminhoDestino = 'uploads/' . basename($nomeArquivo);

                    if (move_uploaded_file($_FILES['documentos']['tmp_name'][$tipoDocumento], $caminhoDestino)) {
                        $sqlDocumento = "INSERT INTO documentos_funcionario (id_funcionario, tipo_documento, caminho_arquivo) 
                                         VALUES ('$idFuncionario', '$tipoDocumento', '$caminhoDestino')";
                        $conexao->query($sqlDocumento);
                    }
                }
            }
        }
        $response['status'] = 'success';
        $response['message'] = 'Funcionário cadastrado com sucesso!';
    } else {
        $response['message'] = 'Erro ao cadastrar funcionário: ' . $conexao->error;
    }
}

header('Content-Type: application/json');
echo json_encode($response);
?>
