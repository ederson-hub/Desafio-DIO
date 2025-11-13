📚 Projeto de Banco de Dados: Oficina Mecânica

Este repositório documenta a implementação de um banco de dados relacional para gerenciar as operações de uma Oficina Mecânica. O projeto inclui o esquema lógico, scripts DDL para criação das tabelas, scripts DML para popular o banco de dados e consultas DQL para análise de dados complexa.



1\. ⚙️ Esquema Lógico e Relacional

O design do banco de dados (BD) foi modelado com base no Diagrama Entidade-Relacionamento (DER) de uma oficina. O esquema lógico resultante utiliza as seguintes tabelas e seus respectivos relacionamentos:



Cliente (1:N com Veículo)



Veiculo (N:1 com Cliente)



Equipe (1:N com Mecânico e OrdemServico)



Mecanico (N:1 com Equipe)



OrdemServico (OS) (N:1 com Cliente, Veículo e Equipe)



Peca (N:M com OS através de OS\_Peca)



Servico (N:M com OS através de OS\_Servico)



OS\_Peca (Tabela associativa para peças utilizadas em uma OS)



OS\_Servico (Tabela associativa para serviços realizados em uma OS)



2\. 📝 Scripts SQL (DDL e DML)

A. Criação das Tabelas (DDL)

O script a seguir (em sintaxe MySQL) cria o banco de dados oficina e todas as tabelas necessárias, definindo chaves primárias (PRIMARY KEY), chaves estrangeiras (FOREIGN KEY) e restrições de unicidade (UNIQUE).



\[O script DDL completo para a criação das tabelas pode ser encontrado na seção anterior ou em um arquivo dedicado, como ddl\_oficina.sql.]



B. Persistência de Dados (DML)

Foram inseridos dados de exemplo (clientes, veículos, equipes, mecânicos, peças, serviços e Ordens de Serviço) para permitir a execução e teste das consultas de análise.



\[O script DML completo para a inserção de dados pode ser encontrado na seção anterior ou em um arquivo dedicado, como dml\_oficina\_inserts.sql.]



3\. 📊 Consultas de Análise (DQL)

As consultas a seguir abordam requisitos complexos de negócios e demonstram o uso de cláusulas avançadas do SQL.





-- -----------------------------------------------------

-- Criação do Banco de Dados

-- -----------------------------------------------------

IF NOT EXISTS (

&nbsp;   SELECT name

&nbsp;   FROM sys.databases

&nbsp;   WHERE name = N'Oficina'

)

BEGIN

&nbsp;   CREATE DATABASE Oficina;

END;

GO



USE Oficina;

GO



-- -----------------------------------------------------

-- Tabela Cliente

-- -----------------------------------------------------

CREATE TABLE Cliente (

&nbsp;   idCliente INT PRIMARY KEY   IDENTITY(1,1),

&nbsp;   Nome VARCHAR(45) NOT NULL,

&nbsp;   CPF CHAR(11) UNIQUE NOT NULL,

&nbsp;   Telefone CHAR(11),

&nbsp;   Endereco VARCHAR(100)

);



-- -----------------------------------------------------

-- Tabela Veiculo

-- -----------------------------------------------------

CREATE TABLE Veiculo (

&nbsp;   idVeiculo INT PRIMARY KEY   IDENTITY(1,1),

&nbsp;   idCliente INT NOT NULL,

&nbsp;   Marca VARCHAR(45),

&nbsp;   Modelo VARCHAR(45),

&nbsp;   Placa CHAR(7) UNIQUE NOT NULL,

&nbsp;   CONSTRAINT fk\_veiculo\_cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)

);



-- -----------------------------------------------------

-- Tabela Equipe

-- -----------------------------------------------------

CREATE TABLE Equipe (

&nbsp;   idEquipe INT PRIMARY KEY   IDENTITY(1,1),

&nbsp;   NomeEquipe VARCHAR(45) NOT NULL,

&nbsp;   Especialidade VARCHAR(45)

);



-- -----------------------------------------------------

-- Tabela Mecanico

-- -----------------------------------------------------

