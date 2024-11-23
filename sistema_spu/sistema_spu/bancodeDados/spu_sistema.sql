-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 23/11/2024 às 02:06
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `spu_sistema`
--

DELIMITER $$
--
-- Procedimentos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `inserir_pagamento` (IN `p_id_usuario` INT, IN `p_data_pagamento` DATE, IN `p_valor` DECIMAL(10,2), IN `p_periodo` ENUM('diario','semanal','quinzenal','mensal'), IN `p_metodo` ENUM('dinheiro','transferencia','cartao'), IN `p_tipo_pagamento` ENUM('funcionario','prestador'))   BEGIN
    INSERT INTO pagamentos (id_usuario, data_pagamento, valor, periodo, metodo, tipo_pagamento)
    VALUES (p_id_usuario, p_data_pagamento, p_valor, p_periodo, p_metodo, p_tipo_pagamento);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `inserir_registro_ponto` (IN `p_id_usuario` INT, IN `p_data` DATE, IN `p_hora_entrada` TIME, IN `p_hora_saida` TIME, IN `p_status` ENUM('presente','ausente','atrasado'))   BEGIN
    INSERT INTO registros_ponto (id_usuario, data, hora_entrada, hora_saida, status)
    VALUES (p_id_usuario, p_data, p_hora_entrada, p_hora_saida, p_status);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `verificar_login` (IN `p_email` VARCHAR(100), IN `p_senha` VARCHAR(255))   BEGIN
    SELECT * 
    FROM usuarios 
    WHERE email = p_email AND senha = p_senha;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `auditoria_login`
--

