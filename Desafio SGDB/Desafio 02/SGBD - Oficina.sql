
-- -----------------------------------------------------
-- Criação do Banco de Dados
-- -----------------------------------------------------
IF NOT EXISTS (
    SELECT name
    FROM sys.databases
    WHERE name = N'Oficina'
)
BEGIN
    CREATE DATABASE Oficina;
END;
GO

USE Oficina;
GO

-- -----------------------------------------------------
-- Tabela Cliente
-- -----------------------------------------------------
CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY   IDENTITY(1,1),
    Nome VARCHAR(45) NOT NULL,
    CPF CHAR(11) UNIQUE NOT NULL,
    Telefone CHAR(11),
    Endereco VARCHAR(100)
);

-- -----------------------------------------------------
-- Tabela Veiculo
-- -----------------------------------------------------
CREATE TABLE Veiculo (
    idVeiculo INT PRIMARY KEY   IDENTITY(1,1),
    idCliente INT NOT NULL,
    Marca VARCHAR(45),
    Modelo VARCHAR(45),
    Placa CHAR(7) UNIQUE NOT NULL,
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);

-- -----------------------------------------------------
-- Tabela Equipe
-- -----------------------------------------------------
CREATE TABLE Equipe (
    idEquipe INT PRIMARY KEY   IDENTITY(1,1),
    NomeEquipe VARCHAR(45) NOT NULL,
    Especialidade VARCHAR(45)
);

-- -----------------------------------------------------
-- Tabela Mecanico
-- -----------------------------------------------------
CREATE TABLE Mecanico (
    idMecanico INT PRIMARY KEY   IDENTITY(1,1),
    idEquipe INT NOT NULL,
    Codigo VARCHAR(10) UNIQUE NOT NULL, 
    Nome VARCHAR(45) NOT NULL,
    Endereco VARCHAR(100),
    Especialidade VARCHAR(45),
    CONSTRAINT fk_mecanico_equipe FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe)
);

-- -----------------------------------------------------
-- Tabela OrdemServico
-- -----------------------------------------------------
CREATE TABLE OrdemServico (
    idOS INT PRIMARY KEY IDENTITY(1,1),
    idCliente INT NOT NULL,
    idVeiculo INT NOT NULL,
    idEquipe INT,
    DataEmissao DATE NOT NULL,
    DataConclusao DATE,
    ValorTotal DECIMAL(10, 2) DEFAULT 0.00,
    Status VARCHAR(20) DEFAULT 'Aberta' NOT NULL,
    CONSTRAINT ck_os_status CHECK (Status IN ('Aberta', 'Em Andamento', 'Concluída', 'Cancelada')), 
    CONSTRAINT fk_os_cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    CONSTRAINT fk_os_veiculo FOREIGN KEY (idVeiculo) REFERENCES Veiculo(idVeiculo),
    CONSTRAINT fk_os_equipe FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe)
);

-- -----------------------------------------------------
-- Tabela Peca
-- -----------------------------------------------------
CREATE TABLE Peca (
    idPeca INT PRIMARY KEY   IDENTITY(1,1),
    Descricao VARCHAR(60) NOT NULL,
    ValorPeca DECIMAL(10, 2) NOT NULL,
    QuantidadeEstoque INT DEFAULT 0
);

-- -----------------------------------------------------
-- Tabela Servico
-- -----------------------------------------------------
CREATE TABLE Servico (
    idServico INT PRIMARY KEY   IDENTITY(1,1),
    DescricaoServico VARCHAR(60) NOT NULL,
    ValorMaoObra DECIMAL(10, 2) NOT NULL
);

-- -----------------------------------------------------
-- Tabela OS_Peca (Itens da OS - Peças)
-- -----------------------------------------------------
CREATE TABLE OS_Peca (
    idOS INT NOT NULL,
    idPeca INT NOT NULL,
    QuantidadePeca INT NOT NULL,
    PRIMARY KEY (idOS, idPeca),
    CONSTRAINT fk_osp_os FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS),
    CONSTRAINT fk_osp_peca FOREIGN KEY (idPeca) REFERENCES Peca(idPeca)
);

-- -----------------------------------------------------
-- Tabela OS_Servico (Itens da OS - Serviços)
-- -----------------------------------------------------
CREATE TABLE OS_Servico (
    idOS INT NOT NULL,
    idServico INT NOT NULL,
    PRIMARY KEY (idOS, idServico),
    CONSTRAINT fk_oss_os FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS),
    CONSTRAINT fk_oss_servico FOREIGN KEY (idServico) REFERENCES Servico(idServico)
);
-- Inserir Clientes
INSERT INTO Cliente (Nome, CPF, Telefone, Endereco) VALUES
('João Silva', '12345678901', '31998765432', 'Rua A, 100'),
('Maria Souza', '98765432109', '31887654321', 'Av B, 250'),
('Carlos Pereira', '45678912300', '31776543210', 'Travessa C, 30');

-- Inserir Veiculos
INSERT INTO Veiculo (idCliente, Marca, Modelo, Placa) VALUES
(1, 'Fiat', 'Palio', 'ABC1234'),
(2, 'Ford', 'Ka', 'XYZ7890'),
(1, 'Chevrolet', 'Onix', 'DEF5678'),
(3, 'VW', 'Gol', 'GHI9012');

-- Inserir Equipes
INSERT INTO Equipe (NomeEquipe, Especialidade) VALUES
('Eletrica Master', 'Eletrica'),
('Mecanica Prime', 'Motor e Suspensão'),
('Funilaria Express', 'Funilaria');

