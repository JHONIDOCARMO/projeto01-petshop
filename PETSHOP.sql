-- Projeto 01: Sistema de Vendas de um Pet Shop (MySQL)

DROP DATABASE IF EXISTS petshop;
CREATE DATABASE petshop;
USE petshop;

-- TABELAS
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100),
    cidade VARCHAR(50)
);

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome_categoria VARCHAR(50) NOT NULL
);

CREATE TABLE produtos (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL,
    id_categoria INT,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE vendedores (
    id_vendedor INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    data_admissao DATE
);

CREATE TABLE vendas (
    id_venda INT PRIMARY KEY AUTO_INCREMENT,
    data_venda DATE NOT NULL,
    id_cliente INT,
    id_vendedor INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor)
);

CREATE TABLE itens_venda (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_venda INT,
    id_produto INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venda) REFERENCES vendas(id_venda),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- DADOS
INSERT INTO categorias (nome_categoria) VALUES
('Ração'), ('Brinquedos'), ('Higiene'), ('Acessórios');

INSERT INTO clientes (nome, telefone, email, cidade) VALUES
('Ana Souza', '19991110001', 'ana@email.com', 'Paulínia'),
('Bruno Lima', '19991110002', 'bruno@email.com', 'Campinas'),
('Carla Mendes', '19991110003', 'carla@email.com', 'Paulínia'),
('Diego Alves', '19991110004', 'diego@email.com', 'Hortolândia'),
('Elisa Rocha', '19991110005', 'elisa@email.com', 'Campinas');

INSERT INTO produtos (nome_produto, preco, estoque, id_categoria) VALUES
('Ração Premium 10kg', 129.90, 20, 1),
('Ração Filhote 3kg', 59.90, 15, 1),
('Bolinha de Borracha', 14.90, 40, 2),
('Corda de Algodão', 19.90, 30, 2),
('Shampoo Neutro 500ml', 24.90, 25, 3),
('Coleira Média', 34.90, 18, 4);

INSERT INTO vendedores (nome, data_admissao) VALUES
('Marcos Silva', '2024-03-10'),
('Fernanda Costa', '2025-01-15'),
('Rafael Santos', '2025-08-20'),
('Jhoni', '2025-02-03'),
('Lucas', '2024-06-12'),
('Gabriela', '2025-04-22'),
('Isabela', '2024-09-05'),
('Isabelle', '2025-06-30'),
('Erick', '2025-10-01');

INSERT INTO vendas (data_venda, id_cliente, id_vendedor) VALUES
('2026-10-02', 1, 1),
('2026-10-05', 2, 2),
('2026-10-09', 3, 4),
('2026-10-14', 1, 5),
('2026-10-20', 4, 3),
('2026-10-25', 5, 6),
('2026-11-03', 2, 7),
('2026-11-08', 3, 9);

INSERT INTO itens_venda (id_venda, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 1, 129.90),
(1, 3, 2, 14.90),
(2, 2, 1, 59.90),
(3, 5, 1, 24.90),
(3, 6, 1, 34.90),
(4, 1, 2, 129.90),
(5, 4, 3, 19.90),
(5, 3, 1, 14.90),
(6, 2, 2, 59.90),
(6, 5, 1, 24.90),
(7, 1, 1, 129.90),
(7, 4, 2, 19.90),
(8, 6, 2, 34.90),
(8, 3, 3, 14.90);

-- CONSULTAS

-- 1. Produtos com estoque baixo
SELECT nome_produto, estoque
FROM produtos
WHERE estoque < 20
ORDER BY estoque;

-- 2. Faturamento total
SELECT SUM(quantidade * preco_unitario) AS faturamento_total
FROM itens_venda;

-- 3. Produtos mais vendidos
SELECT p.nome_produto, SUM(i.quantidade) AS total_vendido
FROM itens_venda i
JOIN produtos p ON p.id_produto = i.id_produto
GROUP BY p.nome_produto
ORDER BY total_vendido DESC;

-- 4. Faturamento por mês
SELECT DATE_FORMAT(v.data_venda, '%Y-%m') AS mes,
       SUM(i.quantidade * i.preco_unitario) AS faturamento
FROM vendas v
JOIN itens_venda i ON i.id_venda = v.id_venda
GROUP BY mes
ORDER BY mes;

-- 5. Melhor vendedor
SELECT vd.nome,
       SUM(i.quantidade * i.preco_unitario) AS total_vendido
FROM vendedores vd
JOIN vendas v ON v.id_vendedor = vd.id_vendedor
JOIN itens_venda i ON i.id_venda = v.id_venda
GROUP BY vd.nome
ORDER BY total_vendido DESC;