----Pedidos com clientes e endereços-----
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