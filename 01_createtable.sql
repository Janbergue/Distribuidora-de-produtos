BEGIN TRANSACTION;

-----Tabela Fabricante-----
CREATE TABLE fabricante (
    CNPJ TEXT PRIMARY KEY,
    razao_social TEXT NOT NULL,
    nome_fantasia TEXT,
    telefone TEXT,
    email TEXT,
    data_cadastro TEXT DEFAULT CURRENT_DATE
);

-----Tabela Markup_Categoria-----
CREATE TABLE markup_categoria (
    categoria TEXT PRIMARY KEY,
    markup_percentual REAL NOT NULL CHECK (markup_percentual >= 1.00)
);

-----Tabela Produto-----
CREATE TABLE produto (
    codigo TEXT PRIMARY KEY,
    nome TEXT NOT NULL,
    descricao TEXT,
    categoria TEXT,
    preco_custo REAL CHECK (preco_custo > 0),
    quantidade_estoque INTEGER DEFAULT 0 CHECK (quantidade_estoque >= 0),
    estoque_minimo INTEGER DEFAULT 10 CHECK (estoque_minimo >= 0),
    unidade_medida TEXT,
    CNPJ_fabricante TEXT NOT NULL,
    ativo INTEGER DEFAULT 1,
    FOREIGN KEY (CNPJ_fabricante) REFERENCES fabricante(CNPJ),
    FOREIGN KEY (categoria) REFERENCES markup_categoria(categoria)
);

-----Tabela Cliente-----
CREATE TABLE cliente (
    CNPJ TEXT PRIMARY KEY,
    razao_social TEXT NOT NULL,
    nome_fantasia TEXT,
    telefone TEXT,
    email TEXT,
    tipo_estabelecimento TEXT,
    data_cadastro TEXT DEFAULT CURRENT_DATE
);

-----Tabela cep_info-----
CREATE TABLE cep_info (
    cep TEXT PRIMARY KEY,
    logradouro TEXT,
    bairro TEXT,
    cidade TEXT NOT NULL,
    estado TEXT NOT NULL
);

-----Tabela endereco-----
CREATE TABLE endereco (
    id_endereco INTEGER PRIMARY KEY AUTOINCREMENT,
    CNPJ_cliente TEXT NOT NULL,
    logradouro TEXT NOT NULL,
    numero TEXT NOT NULL,
    complemento TEXT,
    bairro TEXT,
    cep TEXT NOT NULL,
    tipo TEXT,
    FOREIGN KEY (CNPJ_cliente) REFERENCES cliente(CNPJ),
    FOREIGN KEY (cep) REFERENCES cep_info(cep)
);

-----Tabela Pedido-----
CREATE TABLE pedido (
    numero_pedido TEXT PRIMARY KEY,
    data_pedido TEXT NOT NULL,
    data_entrega_prevista TEXT,
    status TEXT DEFAULT 'PENDENTE',
    observacoes TEXT,
    CNPJ_cliente TEXT NOT NULL,
    forma_pagamento TEXT,
    FOREIGN KEY (CNPJ_cliente) REFERENCES cliente(CNPJ)
);

-----Tabela item_pedido-----
CREATE TABLE item_pedido (
    numero_pedido TEXT,
    codigo_produto TEXT,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario REAL NOT NULL CHECK (preco_unitario > 0),
    desconto REAL DEFAULT 0 CHECK (desconto >= 0),
    PRIMARY KEY (numero_pedido, codigo_produto),
    FOREIGN KEY (numero_pedido) REFERENCES pedido(numero_pedido) ON DELETE CASCADE,
    FOREIGN KEY (codigo_produto) REFERENCES produto(codigo)
);

-----Tabela fornecedor_logistica-----
CREATE TABLE fornecedor_logistica (
    CNPJ TEXT PRIMARY KEY,
    razao_social TEXT NOT NULL,
    telefone TEXT,
    email TEXT,
    tipo_servico TEXT,
    avaliacao REAL CHECK (avaliacao BETWEEN 0 AND 5)
);

-----Tabela Entrega-----
CREATE TABLE entrega (
    codigo_rastreio TEXT PRIMARY KEY,
    data_envio TEXT,
    data_entrega_real TEXT,
    status_entrega TEXT DEFAULT 'AGUARDANDO',
    observacoes TEXT,
    CNPJ_fornecedor TEXT NOT NULL,
    numero_pedido TEXT NOT NULL UNIQUE,
    FOREIGN KEY (CNPJ_fornecedor) REFERENCES fornecedor_logistica(CNPJ),
    FOREIGN KEY (numero_pedido) REFERENCES pedido(numero_pedido)
);

