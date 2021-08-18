/*
 * Grupo: 5
 *      92433 - Carolina Pereira
 *      92565 - Tomás Sequeira
 *      92569 - Vicente Lorenzo
 *      89443 - Francisco Figueiredo
 */
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

create trigger triggerNConsultas before insert on consulta for each row execute procedure triggerCemConsultas();
create trigger triggerOmissa before insert on analise for each row execute procedure triggerConsultaOmissa();

