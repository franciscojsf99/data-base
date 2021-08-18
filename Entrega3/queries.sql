/*
 * Grupo: 5
 *      92433 - Carolina Pereira
 *      92565 - Tomás Sequeira
 *      92569 - Vicente Lorenzo
 *      89443 - Francisco Figueiredo
 */

 --QUERY 1 = concelho com mais volume de vendas hoje
WITH aux AS(
	SELECT c.nome, c.num_concelho, SUM(quant) AS vendas
	FROM concelho AS c
	INNER JOIN instituicao AS i ON i.num_concelho=c.num_concelho
	INNER JOIN venda_farmacia AS v ON v.inst=i.nome
	WHERE v.data_registo = (SELECT  CURRENT_DATE)
	GROUP BY c.nome, c.num_concelho
)
SELECT aux.nome, aux.num_concelho, aux.vendas
FROM aux
WHERE aux.vendas = (
	SELECT MAX(aux_b.vendas)
	FROM aux AS aux_b
);

--QUERY 2 = medico com mais prescricoes de 01/01/2019 a 30/06/2019 por regiao
WITH aux AS (
	SELECT  i.num_regiao, m.nome, c.num_cedula, COUNT(c.num_cedula) AS count_prescricoes
	FROM prescricao AS p
	INNER JOIN consulta AS c ON p.num_cedula=c.num_cedula AND p.num_doente=c.num_doente AND p.data_prescricao=c.data_consulta
	INNER JOIN instituicao AS i ON i.nome=c.nome
	INNER JOIN medico as m ON m.num_cedula=c.num_cedula
	WHERE data_prescricao BETWEEN '01-01-2019' AND '30-06-2019'
	GROUP BY i.num_regiao, m.nome, c.num_cedula
)
SELECT  aux.num_regiao, aux.nome, aux.num_cedula, aux.count_prescricoes
FROM aux
WHERE (aux.num_regiao, aux.count_prescricoes) IN (
	SELECT aux.num_regiao, MAX(aux.count_prescricoes)
	FROM aux
	GROUP BY aux.num_regiao
)
ORDER BY 1, 2, 3;

--QUERY 3 = medicos que prescreveram aspirina em todas as farmacias de Arouca este ano
WITH aux AS (
	SELECT m.nome AS medico, m.num_cedula AS num_cedula, i.nome AS farmacia
	FROM prescricao AS p
	INNER JOIN consulta AS c ON p.num_cedula=c.num_cedula AND p.num_doente=c.num_doente AND p.data_prescricao=c.data_consulta
	INNER JOIN instituicao AS i ON i.nome=c.nome
	INNER JOIN medico as m ON m.num_cedula=c.num_cedula
	INNER JOIN concelho as co ON i.num_concelho=co.num_concelho
	WHERE p.substancia = 'aspirina' 
	AND i.tipo = 'farmacia'
	AND co.nome = 'Arouca' 
	AND (EXTRACT(YEAR FROM p.data_prescricao) = EXTRACT(YEAR FROM CURRENT_DATE))
	group by m.nome, m.num_cedula, i.nome
)
SELECT aux.medico, aux.num_cedula, COUNT(DISTINCT aux.farmacia)
FROM aux
GROUP BY aux.medico, aux.num_cedula
HAVING COUNT(DISTINCT aux.farmacia) = (
	SELECT COUNT(*)
	FROM instituicao AS i
	INNER JOIN concelho AS c ON i.num_concelho = c.num_concelho
	WHERE c.nome = 'Arouca' AND i.tipo='farmacia'
);

--QUERY 4 = doentes que tiveram analises mas ainda nao aviaram prescricoes este mes
SELECT  num_doente
FROM analise
WHERE (EXTRACT(MONTH FROM data_analise)= EXTRACT(MONTH FROM CURRENT_DATE))
GROUP BY  num_doente EXCEPT(
	SELECT num_doente
	FROM prescricao_venda
	WHERE (EXTRACT(MONTH FROM data_prescricao_venda) = EXTRACT(MONTH FROM CURRENT_DATE))
	GROUP BY  num_doente
);
