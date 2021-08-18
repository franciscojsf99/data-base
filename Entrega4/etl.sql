/*
 * Grupo: 5
 *      92433 - Carolina Pereira
 *      92565 - Tomás Sequeira
 *      92569 - Vicente Lorenzo
 *      89443 - Francisco Figueiredo
 */

INSERT INTO d_tempo(dia, dia_da_semana, semana, mes, trimestre, ano)
    SELECT distinct EXTRACT(DAY FROM t.data_prescricao_venda) AS dia,
    EXTRACT(DOW FROM t.data_prescricao_venda) AS dia_da_semana,
    EXTRACT(WEEK FROM t.data_prescricao_venda) AS semana,
    EXTRACT(MONTH FROM t.data_prescricao_venda) AS mes,
    EXTRACT(QUARTER FROM t.data_prescricao_venda) AS trimestre,
    EXTRACT(YEAR FROM t.data_prescricao_venda) AS ano
    FROM ((select data_prescricao_venda from prescricao_venda)
        UNION
        (select data_registo from analise)) as t
    ORDER BY dia,dia_da_semana,semana,mes,trimestre,ano;

INSERT INTO d_instituicao(nome, tipo, num_regiao, num_concelho)
    SELECT nome,tipo,num_regiao,num_concelho FROM instituicao;

INSERT INTO f_presc_venda(id_presc_venda, id_medico, num_doente, id_data_registo, id_inst, substancia, quant)
    SELECT P.num_venda as id_presc_venda, P.num_cedula as id_medico, num_doente, id_tempo as id_data_registo, id_inst, P.substancia, quant
    FROM prescricao_venda P NATURAL JOIN medico M 
    INNER JOIN venda_farmacia V ON(P.num_venda = V.num_venda)
    INNER JOIN d_tempo T ON (DATE_PART('day',P.data_prescricao_venda) = T.dia AND DATE_PART('month',P.data_prescricao_venda) = T.mes AND DATE_PART('year',P.data_prescricao_venda) = T.ano) 
    INNER JOIN d_instituicao I ON (V.inst = I.nome)
    ORDER BY P.num_venda, P.num_cedula, num_doente, id_tempo, id_inst, P.substancia, quant;

INSERT INTO f_analise(id_analise, id_medico, num_doente, id_data_registo, id_inst, nome, quant)
    SELECT num_analise as id_analise, A.num_cedula as id_medico, A.num_doente, id_tempo as id_data_registo, id_inst, A.nome, quant
    FROM analise A INNER JOIN  medico M ON(A.num_cedula = M.num_cedula)
    INNER JOIN d_tempo T ON (DATE_PART('day',A.data_registo) = T.dia AND DATE_PART('month',A.data_registo) = T.mes AND DATE_PART('year',A.data_registo) = T.ano) 
    INNER JOIN d_instituicao I ON (A.inst = I.nome)
    ORDER BY num_analise, A.num_cedula, A.num_doente, id_tempo, id_inst, I.nome, quant;