<?php
include '../conexao.php';

$sql = "SELECT 
            p.id_pagamento, 
            f.nome, 
            DATE_FORMAT(p.data_pagamento, '%d/%m/%Y') AS data_pagamento_formatada, 
            p.tipo_servico, 
            f.cargo, 
            p.valor, 
            p.status 
        FROM pagamentos p
        INNER JOIN funcionarios f ON p.id_funcionario = f.id_funcionario
        ORDER BY 
            CASE
                WHEN p.status = 'pago' THEN 2
                ELSE 1
            END,
            CASE
                WHEN p.data_pagamento >= CURDATE() THEN 1
                ELSE 2
            END,
            p.data_pagamento ASC;
";

$result = $conexao->query($sql);

$pagamentos = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $pagamentos[] = $row;
    }
}

header('Content-Type: application/json');
echo json_encode($pagamentos);
?>
