/*
 * Grupo: 5
 *      92433 - Carolina Pereira
 *      92565 - Tomás Sequeira
 *      92569 - Vicente Lorenzo
 *      89443 - Francisco Figueiredo
 */

----------------------------------------------------
--Deleting tables with the same name
---------------------------------------------------

DROP TABLE IF EXISTS d_tempo CASCADE;
DROP TABLE IF EXISTS d_instituicao CASCADE;
DROP TABLE IF EXISTS f_presc_venda CASCADE;
DROP TABLE IF EXISTS f_analise CASCADE;

----------------------------------------------------
--Table Creation
---------------------------------------------------

CREATE TABLE d_tempo
    (id_tempo SERIAL NOT NULL,
    dia INTEGER NOT NULL,
    dia_da_semana INTEGER NOT NULL,
    semana INTEGER NOT NULL,
    mes INTEGER NOT NULL,
    trimestre INTEGER NOT NULL,
    ano INTEGER NOT NULL,
    UNIQUE(dia,mes,ano),
    PRIMARY KEY(id_tempo));

CREATE TABLE d_instituicao
    (id_inst SERIAL NOT NULL,
    nome VARCHAR(40) NOT NULL,
    tipo VARCHAR(40) NOT NULL,
    num_regiao INTEGER NOT NULL,
    num_concelho INTEGER NOT NULL,
    FOREIGN KEY(nome) REFERENCES instituicao(nome) ON UPDATE CASCADE,
    FOREIGN KEY(num_regiao) REFERENCES regiao(num_regiao) ON UPDATE CASCADE,
    FOREIGN KEY(num_concelho) REFERENCES concelho(num_concelho) ON UPDATE CASCADE,
    PRIMARY KEY(id_inst));

CREATE TABLE f_presc_venda
    (id_presc_venda INTEGER NOT NULL,
    id_medico INTEGER NOT NULL,
    num_doente INTEGER NOT NULL,
    id_data_registo INTEGER NOT NULL,
    id_inst INTEGER NOT NULL,
    substancia VARCHAR(20) NOT NULL,
    quant INTEGER NOT NULL,
    FOREIGN KEY(id_presc_venda) REFERENCES prescricao_venda(num_venda) ON UPDATE CASCADE,
    FOREIGN KEY(id_medico) REFERENCES medico(num_cedula) ON UPDATE CASCADE,
    FOREIGN KEY(id_data_registo) REFERENCES d_tempo(id_tempo) ON UPDATE CASCADE,
    FOREIGN KEY(id_inst) REFERENCES d_instituicao(id_inst) ON UPDATE CASCADE,
    PRIMARY KEY(id_presc_venda));

CREATE TABLE f_analise
    (id_analise INTEGER NOT NULL,
     id_medico INTEGER NOT NULL,
     num_doente INTEGER NOT NULL,
     id_data_registo INTEGER NOT NULL,
     id_inst INTEGER NOT NULL,
     nome VARCHAR(30) NOT NULL,
     quant INTEGER NOT NULL,
     FOREIGN KEY(id_analise) REFERENCES analise(num_analise),
     FOREIGN KEY(id_medico) REFERENCES medico(num_cedula),
     FOREIGN KEY(id_data_registo) REFERENCES d_tempo(id_tempo),
     FOREIGN KEY(id_inst) REFERENCES d_instituicao(id_inst),
     PRIMARY KEY(id_analise));
