🚀 Projeto de Banco de Dados (DER E-Commerce)
Este repositório contém os scripts SQL para a criação das tabelas e consultas de análise (DER) de um sistema de E-commerce.

🏗️ Estrutura do Banco de Dados
O banco de dados foi modelado para gerenciar clientes, produtos, pedidos, fornecedores, vendedores terceirizados e estoque.

Diagrama Entidade-Relacionamento (DER)
🛠️ Scripts SQL
1. Criação das Tabelas (CREATE TABLE)
O script a seguir define a estrutura de todas as tabelas, incluindo Chaves Primárias (PK) e Chaves Estrangeiras (FK), garantindo a integridade referencial dos dados.

SQL

-- Tabela Cliente
CREATE TABLE Cliente (
    id_Cliente INT PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Cpf VARCHAR(11) UNIQUE,
    Endereco VARCHAR(50),
    Telefone VARCHAR(11),
    Data_Nascimento DATE
);

-- Tabela Fornecedor
CREATE TABLE Fornecedor (
    id_Fornecedor INT PRIMARY KEY,
    Razao_Social VARCHAR(50) NOT NULL,
    Cnpj VARCHAR(14) UNIQUE,
    Cpf VARCHAR(11) UNIQUE,
    Tel1 VARCHAR(11),
    Tel2 VARCHAR(11),
    id_Cliente INT,
    bit BOOLEAN,
    FOREIGN KEY (id_Cliente) REFERENCES Cliente(id_Cliente)
);

-- Tabela Terceiro_Vendedor
CREATE TABLE Terceiro_Vendedor (
    id_Terceiro_Vendedor INT PRIMARY KEY,
    Razao_Social_Vendedor VARCHAR(50) NOT NULL,
    Local VARCHAR(50),
    Cnpj VARCHAR(14) UNIQUE,
    Cpf VARCHAR(11) UNIQUE,
    Tel1 VARCHAR(11),
    Tel2 VARCHAR(11),
    id_Fornecedor INT,
    id_Cliente INT,
    FOREIGN KEY (id_Fornecedor) REFERENCES Fornecedor(id_Fornecedor),
    FOREIGN KEY (id_Cliente) REFERENCES Cliente(id_Cliente)
);

-- Tabela Produto
CREATE TABLE Produto (
    id_Produto INT PRIMARY KEY,
    Categoria VARCHAR(30),
    Descricao VARCHAR(50),
    Valor FLOAT NOT NULL
);

-- Tabela Estoque
CREATE TABLE Estoque (
    id_Estoque INT PRIMARY KEY,
    Quantidade INT NOT NULL
);

-- Tabela Produto_has_Estoque (N:M entre Produto e Estoque)
CREATE TABLE Produto_has_Estoque (
    id_Produto INT,
    id_Estoque INT,
    Quantidade INT NOT NULL,
    PRIMARY KEY (id_Produto, id_Estoque),
    FOREIGN KEY (id_Produto) REFERENCES Produto(id_Produto),
    FOREIGN KEY (id_Estoque) REFERENCES Estoque(id_Estoque)
);

-- Tabela Disponibilizando_Produto (N:M entre Fornecedor e Produto)
CREATE TABLE Disponibilizando_Produto (
    id_Fornecedor INT,
    id_Produto INT,
    PRIMARY KEY (id_Fornecedor, id_Produto),
    FOREIGN KEY (id_Fornecedor) REFERENCES Fornecedor(id_Fornecedor),
    FOREIGN KEY (id_Produto) REFERENCES Produto(id_Produto)
);

-- Tabela Pedido
CREATE TABLE Pedido (
    id_Pedido INT PRIMARY KEY,
    Status_Pedido VARCHAR(50),
    Descricao VARCHAR(50),
    Frete FLOAT,
    id_Cliente INT NOT NULL,
    id_Terceiro_Vendedor INT,
    FOREIGN KEY (id_Cliente) REFERENCES Cliente(id_Cliente),
    FOREIGN KEY (id_Terceiro_Vendedor) REFERENCES Terceiro_Vendedor(id_Terceiro_Vendedor)
);

-- Tabela Pagamento
CREATE TABLE Pagamento (
    id_Pagamento INT PRIMARY KEY,
    Tipo_Pagamento VARCHAR(20) NOT NULL,
    id_Pedido INT UNIQUE NOT NULL,
    Pagamento VARCHAR(30),
    FOREIGN KEY (id_Pedido) REFERENCES Pedido(id_Pedido)
);

-- Tabela Relacao_Produtos_Pedido (N:M entre Pedido e Produto)
CREATE TABLE Relacao_Produtos_Pedido (
    id_Pedido INT,
    id_Produto INT,
    Quantidade INT NOT NULL,
    PRIMARY KEY (id_Pedido, id_Produto),
    FOREIGN KEY (id_Pedido) REFERENCES Pedido(id_Pedido),
    FOREIGN KEY (id_Produto) REFERENCES Produto(id_Produto)
);

-- Tabela Produtos_por_Vendedor (N:M entre Terceiro_Vendedor e Produto)
CREATE TABLE Produtos_por_Vendedor (
    id_Terceiro_Vendedor INT,
    id_Produto INT,
    Quantidade INT,
    PRIMARY KEY (id_Terceiro_Vendedor, id_Produto),
    FOREIGN KEY (id_Terceiro_Vendedor) REFERENCES Terceiro_Vendedor(id_Terceiro_Vendedor),
    FOREIGN KEY (id_Produto) REFERENCES Produto(id_Produto)
);
2. Consultas de Análise (SELECT)
a. Quantos pedidos foram feitos por cada cliente?
SQL

SELECT
    C.Nome AS Nome_do_Cliente,
    COUNT(P.id_Pedido) AS Total_de_Pedidos
FROM
    Cliente C
JOIN
    Pedido P ON C.id_Cliente = P.id_Cliente
GROUP BY
    C.id_Cliente, C.Nome
ORDER BY
    Total_de_Pedidos DESC;
b. Algum vendedor também é fornecedor?
SQL

SELECT
    TV.Razao_Social_Vendedor AS Vendedor_Terceiro,
    F.Razao_Social AS Fornecedor_Associado
FROM
    Terceiro_Vendedor TV
JOIN
    Fornecedor F ON TV.id_Fornecedor = F.id_Fornecedor
WHERE
    TV.id_Fornecedor IS NOT NULL;
c. Relação de produtos, fornecedores e estoques
SQL

SELECT
    P.Descricao AS Produto,
    F.Razao_Social AS Fornecedor,
    E.id_Estoque AS ID_Estoque,
    PHE.Quantidade AS Quantidade_em_Estoque
FROM
    Produto P
JOIN
    Disponibilizando_Produto DP ON P.id_Produto = DP.id_Produto
JOIN
    Fornecedor F ON DP.id_Fornecedor = F.id_Fornecedor
JOIN
    Produto_has_Estoque PHE ON P.id_Produto = PHE.id_Produto
JOIN
    Estoque E ON PHE.id_Estoque = E.id_Estoque
ORDER BY
    Produto, Fornecedor;
d. Relação de nomes dos fornecedores e nomes dos produtos
SQL

SELECT
    F.Razao_Social AS Nome_do_Fornecedor,
    P.Descricao AS Nome_do_Produto
FROM
    Fornecedor F
JOIN
    Disponibilizando_Produto DP ON F.id_Fornecedor = DP.id_Fornecedor
JOIN
    Produto P ON DP.id_Produto = P.id_Produto
ORDER BY
    Nome_do_Fornecedor, Nome_do_Produto;
