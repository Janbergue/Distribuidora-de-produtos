<div align="center">
<h1 style="color:#20B2AA;" > # Distribuidora-de-produtos <h/h1>
<h3>Projeto Acadêmico - Faculdade Cruzeiro do Sul </h3>

  O sistema de distribuição funciona como intermediário entre fabricantes e varejistas. Seu público-alvo são supermercados, restaurantes e lojas de conveniência. Ele gerencia todo o ciclo de operações, incluindo estoque, vendas, pedidos e entregas. Em sua funcionalidade há: Controle de estoque e produtos, gestão de clientes e fabricantes, processamento de pedidos de venda, rastreamento de entregas e relatórios comerciais.

  É composto pelas tabelas principais: 
  cliente (podendo ser lojas, restaurantes e supermercados)
  fabricante (fornecedores dos produtos)
  produto (itens comercializados)
  pedido (pedidos de fato)
  item_pedido (produtos dentro dos pedidos)
  entrega (informações da logística)
  endereco (enredeço para a entrega poder ser realziada)

  Criamos o MER dos projetos durante a primeira semana, com PKs e Fks inicialmente, onde tivemos contato com o contexto da modelagem de bancos de dados.
  Passamos para a criação do DER, que é o modelo conceitual, já com suas primeiras relações entre as tabelas, entidades, atributos, atômicidade. Foi elegido pela professora que utilizássemos o SQLiteStudio, por ser um software mais leve. Com isso iniciamos a implementação prática, análise de requisitos, dependências funcionais, aplicação das formas normais 1FN, 2FN e 3FN. Durante a semana pósterior incluímos comandos DML (INSERT, SELECT, UPDATE e DELETE) para complementar o gerenciamento dos dados.  
  

  <h3> Exemplos de uso </h3>

  Inserir fabricantes
  INSERT INTO fabricante (CNPJ, razao_social, nome_fantasia, telefone, email) VALUES

  Inserir produto
  INSERT INTO produto (codigo, nome, descricao, categoria, preco_custo, quantidade_estoque, unidade_medida, CNPJ_fabricante, ativo) VALUES

  Inserir cliente
  INSERT INTO cliente (CNPJ, razao_social, nome_fantasia, telefone, email, tipo_estabelecimento) VALUES
  
  Consultar pedidos com itens:
  SELECT p.numero_pedido, c.nome_fantasia, p.valor_total, p.status
  FROM pedido p
  JOIN cliente c ON p.cnpj_cliente = c.cnpj;

  Consultar estoque baixo:
  SELECT nome, quantidade_estoque, estoque_minimo
  FROM produto 
  WHERE quantidade_estoque < estoque_minimo;

  Remover itens com quantidade zero do estoque:
  DELETE FROM item_pedido 
  WHERE quantidade = 0;

Selecionar pedidos com clientes e endereços:
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

  <h3> Como o projeto é acadêmico e pensado para pequenas empresas de distribuição, foi utilizado o SQLiteStudio, pode ser transferido para outro sistema mudando o TEXT para VARCHAR. </h3>