CREATE TABLE Mecanico (

&nbsp;   idMecanico INT PRIMARY KEY   IDENTITY(1,1),

&nbsp;   idEquipe INT NOT NULL,

&nbsp;   Codigo VARCHAR(10) UNIQUE NOT NULL, 

&nbsp;   Nome VARCHAR(45) NOT NULL,

&nbsp;   Endereco VARCHAR(100),

&nbsp;   Especialidade VARCHAR(45),

&nbsp;   CONSTRAINT fk\_mecanico\_equipe FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe)

);



-- -----------------------------------------------------

-- Tabela OrdemServico

-- -----------------------------------------------------

CREATE TABLE OrdemServico (

&nbsp;   idOS INT PRIMARY KEY IDENTITY(1,1),

&nbsp;   idCliente INT NOT NULL,

&nbsp;   idVeiculo INT NOT NULL,

&nbsp;   idEquipe INT,

&nbsp;   DataEmissao DATE NOT NULL,

&nbsp;   DataConclusao DATE,

&nbsp;   ValorTotal DECIMAL(10, 2) DEFAULT 0.00,

&nbsp;   Status VARCHAR(20) DEFAULT 'Aberta' NOT NULL,

&nbsp;   CONSTRAINT ck\_os\_status CHECK (Status IN ('Aberta', 'Em Andamento', 'Concluída', 'Cancelada')), 

&nbsp;   CONSTRAINT fk\_os\_cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),

&nbsp;   CONSTRAINT fk\_os\_veiculo FOREIGN KEY (idVeiculo) REFERENCES Veiculo(idVeiculo),

&nbsp;   CONSTRAINT fk\_os\_equipe FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe)

);



-- -----------------------------------------------------

-- Tabela Peca

-- -----------------------------------------------------

CREATE TABLE Peca (

&nbsp;   idPeca INT PRIMARY KEY   IDENTITY(1,1),

&nbsp;   Descricao VARCHAR(60) NOT NULL,

&nbsp;   ValorPeca DECIMAL(10, 2) NOT NULL,

&nbsp;   QuantidadeEstoque INT DEFAULT 0

);



-- -----------------------------------------------------

-- Tabela Servico

-- -----------------------------------------------------

CREATE TABLE Servico (

&nbsp;   idServico INT PRIMARY KEY   IDENTITY(1,1),

&nbsp;   DescricaoServico VARCHAR(60) NOT NULL,

&nbsp;   ValorMaoObra DECIMAL(10, 2) NOT NULL

);



-- -----------------------------------------------------

-- Tabela OS\_Peca (Itens da OS - Peças)

-- -----------------------------------------------------

CREATE TABLE OS\_Peca (

&nbsp;   idOS INT NOT NULL,

&nbsp;   idPeca INT NOT NULL,

&nbsp;   QuantidadePeca INT NOT NULL,

&nbsp;   PRIMARY KEY (idOS, idPeca),

&nbsp;   CONSTRAINT fk\_osp\_os FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS),

&nbsp;   CONSTRAINT fk\_osp\_peca FOREIGN KEY (idPeca) REFERENCES Peca(idPeca)

);



-- -----------------------------------------------------

-- Tabela OS\_Servico (Itens da OS - Serviços)

-- -----------------------------------------------------

CREATE TABLE OS\_Servico (

&nbsp;   idOS INT NOT NULL,

&nbsp;   idServico INT NOT NULL,

&nbsp;   PRIMARY KEY (idOS, idServico),

&nbsp;   CONSTRAINT fk\_oss\_os FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS),

&nbsp;   CONSTRAINT fk\_oss\_servico FOREIGN KEY (idServico) REFERENCES Servico(idServico)

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



-- Detalhamento das OS - Peças (OS\_Peca)

INSERT INTO OS\_Peca (idOS, idPeca, QuantidadePeca) VALUES

(1, 1, 1), -- OS 1: 1 Filtro de Óleo

(1, 3, 1), -- OS 1: 1 Pastilha de Freio

(2, 4, 1), -- OS 2: 1 Bateria 60Ah

