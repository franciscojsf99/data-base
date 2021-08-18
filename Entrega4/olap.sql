/*
 * Grupo: 5
 *      92433 - Carolina Pereira
 *      92565 - Tomás Sequeira
 *      92569 - Vicente Lorenzo
 *      89443 - Francisco Figueiredo
 */
SELECT a.especialidade, t.mes, t.ano, COUNT(*) AS analises_glicemia
FROM f_analise AS f_a
INNER JOIN analise AS a ON (f_a.id_analise = a.num_analise)
INNER JOIN d_tempo AS t ON (f_a.id_data_registo = t.id_tempo)
WHERE t.ano >= '2017' AND t.ano <= '2020'
GROUP BY (t.ano, t.mes), ROLLUP (a.especialidade);


SELECT c.nome AS concelho, p.substancia, t.mes, t.dia_da_semana, COUNT(*) as quantidade_total, COUNT(*)/91::float as nr_medio_prescricoes_diario
FROM f_presc_venda AS p
INNER JOIN d_tempo AS t ON p.id_data_registo=t.id_tempo
INNER JOIN d_instituicao AS i ON p.id_inst=i.id_inst
INNER JOIN concelho AS c ON i.num_concelho=c.num_concelho
INNER JOIN regiao AS r ON i.num_regiao=r.num_regiao
WHERE t.trimestre='1' AND t.ano='2020' AND r.nome='Lisboa'
GROUP BY GROUPING SETS((p.substancia, c.nome, t.mes, t.dia_da_semana), (c.nome), (t.mes, t.dia_da_semana));