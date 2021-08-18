--1--
--select data from consulta where num_doente = <um_valor>
create index index_consulta on consulta using hash(num_doente)
--Para o primeiro caso, é necessário criar um índice para organizar a coluna do num_doente com uma HashTable para facilitar a comparação direta. Neste caso prefere-se a utilização de
--hash table visto ser uma simples igualdade.

--2--
--select count (*) from medico where especialidade = “Ei”
create index index_medico on medico using hash(especialidade)
--Para o segundo caso, é necessário criar um índice para a especialidade como forma de otimizar a query e neste caso como é apenas uma comparação simples,
--prefere-se o uso de uma hash table.

--3--
--select nome from medico where especialidade = ‘Ei’
create index index_medico on medico using btree(especialidade)
--Neste caso como temos blocos de apenas 2KB é preferível usar uma btree para cada "especialidade"  visto que é preferível ter ligações feitas por apontadores em vez
--de ter os blocos fisicamente juntos no disco

--4--
--select nome from medico, consulta
--where consulta.num_cedula=medico.num_cedula AND
--consulta.data_consulta BETWEEN ‘data_1’ AND ‘data_2’
create index_medico_1 on medico using hash(num_cedula)
create index_consulta_1 on consulta using hash(num_cedula)
create index_consulta_2 on consulta using btree(data_consulta)
--Criamos duas hash para tornar a comparação entre num_cedula mais rapida e depois criamos um índice para tornar a comparação de datas mais rápida.