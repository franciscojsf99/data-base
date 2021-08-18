/*
 * Grupo: 5
 *      92433 - Carolina Pereira
 *      92565 - Tomás Sequeira
 *      92569 - Vicente Lorenzo
 *      89443 - Francisco Figueiredo
 */

DROP TABLE IF EXISTS prescricao_venda CASCADE;
DROP TABLE IF EXISTS prescricao CASCADE;
DROP TABLE IF EXISTS venda_farmacia CASCADE;
DROP TABLE IF EXISTS analise CASCADE;
DROP TABLE IF EXISTS consulta CASCADE;
DROP TABLE IF EXISTS instituicao CASCADE;
DROP TABLE IF EXISTS concelho CASCADE;
DROP TABLE IF EXISTS medico CASCADE;
DROP TABLE IF EXISTS regiao CASCADE;
DROP TABLE IF EXISTS concelho_aux CASCADE;

----------------------------------------------------
--Table Creation
----------------------------------------------------

--regiao(num_regiao, nome, num_habitantes)
--RI-regiao-1: nome = {Norte, Centro, Lisboa, Alentejo, Algarve}

CREATE TABLE regiao
    (num_regiao integer NOT NULL,
     nome varchar(20) NOT NULL,
     num_habitantes BIGINT NOT NULL,
     CHECK (nome IN ('Norte', 'Lisboa', 'Centro', 'Alentejo', 'Algarve')),
     PRIMARY KEY(num_regiao));

CREATE TABLE concelho_aux
    (nome varchar(40) NOT NULL,
    PRIMARY KEY(nome));

--concelho(num_concelho, num_regiao, nome, num_habitantes)
--num_regiao: FK regiao (num_regiao)
--RI-concelho-1: nome = {concelho de portugal continental}

CREATE TABLE concelho
    (num_concelho integer NOT NULL UNIQUE,
     num_regiao  integer NOT NULL,
     nome varchar(40) NOT NULL,
     FOREIGN KEY(nome) REFERENCES concelho_aux(nome) ON UPDATE CASCADE,
     num_habitantes integer NOT NULL, 
     FOREIGN KEY(num_regiao) REFERENCES regiao(num_regiao) ON UPDATE CASCADE,
     PRIMARY KEY(num_concelho,num_regiao));

--instituicao(nome, tipo, num_regiao, num_concelho)
--num_regiao, num_concelho: FK concelho (regiao, concelho)
--RI-instituicao-1: tipo = {farmacia, laboratorio, clinica, hospital}

CREATE TABLE instituicao
    (nome varchar(20) NOT NULL UNIQUE,
     tipo varchar(20) NOT NULL,
     num_regiao  integer NOT NULL,
     num_concelho integer NOT NULL,
     CHECK (tipo IN ('farmacia', 'laboratorio', 'clinica', 'hospital')),
     FOREIGN KEY(num_concelho,num_regiao) REFERENCES concelho(num_concelho,num_regiao) ON UPDATE CASCADE,
     PRIMARY KEY(nome));

 --medico(num_cedula, nome, especialidade)

CREATE TABLE medico
    (num_cedula integer NOT NULL UNIQUE,
     nome varchar(20) NOT NULL,
     especialidade varchar(20) NOT NULL,
     PRIMARY KEY(num_cedula));

--consulta(num_cedula, num_doente, data, nome_instituicao)
--num_cedula: FK medico (num_cedula)
--nome_instituicao: FK instituicao (nome)
--RI-consulta-1: um médico não pode ver doentes ao fim de semana
--RI-consulta-2: um doente não pode ter mais de uma consulta por dia na mesma instituição


CREATE TABLE consulta
    (num_cedula integer NOT NULL,
     num_doente integer NOT NULL,
     data_consulta date NOT NULL,
     nome varchar(20) NOT NULL,
     CHECK(EXTRACT(DOW FROM data_consulta) NOT IN (6,0)),
     UNIQUE(num_doente,data_consulta,nome),
     FOREIGN KEY(nome) REFERENCES instituicao(nome) ON UPDATE CASCADE,
     FOREIGN KEY(num_cedula) REFERENCES medico(num_cedula) ON UPDATE CASCADE,
     PRIMARY KEY(num_cedula,num_doente,data_consulta));

--prescricao(num_cedula, num_doente, data, substancia, quant)
--num_cedula, num_doente, data: FK consulta (num_cedula, num_doente, data)