(3, 2, 4); -- OS 3: 4 Velas de Ignição



-- Detalhamento das OS - Serviços (OS\_Servico)

INSERT INTO OS\_Servico (idOS, idServico) VALUES

(1, 1), -- OS 1: Troca de Óleo

(1, 3), -- OS 1: Troca de Suspensão

(2, 2), -- OS 2: Revisão Elétrica

(3, 2); -- OS 3: Revisão Elétrica



-- Atualizar ValorTotal das OS (Simulação de Trigger/Stored Procedure)

UPDATE OrdemServico SET ValorTotal = (

&nbsp;   SELECT  COALESCE(SUM(P.ValorPeca \* OSP.QuantidadePeca), 0) + COALESCE(SUM(S.ValorMaoObra), 0)

&nbsp;   FROM        OS\_Peca     OSP

&nbsp;   LEFT JOIN   Peca        P   ON OSP.idPeca = P.idPeca

&nbsp;   LEFT JOIN   OS\_Servico  OSS ON OSP.idOS = OSS.idOS

&nbsp;   LEFT JOIN   Servico     S   ON OSS.idServico = S.idServico

&nbsp;   WHERE       OSP.idOS = OrdemServico.idOS

)

WHERE idOS IN (1, 2, 3);





-- 📊 Consultas SQL Complexas (DQL)

SELECT  AVG(DATEDIFF(day, OS.DataEmissao, OS.DataConclusao))    AS TempoMedioExecucaoDias,

&nbsp;       SUM(OS.ValorTotal)                                      AS SomaTotalOSConcluidas

FROM    OrdemServico OS

WHERE   OS.Status = 'Concluída';



-- Pergunta 2: Liste o nome dos clientes que possuem Ordens de Serviço (OS) abertas

SELECT  C.Nome              AS NomeCliente,

&nbsp;       V.Placa             AS PlacaVeiculo,

&nbsp;       OS.DataEmissao

FROM    Cliente         C

JOIN    OrdemServico    OS  ON C.idCliente = OS.idCliente

JOIN    Veiculo         V   ON OS.idVeiculo = V.idVeiculo

WHERE    OS.Status = 'Aberta'

ORDER BY C.Nome ASC; 



-- Pergunta 3: Quais equipes têm um valor médio de Ordens de Serviço concluídas superior a R$ 500,00? Liste o nome da equipe e seu valor médio.



SELECT  E.NomeEquipe,

&nbsp;       AVG(OS.ValorTotal) AS ValorMedioOS

FROM    Equipe          E

JOIN    OrdemServico    OS ON E.idEquipe = OS.idEquipe

WHERE    OS.Status = 'Concluída' 

GROUP BY E.NomeEquipe

HAVING   AVG(OS.ValorTotal) > 500.00; 



-- Pergunta 4: Liste a descrição de todas as peças (e seu valor total) utilizadas nas Ordens

SELECT

&nbsp;   P.Descricao AS NomePeca,

&nbsp;   SUM(OSP.QuantidadePeca) AS QuantidadeTotalVendida,

&nbsp;   SUM(OSP.QuantidadePeca \* P.ValorPeca) AS ValorTotalVendido

FROM    Peca    P

JOIN    OS\_Peca OSP ON P.idPeca = OSP.idPeca

GROUP BY  P.Descricao, P.ValorPeca

HAVING    SUM(OSP.QuantidadePeca) > 2; 



--  Pergunta 5: Para cada Ordem de Serviço Em Andamento, liste a data de emissão, o nome do cliente e a descrição de todos os serviços inclusos.

SELECT  OS.idOS,

&nbsp;       OS.DataEmissao,

&nbsp;       C.Nome          AS NomeCliente,

&nbsp;       S.DescricaoServico

FROM    OrdemServico OS

JOIN    Cliente     C   ON OS.idCliente = C.idCliente

JOIN    OS\_Servico  OSS ON OS.idOS = OSS.idOS -- Junção N:M para serviços

JOIN    Servico     S   ON OSS.idServico = S.idServico

WHERE    OS.Status = 'Em Andamento' 

ORDER BY OS.idOS;