-- Inserir Mecanicos
INSERT INTO Mecanico (idEquipe, Codigo, Nome, Endereco, Especialidade) VALUES
(1, 'E001', 'Pedro Rocha', 'Rua Alfa, 1', 'Eletricista Chefe'),
(2, 'M001', 'Ana Paula', 'Av Beta, 2', 'Motor'),
(2, 'M002', 'Ricardo Alves', 'Rua Gama, 3', 'Suspensão'),
(3, 'F001', 'Lucas Lima', 'Travessa Delta, 4', 'Funileiro');

-- Inserir Peças
INSERT INTO Peca (Descricao, ValorPeca, QuantidadeEstoque) VALUES
('Filtro de Óleo', 25.50, 150),
('Vela de Ignição', 45.00, 80),
('Pastilha de Freio', 120.90, 60),
('Bateria 60Ah', 350.00, 40);

-- Inserir Serviços
INSERT INTO Servico (DescricaoServico, ValorMaoObra) VALUES
('Troca de Óleo e Filtro', 50.00),
('Revisão Elétrica', 150.00),
('Troca de Suspensão Dianteira', 300.00),
('Alinhamento e Balanceamento', 80.00);

-- Inserir Ordens de Serviço (OS)
INSERT INTO OrdemServico (idCliente, idVeiculo, idEquipe, DataEmissao, DataConclusao, Status) VALUES
(1, 1, 2, '2023-10-01', '2023-10-05', 'Concluída'), 
(2, 2, 1, '2023-10-10', NULL, 'Em Andamento'), 
(3, 4, 2, '2023-10-15', '2023-10-18', 'Concluída'), 
(1, 3, 2, '2023-11-01', NULL, 'Aberta'); 

-- Detalhamento das OS - Peças (OS_Peca)
INSERT INTO OS_Peca (idOS, idPeca, QuantidadePeca) VALUES
(1, 1, 1), -- OS 1: 1 Filtro de Óleo
(1, 3, 1), -- OS 1: 1 Pastilha de Freio
(2, 4, 1), -- OS 2: 1 Bateria 60Ah
(3, 2, 4); -- OS 3: 4 Velas de Ignição

-- Detalhamento das OS - Serviços (OS_Servico)
INSERT INTO OS_Servico (idOS, idServico) VALUES
(1, 1), -- OS 1: Troca de Óleo
(1, 3), -- OS 1: Troca de Suspensão
(2, 2), -- OS 2: Revisão Elétrica
(3, 2); -- OS 3: Revisão Elétrica

-- Atualizar ValorTotal das OS (Simulação de Trigger/Stored Procedure)
UPDATE OrdemServico SET ValorTotal = (
    SELECT  COALESCE(SUM(P.ValorPeca * OSP.QuantidadePeca), 0) + COALESCE(SUM(S.ValorMaoObra), 0)
    FROM        OS_Peca     OSP
    LEFT JOIN   Peca        P   ON OSP.idPeca = P.idPeca
    LEFT JOIN   OS_Servico  OSS ON OSP.idOS = OSS.idOS
    LEFT JOIN   Servico     S   ON OSS.idServico = S.idServico
    WHERE       OSP.idOS = OrdemServico.idOS
)
WHERE idOS IN (1, 2, 3);


-- 📊 Consultas SQL Complexas (DQL)
SELECT  AVG(DATEDIFF(day, OS.DataEmissao, OS.DataConclusao))    AS TempoMedioExecucaoDias,
        SUM(OS.ValorTotal)                                      AS SomaTotalOSConcluidas
FROM    OrdemServico OS
WHERE   OS.Status = 'Concluída';

-- Pergunta 2: Liste o nome dos clientes que possuem Ordens de Serviço (OS) abertas
SELECT  C.Nome              AS NomeCliente,
        V.Placa             AS PlacaVeiculo,
        OS.DataEmissao
FROM    Cliente         C
JOIN    OrdemServico    OS  ON C.idCliente = OS.idCliente
JOIN    Veiculo         V   ON OS.idVeiculo = V.idVeiculo
WHERE    OS.Status = 'Aberta'
ORDER BY C.Nome ASC; 

-- Pergunta 3: Quais equipes têm um valor médio de Ordens de Serviço concluídas superior a R$ 500,00? Liste o nome da equipe e seu valor médio.

SELECT  E.NomeEquipe,
        AVG(OS.ValorTotal) AS ValorMedioOS
FROM    Equipe          E
JOIN    OrdemServico    OS ON E.idEquipe = OS.idEquipe
WHERE    OS.Status = 'Concluída' 
GROUP BY E.NomeEquipe
HAVING   AVG(OS.ValorTotal) > 500.00; 

-- Pergunta 4: Liste a descrição de todas as peças (e seu valor total) utilizadas nas Ordens
SELECT
    P.Descricao AS NomePeca,
    SUM(OSP.QuantidadePeca) AS QuantidadeTotalVendida,
    SUM(OSP.QuantidadePeca * P.ValorPeca) AS ValorTotalVendido
FROM    Peca    P
JOIN    OS_Peca OSP ON P.idPeca = OSP.idPeca
GROUP BY  P.Descricao, P.ValorPeca
HAVING    SUM(OSP.QuantidadePeca) > 2; 

--  Pergunta 5: Para cada Ordem de Serviço Em Andamento, liste a data de emissão, o nome do cliente e a descrição de todos os serviços inclusos.
SELECT  OS.idOS,
        OS.DataEmissao,
        C.Nome          AS NomeCliente,
        S.DescricaoServico
FROM    OrdemServico OS
JOIN    Cliente     C   ON OS.idCliente = C.idCliente
JOIN    OS_Servico  OSS ON OS.idOS = OSS.idOS -- Junção N:M para serviços
JOIN    Servico     S   ON OSS.idServico = S.idServico
WHERE    OS.Status = 'Em Andamento' 
ORDER BY OS.idOS;