CREATE TABLE prescricao
    (num_cedula integer NOT NULL,
     num_doente integer NOT NULL,
     data_prescricao date NOT NULL,
     substancia varchar(20) NOT NULL,
     quant integer NOT NULL,
     FOREIGN KEY(num_cedula,num_doente,data_prescricao) REFERENCES consulta(num_cedula,num_doente,data_consulta) ON UPDATE CASCADE,
     PRIMARY KEY(num_cedula,num_doente,data_prescricao,substancia));

--analise(num_analise, especialidade, num_cedula, num_doente, data, data_registo, nome, quant, inst)
--num_cedula, num_doente, data: FK consulta (num_cedula, num_doente, data)
--inst: FK instituicao (nome)
--RI-analise: a consulta associada pode estar omissa; não estando, a especialidade da consulta tem de ser igual à do médico

CREATE TABLE analise
    (num_analise integer NOT NULL UNIQUE,
     especialidade varchar(20) NOT NULL,
     num_cedula integer ,
     num_doente integer ,
     data_analise date ,
     data_registo date NOT NULL,
     nome varchar(20) NOT NULL,
     quant integer NOT NULL,
     inst varchar(20) NOT NULL,
     FOREIGN KEY(num_cedula,num_doente,data_analise) REFERENCES consulta(num_cedula,num_doente,data_consulta) ON UPDATE CASCADE,
     FOREIGN KEY(inst) REFERENCES instituicao(nome) ON UPDATE CASCADE,
     PRIMARY KEY(num_analise)); 

--venda_farmacia(num_venda, data_registo, substancia, quant, preco, inst)
--inst: FK instituicao (nome)

CREATE TABLE venda_farmacia
    (num_venda integer NOT NULL,
     data_registo date NOT NULL,
     substancia varchar(20) NOT NULL,
     quant integer NOT NULL,
     preco integer NOT NULL,
     inst varchar(20) NOT NULL,
     FOREIGN KEY(inst) REFERENCES instituicao(nome) ON UPDATE CASCADE,
     PRIMARY KEY(num_venda));

--prescricao_venda(num_cedula, num_doente, data, substancia, num_venda)
--num_venda: FK venda_farmacia (num_venda)
--num_cedula, num_doente, data, substancia: FK prescricao (num_cedula, num_doente, data, substancia)

CREATE TABLE prescricao_venda 
    (num_cedula integer NOT NULL,
     num_doente integer NOT NULL, 
    data_prescricao_venda date NOT NULL, 
    substancia varchar(20) NOT NULL, 
    num_venda integer NOT NULL UNIQUE, 
    FOREIGN KEY(num_cedula,num_doente,data_prescricao_venda,substancia) REFERENCES prescricao(num_cedula,num_doente,data_prescricao,substancia) ON UPDATE CASCADE, 
    FOREIGN KEY(num_venda) REFERENCES venda_farmacia(num_venda), 
    PRIMARY KEY(num_venda,num_doente,num_cedula,data_prescricao_venda,substancia));

create or replace function triggerCemConsultas() returns 
    trigger as $$
    declare nConsultas integer;
    begin
        select count(*) into nConsultas from consulta 
        where(num_cedula=new.num_cedula AND nome=new.nome AND DATE_PART('week',data_consulta)=DATE_PART('week',new.data_consulta));
        if nConsultas > 100 then
            raise exception 'Médico já tem 100 consultas para essa instituição na mesma semana';
        end if;
        return new;
    end;
$$ language plpgsql;

create or replace function triggerConsultaOmissa() returns 
    trigger as $$
    declare espec varchar(20);
    begin
        if (new.num_cedula IS NOT NULL AND new.num_doente IS NOT NULL AND new.data_analise IS NOT NULL) then
            select especialidade into espec from medico
            where (num_cedula = new.num_cedula);
            if espec != new.especialidade then
                raise exception 'A especialidade do médico é diferente da especialidade da consulta';
            end if;
        end if;
        return new;
    end;
$$ language plpgsql;

--DROP TRIGGER IF EXISTS triggerNConsultas ON consulta;
--DROP TRIGGER IF EXISTS triggerOmissa ON analise;

create trigger triggerNConsultas before insert on consulta for each row execute procedure triggerCemConsultas();
create trigger triggerOmissa before insert on analise for each row execute procedure triggerConsultaOmissa();
create trigger triggerNConsultas before update on consulta for each row execute procedure triggerCemConsultas();
create trigger triggerOmissa before update on analise for each row execute procedure triggerConsultaOmissa();