CREATE TABLE `auditoria_login` (
  `id_auditoria` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `data_tentativa` timestamp NOT NULL DEFAULT current_timestamp(),
  `status_tentativa` enum('sucesso','falha') DEFAULT NULL,
  `ip_tentativa` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `auditoria_login`
--

INSERT INTO `auditoria_login` (`id_auditoria`, `id_usuario`, `data_tentativa`, `status_tentativa`, `ip_tentativa`) VALUES
(1, 1, '2024-11-20 13:00:00', 'sucesso', '192.168.0.1'),
(2, 2, '2024-11-20 13:10:00', 'falha', '192.168.0.2'),
(3, 3, '2024-11-20 13:20:00', 'sucesso', '192.168.0.3');

-- --------------------------------------------------------

--
-- Estrutura para tabela `comprovantes_pagamento`
--

CREATE TABLE `comprovantes_pagamento` (
  `id_comprovante` int(11) NOT NULL,
  `id_pagamento` int(11) NOT NULL,
  `id_funcionario` int(11) NOT NULL,
  `tipo_pagamento` varchar(50) DEFAULT NULL,
  `comentario` text DEFAULT NULL,
  `caminho_comprovante` varchar(255) DEFAULT NULL,
  `data_upload` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `documentos_funcionario`
--

CREATE TABLE `documentos_funcionario` (
  `id_documento` int(11) NOT NULL,
  `id_funcionario` int(11) DEFAULT NULL,
  `tipo_documento` varchar(100) DEFAULT NULL,
  `caminho_arquivo` varchar(255) DEFAULT NULL,
  `data_upload` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `documentos_funcionario`
--

INSERT INTO `documentos_funcionario` (`id_documento`, `id_funcionario`, `tipo_documento`, `caminho_arquivo`, `data_upload`) VALUES
(1, 1, 'RG e CPF', 'uploads/rg_cpf.pdf', '2024-11-22 08:45:48'),
(4, 23, 'rgCpf', 'uploads/1_1.png', '2024-11-22 15:08:14'),
(5, 23, 'carteiraTrabalho', 'uploads/2_1.png', '2024-11-22 15:08:14'),
(6, 23, 'comprovanteEndereco', 'uploads/LABNORTE_(7).png', '2024-11-22 15:08:14'),
(7, 24, 'rgCpf', 'uploads/1_1.png', '2024-11-22 15:41:59'),
(8, 26, 'rgCpf', 'uploads/1_1.png', '2024-11-22 18:37:00'),
(9, 26, 'carteiraTrabalho', 'uploads/2_1.png', '2024-11-22 18:37:00'),
(10, 26, 'comprovanteEndereco', 'uploads/unnamed.jpg', '2024-11-22 18:37:00'),
(11, 27, 'rgCpf', 'uploads/2 1.png', '2024-11-22 18:47:23'),
(12, 28, 'rgCpf', 'uploads/2 1.png', '2024-11-22 18:50:17'),
(13, 29, 'rgCpf', 'uploads/2 1.png', '2024-11-22 18:51:55'),
(14, 30, 'rgCpf', 'uploads/1 1.png', '2024-11-22 19:03:36'),
(15, 31, 'rgCpf', 'uploads/1 1.png', '2024-11-22 19:08:18');

-- --------------------------------------------------------

--
-- Estrutura para tabela `funcionarios`
--

CREATE TABLE `funcionarios` (
  `id_funcionario` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `cargo` varchar(100) NOT NULL,
  `departamento` varchar(100) NOT NULL,
  `data_admissao` date NOT NULL,
  `status` enum('ativo','inativo') NOT NULL DEFAULT 'ativo',
  `data_criacao` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `funcionarios`
--

INSERT INTO `funcionarios` (`id_funcionario`, `nome`, `email`, `senha`, `cargo`, `departamento`, `data_admissao`, `status`, `data_criacao`) VALUES
(1, 'Ana Carina Duarte Pereira', 'AnaKarina@gmail.com', 'AnaC123', 'Analista', 'RH', '2024-11-20', 'ativo', '2024-11-21 23:02:41'),
(2, 'Ana Beatriz Duarte Pereira', 'AnaBeatriz@gmail.com', 'AnaB123', 'Assistente', 'Financeiro', '2024-11-20', 'ativo', '2024-11-21 23:02:41'),
(3, 'Mayara Rodrigues de Sousa', 'MayaraRodrigues@gmail.com', 'Mayara123', 'Gerente', 'TI', '2024-11-20', 'ativo', '2024-11-21 23:02:41'),
(4, 'Amanda Bezerra', 'AmandaBezerra@gmail.com', 'Amanda123', 'Coordenadora', 'Marketing', '2024-11-20', 'ativo', '2024-11-21 23:02:41'),
(5, 'Danilo Afonso Leal Gomes', 'DaniloAfonso@gmail.com', 'Danilo123', 'Supervisor', 'Operações', '2024-11-20', 'ativo', '2024-11-21 23:02:41'),
(6, 'Daura Julietta Leal Gomes', 'DauraJulieta@gmail.com', 'Daura123', 'Analista', 'Logística', '2024-11-20', 'ativo', '2024-11-21 23:02:41'),
(7, 'Zidanni Oliveira da Silva', 'ZidanniOlveira@gmail.com', 'Zidanni123', 'Auxiliar', 'Atendimento', '2024-11-20', 'ativo', '2024-11-21 23:02:41'),
(8, 'David', 'David@gmail.com', 'David123', 'Técnico', 'Manutenção', '2024-11-20', 'ativo', '2024-11-21 23:02:41'),
(9, 'Ludimila Thays Leal dos Santos', 'LudmilaThays@gmail.com', 'Ludmila123', 'Analista', 'Vendas', '2024-11-20', 'ativo', '2024-11-21 23:02:41'),
(10, 'Tarlisson Oliveira do Carmo', 'TarlissonOliveira@gmail.com', 'Tarlisson123', 'Assistente', 'Compras', '2024-11-20', 'ativo', '2024-11-21 23:02:41'),
(11, 'Eurilane', 'Eurilane@gmail.com', 'Eurilane123', 'Especialista', 'Recursos Humanos', '2024-11-20', 'ativo', '2024-11-21 23:02:41'),
(12, 'Claudia Maria Gama Gomes', 'ClaudiaMaria@gmail.com', 'Claudia123', 'Supervisor', 'TI', '2024-11-20', 'ativo', '2024-11-21 23:02:41'),
(13, 'Saraih Romero', 'SaraihRomero@gmail.com', 'Saraih123', 'Assistente', 'Marketing', '2024-11-20', 'ativo', '2024-11-21 23:02:41'),
(14, 'Paulo Cesar', 'PauloCesar@gmail.com', 'Paulo123', 'Analista', 'Operações', '2024-11-20', 'ativo', '2024-11-21 23:02:41'),
(15, 'Gabriel Malcher', 'GabrielMalcher@gmail.com', 'Gabriel123', 'Técnico', 'Manutenção', '2024-11-20', 'ativo', '2024-11-21 23:02:41'),
(16, 'Bruna Lauren dos Santos Bentes', 'lauren@gmail.com', 'Pablo123', 'Repcionista', 'Atendimento', '1222-03-22', 'ativo', '2024-11-22 00:30:42'),
(17, 'Giovani Matheus Rebelo', 'giovani@gmail.com', 'Giovani123', 'Gestor de TI', 'TI', '2024-11-21', 'ativo', '2024-11-22 00:33:19'),
(18, 'Murilo Couto', 'murilocouto@gmail.com', 'murilo123', 'Cartomante', 'Macu', '2024-11-22', 'ativo', '2024-11-22 08:37:34'),
(19, 'Murilo Couto', 'PabloRangel@gmail.com', 'Pablo123', 'Cartomante', 'Macu', '0123-03-12', 'ativo', '2024-11-22 09:00:42'),
(21, 'Caros DINIS', 'sais@gmail.com', '123213', 'Feiraddor', 'Casas Bahias', '0000-00-00', 'ativo', '2024-11-22 09:07:27'),
(22, 'Caro43s DINIS', 'sai43234s@gmail.com', '4231234', 'Feiraddor', 'Casas Bahias', '4343-03-12', 'ativo', '2024-11-22 09:13:47'),
(23, 'dasd', 'PabloRanadsgel@gmail.comasd', 'Pablo123asd', 'daasddas', 'daasd', '0022-03-31', 'ativo', '2024-11-22 15:08:14'),
(24, 'fswsergytsh', 'Pablogfrdthjdftyjl@gmail.com', 'Pablo123', 'cargo', 'departamento', '2024-11-21', 'ativo', '2024-11-22 15:41:59'),
(25, 'Romulus Cabos Santos', 'romulus@gmail.com', 'Romulos123', 'Técnico', 'Marketing', '2202-03-15', 'ativo', '2024-11-22 18:33:22'),
(26, 'Castros Souza Mota', 'castros@gmail.com', 'Castros123', 'Supervisor', 'TI', '3122-03-12', 'ativo', '2024-11-22 18:37:00'),
(27, 'Lucas Mota', 'adsdas@gasdad', '1123', 'Coordenadora', 'RH', '0123-03-12', 'ativo', '2024-11-22 18:47:23'),
(28, 'Fabio Dutra', 'fabio@gmail.com', 'Fabio123', 'Supervisor', 'Marketing', '3331-12-12', 'ativo', '2024-11-22 18:50:17'),
(29, 'Jurulesy', 'juru@gmail.com', 'Juru123', 'Coordenadora', 'Financeiro', '2111-02-12', 'ativo', '2024-11-22 18:51:55'),
(30, 'Mota moto', 'mota@gmail.com', 'mota123', 'Assistente', 'RH', '0000-00-00', 'ativo', '2024-11-22 19:03:36'),
(31, 'teste1', 'teste@gmail.com', '123', 'Assistente', 'Financeiro', '3312-02-21', 'ativo', '2024-11-22 19:08:18');

-- --------------------------------------------------------

--
-- Estrutura para tabela `pagamentos`
--

CREATE TABLE `pagamentos` (
  `id_pagamento` int(11) NOT NULL,
  `id_funcionario` int(11) DEFAULT NULL,
  `nome` varchar(100) DEFAULT NULL,
  `cargo` varchar(100) DEFAULT NULL,
  `tipo_servico` varchar(100) DEFAULT NULL,
  `data_pagamento` date DEFAULT NULL,
  `valor` decimal(10,2) DEFAULT NULL,
  `status` enum('pendente','pago','atrasado') DEFAULT NULL,
  `periodo` enum('diario','semanal','quinzenal','mensal') DEFAULT NULL,
  `metodo` varchar(15) DEFAULT NULL,
  `tipo_pagamento` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pagamentos`
--

INSERT INTO `pagamentos` (`id_pagamento`, `id_funcionario`, `nome`, `cargo`, `tipo_servico`, `data_pagamento`, `valor`, `status`, `periodo`, `metodo`, `tipo_pagamento`) VALUES
(10, 1, 'João Silva', 'Desenvolvedor', 'Manutenção de Sistema', '2024-11-22', 3500.00, 'pago', 'mensal', 'transferencia', 'salario'),
(11, 2, 'Marcos Silva', 'Desenvolvedor', 'Manutenção', '2024-10-22', 3500.00, 'pago', 'mensal', 'transferencia', 'salario'),
(12, 3, 'João Silva', 'Desenvolvedor', 'Manutenção de Sistema', '2024-11-20', 3500.00, 'pendente', 'mensal', 'transferencia', 'salario'),
(17, 4, NULL, NULL, 'Manutenção de Sistema', '2024-09-22', 3500.00, 'pendente', 'mensal', 'transferencia', 'salario');

-- --------------------------------------------------------

--
-- Estrutura para tabela `recuperacao_senha`
--

CREATE TABLE `recuperacao_senha` (
  `id_recuperacao` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `data_solicitacao` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('solicitada','concluida') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `registros_ponto`
--

CREATE TABLE `registros_ponto` (
  `id_registro` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `data` date DEFAULT NULL,
  `hora_entrada` time DEFAULT NULL,
  `hora_saida` time DEFAULT NULL,
  `status` enum('presente','ausente','atrasado') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `relatorios`
--

CREATE TABLE `relatorios` (
  `id_relatorio` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `tipo_relatorio` varchar(50) DEFAULT NULL,
  `data_criacao` timestamp NOT NULL DEFAULT current_timestamp(),
  `conteudo_relatorio` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `relatorios`
--

INSERT INTO `relatorios` (`id_relatorio`, `id_usuario`, `tipo_relatorio`, `data_criacao`, `conteudo_relatorio`) VALUES
(1, 1, '', '2024-11-20 03:00:00', 'Produtividade em alta no último mês.'),
(2, 2, '', '2024-11-20 03:00:00', 'Pagamentos realizados e pendentes.'),
(3, 3, '', '2024-11-20 03:00:00', 'Tentativas de login bem-sucedidas e falhas.'),
(4, 1, 'Relatório Financeiro', '2024-11-20 03:00:00', 'Conteúdo do relatório financeiro...'),
(5, 2, 'Relatório de Produtividade', '2024-11-20 03:00:00', 'Conteúdo do relatório de produtividade...'),
(6, 3, 'Análise de Desempenho', '2024-11-20 03:00:00', 'Conteúdo do relatório de desempenho...');

-- --------------------------------------------------------

--
-- Estrutura para tabela `servicos_prestados`
--

CREATE TABLE `servicos_prestados` (
  `id_servico` int(11) NOT NULL,
  `descricao_servico` text DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `data_servico` date DEFAULT NULL,
  `valor_pago` decimal(10,2) DEFAULT NULL,
  `status_pagamento` enum('pendente','pago','não pago') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `suporte`
--

CREATE TABLE `suporte` (
  `id_suporte` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `assunto` varchar(100) DEFAULT NULL,
  `mensagem` text DEFAULT NULL,
  `status` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tarefas`
--

CREATE TABLE `tarefas` (
  `id_tarefa` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `descricao` text DEFAULT NULL,
  `data_inicio` date DEFAULT NULL,
  `data_fim` date DEFAULT NULL,
  `status` enum('pendente','em andamento','concluida') DEFAULT NULL,
  `prioridade` enum('baixa','media','alta') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(255) NOT NULL,
  `tipo_usuario` enum('funcionario','administrador','prestador') NOT NULL,
  `data_criacao` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nome`, `email`, `senha`, `tipo_usuario`, `data_criacao`) VALUES
(1, 'Gabriela Galucio Cardoso', 'gabrielagaluciocardoso74@gmail.com', 'Gaby121314', 'administrador', '2024-11-20 21:01:10'),
(2, 'Carlos Henrique Farias Malcher', 'carlosmalcherpro@gmail.com', 'Carlos123', 'administrador', '2024-11-20 21:01:10'),
(3, 'Pablo Rangel Duarte', 'PabloRangel@gmail.com', 'Pablo123', 'administrador', '2024-11-20 21:01:10');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `auditoria_login`
--
ALTER TABLE `auditoria_login`
  ADD PRIMARY KEY (`id_auditoria`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Índices de tabela `comprovantes_pagamento`
--
ALTER TABLE `comprovantes_pagamento`
  ADD PRIMARY KEY (`id_comprovante`),
  ADD KEY `id_funcionario` (`id_funcionario`),
  ADD KEY `comprovantes_pagamento_ibfk_1` (`id_pagamento`);

--
-- Índices de tabela `documentos_funcionario`
--
ALTER TABLE `documentos_funcionario`
  ADD PRIMARY KEY (`id_documento`),
  ADD KEY `id_usuario` (`id_funcionario`);

--
-- Índices de tabela `funcionarios`
--
ALTER TABLE `funcionarios`
  ADD PRIMARY KEY (`id_funcionario`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Índices de tabela `pagamentos`
--
ALTER TABLE `pagamentos`
  ADD PRIMARY KEY (`id_pagamento`),
  ADD KEY `idx_usuario_pagamentos` (`id_funcionario`);

--
-- Índices de tabela `recuperacao_senha`
--
ALTER TABLE `recuperacao_senha`
  ADD PRIMARY KEY (`id_recuperacao`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Índices de tabela `registros_ponto`
--
ALTER TABLE `registros_ponto`
  ADD PRIMARY KEY (`id_registro`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Índices de tabela `relatorios`
--
ALTER TABLE `relatorios`
  ADD PRIMARY KEY (`id_relatorio`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Índices de tabela `servicos_prestados`
--
ALTER TABLE `servicos_prestados`
  ADD PRIMARY KEY (`id_servico`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Índices de tabela `suporte`
--
ALTER TABLE `suporte`
  ADD PRIMARY KEY (`id_suporte`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Índices de tabela `tarefas`
--
ALTER TABLE `tarefas`
  ADD PRIMARY KEY (`id_tarefa`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Índices de tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_email_usuario` (`email`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `auditoria_login`
--
ALTER TABLE `auditoria_login`
  MODIFY `id_auditoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `comprovantes_pagamento`
--
ALTER TABLE `comprovantes_pagamento`
  MODIFY `id_comprovante` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de tabela `documentos_funcionario`
--
ALTER TABLE `documentos_funcionario`
  MODIFY `id_documento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de tabela `funcionarios`
--
ALTER TABLE `funcionarios`
  MODIFY `id_funcionario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de tabela `pagamentos`
--
ALTER TABLE `pagamentos`
  MODIFY `id_pagamento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de tabela `recuperacao_senha`
--
ALTER TABLE `recuperacao_senha`
  MODIFY `id_recuperacao` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `registros_ponto`
--
ALTER TABLE `registros_ponto`
  MODIFY `id_registro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `relatorios`
--
ALTER TABLE `relatorios`
  MODIFY `id_relatorio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `servicos_prestados`
--
ALTER TABLE `servicos_prestados`
  MODIFY `id_servico` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `suporte`
--
ALTER TABLE `suporte`
  MODIFY `id_suporte` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `tarefas`
--
ALTER TABLE `tarefas`
  MODIFY `id_tarefa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `auditoria_login`
--
ALTER TABLE `auditoria_login`
  ADD CONSTRAINT `auditoria_login_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `comprovantes_pagamento`
--
ALTER TABLE `comprovantes_pagamento`
  ADD CONSTRAINT `comprovantes_pagamento_ibfk_1` FOREIGN KEY (`id_pagamento`) REFERENCES `pagamentos` (`id_pagamento`) ON DELETE CASCADE;

--
-- Restrições para tabelas `documentos_funcionario`
--
ALTER TABLE `documentos_funcionario`
  ADD CONSTRAINT `documentos_funcionario_ibfk_1` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionarios` (`id_funcionario`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_documento_funcionario` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionarios` (`id_funcionario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `pagamentos`
--
ALTER TABLE `pagamentos`
  ADD CONSTRAINT `pagamentos_ibfk_1` FOREIGN KEY (`id_funcionario`) REFERENCES `funcionarios` (`id_funcionario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `recuperacao_senha`
--
ALTER TABLE `recuperacao_senha`
  ADD CONSTRAINT `recuperacao_senha_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `registros_ponto`
--
ALTER TABLE `registros_ponto`
  ADD CONSTRAINT `registros_ponto_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `relatorios`
--
ALTER TABLE `relatorios`
  ADD CONSTRAINT `relatorios_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `servicos_prestados`
--
ALTER TABLE `servicos_prestados`
  ADD CONSTRAINT `servicos_prestados_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `suporte`
--
ALTER TABLE `suporte`
  ADD CONSTRAINT `suporte_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Restrições para tabelas `tarefas`
--
ALTER TABLE `tarefas`
  ADD CONSTRAINT `tarefas_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
