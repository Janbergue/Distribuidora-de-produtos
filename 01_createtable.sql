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