-----Inserir fabricantes-----
INSERT INTO fabricante (CNPJ, razao_social, nome_fantasia, telefone, email) VALUES
('12.345.678/0001-90', 'Alimentos Brasil Ltda', 'Alimentos Brasil', '(11) 2222-3333', 'vendas@alimentosbrasil.com.br'),
('23.456.789/0001-00', 'Bebidas Nacionais S.A.', 'Bebidas Nacionais', '(11) 3333-4444', 'contato@bebidasnacionais.com.br'),
('34.567.890/0001-11', 'Limpeza Total Indústria', 'Limpeza Total', '(11) 4444-5555', 'vendas@limpezatotal.com.br');

-----Inserir produtos-----
INSERT INTO produto (codigo, nome, descricao, categoria, preco_custo, quantidade_estoque, unidade_medida, CNPJ_fabricante, ativo) VALUES
('ARZ001', 'Arroz Tipo 1', 'Arroz branco tipo 1 pacote 5kg', 'ALIMENTOS', 18.50, 150, 'PC', '12.345.678/0001-90', 1),
('FJA001', 'Feijão Carioca', 'Feijão carioca pacote 1kg', 'ALIMENTOS', 6.80, 200, 'PC', '12.345.678/0001-90', 1),
('REF001', 'Refrigerante Cola', 'Refrigerante cola lata 350ml', 'BEBIDAS', 2.50, 300, 'UN', '23.456.789/0001-00', 1),
('SAB001', 'Sabão em Pó', 'Sabão em pó para roupas 1kg', 'LIMPEZA', 8.90, 100, 'PC', '34.567.890/0001-11', 1),
('SHM001', 'Shampoo', 'Shampoo para cabelos normais 500ml', 'HIGIENE', 4.50, 80, 'UN', '34.567.890/0001-11', 1);

-----Inserir clientes-----
INSERT INTO cliente (CNPJ, razao_social, nome_fantasia, telefone, email, tipo_estabelecimento) VALUES
('98.765.432/0001-10', 'Supermercado Preço Bom Ltda', 'Preço Bom', '(11) 5555-6666', 'compras@precobom.com.br', 'SUPERMERCADO'),
('87.654.321/0001-20', 'Restaurante Sabor Caseiro ME', 'Sabor Caseiro', '(11) 6666-7777', 'pedidos@saborcaseiro.com', 'RESTAURANTE'),
('76.543.210/0001-30', 'Padaria Pão Quente Ltda', 'Pão Quente', '(11) 7777-8888', 'contato@paoquente.com.br', 'PADARIA');

select * from  cliente

-----Consultar pedidos com itens-----
SELECT p.numero_pedido, c.nome_fantasia, p.valor_total, p.status
FROM pedido p
JOIN cliente c ON p.cnpj_cliente = c.cnpj;

-----Consultar estoque baixo------
SELECT nome, quantidade_estoque, estoque_minimo
FROM produto 
WHERE quantidade_estoque < estoque_minimo;

-----Remover itens com quantidade zero-----
DELETE FROM item_pedido 
WHERE quantidade = 0;

-----Confirmar a remoção-----
SELECT 'Itens removidos: ' || changes() as resultado;

-----Pedidos com clientes e endereços-----
SELECT 
    p.numero_pedido,
    p.data_pedido,
    c.nome_fantasia as cliente,
    c.tipo_estabelecimento,
    e.logradouro,
    e.numero,
    e.bairro,
    ci.cidade,
    ci.estado
FROM pedido p
INNER JOIN cliente c ON p.CNPJ_cliente = c.CNPJ
INNER JOIN endereco e ON c.CNPJ = e.CNPJ_cliente
INNER JOIN cep_info ci ON e.cep = ci.cep
WHERE e.tipo = 'COMERCIAL';

-----Todos os produtos, mesmo os que nunca foram vendidos-----
SELECT 
    p.codigo,
    p.nome,
    p.categoria,
    p.quantidade_estoque,
    COUNT(ip.codigo_produto) as vezes_vendido
FROM produto p
LEFT JOIN item_pedido ip ON p.codigo = ip.codigo_produto
GROUP BY p.codigo, p.nome, p.categoria, p.quantidade_estoque
ORDER BY vezes_vendido DESC;

-----Análise completa de vendas por fabricante-----
SELECT 
    f.nome_fantasia as fabricante,
    p.categoria,
    COUNT(DISTINCT ip.numero_pedido) as total_pedidos,
    SUM(ip.quantidade) as total_quantidade_vendida,
    SUM(ip.quantidade * ip.preco_unitario) as valor_total_vendas,
    AVG(mc.markup_percentual) as markup_medio
FROM fabricante f
INNER JOIN produto p ON f.CNPJ = p.CNPJ_fabricante
INNER JOIN item_pedido ip ON p.codigo = ip.codigo_produto
INNER JOIN markup_categoria mc ON p.categoria = mc.categoria
GROUP BY f.nome_fantasia, p.categoria
ORDER BY valor_total_vendas DESC;

