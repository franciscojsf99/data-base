#!/usr/bin/python3

from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template, request

# Libs postgres
import psycopg2
import psycopg2.extras

app = Flask(__name__)

# SGBD configs
DB_HOST = "db.tecnico.ulisboa.pt"
DB_USER = "ist192565"
DB_DATABASE = DB_USER
DB_PASSWORD = "bonc1323"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (
    DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)


@app.route('/')
def index():
    try:
        return render_template("index.html")
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/inserir_instituicao')
def inserir_instituicao():
    try:
        return render_template("inserir_instituicao.html", params=request.args)
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/remover_instituicao')
def remover_instituicao():
    try:
        return render_template("remover_instituicao.html", params=request.args)
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/editar_instituicao')
def editar_instituicao():
    try:
        return render_template("editar_instituicao.html", params=request.args)
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/instituicao_update', methods=["POST"])
def instituicao_update():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        if(int(request.form["flag_instituicao"]) == 1):
            query = f'''INSERT INTO instituicao VALUES (%s,%s,%s,%s);'''
            cursor.execute(query, (request.form["nome"], request.form["tipo"],
                                   request.form["num_regiao"], request.form["num_concelho"]))
        if(int(request.form["flag_instituicao"]) == 0):
            query = f'''DELETE FROM instituicao WHERE nome='{request.form["nome"]}';'''
            cursor.execute(query)
        if(int(request.form["flag_instituicao"]) == 2):
            query = f'''UPDATE instituicao SET tipo = %s, num_regiao = %s, num_concelho = %s WHERE nome = %s;'''
            cursor.execute(query, (request.form["tipo"], request.form["num_regiao"],
                                   request.form["num_concelho"], request.form["nome"]))
        return query
    except Exception as e:
        return str(e)  # Renders a page with the error.
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route('/inserir_medico')
def inserir_medico():
    try:
        return render_template("inserir_medico.html", params=request.args)
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/remover_medico')
def remover_medico():
    try:
        return render_template("remover_medico.html", params=request.args)
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/editar_medico')
def editar_medico():
    try:
        return render_template("editar_medico.html", params=request.args)
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/medico_update', methods=["POST"])
def medico_update():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        if(int(request.form["flag_medico"]) == 1):
            query = f'''INSERT INTO medico VALUES (%s,%s,%s);'''
            cursor.execute(
                query, (request.form["num_cedula"], request.form["nome"], request.form["especialidade"]))
        if(int(request.form["flag_medico"]) == 0):
            query = f'''DELETE FROM medico WHERE num_cedula={request.form["num_cedula"]};'''
            cursor.execute(query)
        if(int(request.form["flag_medico"]) == 2):
            query = f'''UPDATE medico SET nome = %s, especialidade = %s WHERE num_cedula = %s;'''
            cursor.execute(
                query, (request.form["nome"], request.form["especialidade"], request.form["num_cedula"]))
        return query
    except Exception as e:
        return str(e)  # Renders a page with the error.
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route('/inserir_prescricao')
def inserir_prescricao():
    try:
        return render_template("inserir_prescricao.html", params=request.args)
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/remover_prescricao')
def remover_prescricao():
    try:
        return render_template("remover_prescricao.html", params=request.args)
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/editar_prescricao')
def editar_prescricao():
    try:
        return render_template("editar_prescricao.html", params=request.args)
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/prescricao_update', methods=["POST"])
def prescricao_update():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        if(int(request.form["flag_prescricao"]) == 1):
            query = f'''INSERT INTO prescricao VALUES (%s,%s,%s,%s,%s);'''
            cursor.execute(query, (request.form["num_cedula"], request.form["num_doente"],
                                   request.form["data"], request.form["substancia"], request.form["quantidade"]))
        if(int(request.form["flag_prescricao"]) == 0):
            query = f'''DELETE FROM prescricao WHERE (num_cedula={request.form["num_cedula"]} AND num_doente = {request.form["num_doente"]} AND data_prescricao = '{request.form["data"]}' AND substancia = '{request.form["substancia"]}') ;'''
            cursor.execute(query)
        if(int(request.form["flag_prescricao"]) == 2):
            query = f'''UPDATE prescricao SET quant = %s WHERE (num_cedula = %s AND num_doente = %s AND data_prescricao = %s AND substancia = %s);'''
            cursor.execute(query, (request.form["quantidade"], request.form["num_cedula"],
                                   request.form["num_doente"], request.form["data"], request.form["substancia"]))
        return query
    except Exception as e:
        return str(e)  # Renders a page with the error.
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route('/inserir_analise')
def inserir_analise():
    try:
        return render_template("inserir_analise.html", params=request.args)
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/remover_analise')
def remover_analise():
    try:
        return render_template("remover_analise.html", params=request.args)
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/editar_analise')
def editar_analise():
    try:
        return render_template("editar_analise.html", params=request.args)
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/analise_update', methods=["POST"])
def analise_update():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        if(int(request.form["flag_analise"]) == 1):
            query = f'''INSERT INTO analise VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s);'''
            cursor.execute(query, (request.form["num_analise"], request.form["especialidade"], request.form["num_cedula"], request.form["num_doente"],
                                   request.form["data"], request.form["data_registo"], request.form["nome"], request.form["quantidade"], request.form["instituicao"]))
        if(int(request.form["flag_analise"]) == 0):
            query = f'''DELETE FROM analise WHERE num_analise = {request.form["num_analise"]} ;'''
            cursor.execute(query)
        if(int(request.form["flag_analise"]) == 2):
            query = f'''UPDATE analise SET especialidade = %s, num_cedula = %s, num_doente = %s, data_analise = %s, data_registo = %s, nome = %s, quant = %s, inst = %s WHERE num_analise = %s;'''
            cursor.execute(query, (request.form["especialidade"], request.form["num_cedula"], request.form["num_doente"], request.form["data"],
                                   request.form["data_registo"], request.form["nome"], request.form["quantidade"], request.form["instituicao"], request.form["num_analise"]))
        return query
    except Exception as e:
        return str(e)  # Renders a page with the error.
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route('/venda_farmacia_com_prescricao')
def venda_farmacia_com_prescricao():
    try:
        return render_template("venda_farmacia_com_prescricao.html", params=request.args)
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/venda_farmacia_sem_prescricao')
def venda_farmacia_sem_prescricao():
    try:
        return render_template("venda_farmacia_sem_prescricao.html", params=request.args)
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/vendas_update', methods=["POST"])
def vendas_update():
    dbConn = None
    cursor = None
    cursor2 = None
    cursor3 = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor2 = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        cursor3 = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        substancia = request.form["substancia"]
        data_registo = request.form["data_registo"]
        preco = request.form["preco"]
        instituicao = request.form["instituicao"]
        num_venda = request.form["num_venda"]

        if(int(request.form["flag_venda"]) == 1):
            num_cedula = request.form["num_cedula"]
            num_doente = request.form["num_doente"]
            data = request.form["data"]
            query = f'''\
			select quant
			from prescricao
			where num_cedula={num_cedula} and num_doente={num_doente} and data_prescricao='{data}' and substancia='{substancia}';
			'''
            cursor2.execute(query)
            quant = cursor2.fetchone()[0]

        elif(int(request.form["flag_venda"]) == 2):
            quant = request.form["quant"]

        query = f''' INSERT INTO venda_farmacia VALUES (%s,%s,%s,%s,%s,%s);'''
        cursor3.execute(query, (num_venda, data_registo,
                                substancia, quant, preco, instituicao))

        if(int(request.form["flag_venda"]) == 1):
            query = f'''INSERT INTO prescricao_venda VALUES (%s,%s,%s,%s,%s);'''
            cursor.execute(query, (num_cedula, num_doente,
                                   data, substancia, num_venda))

        return query
    except Exception as e:
        return str(e)  # Renders a page with the error.
    finally:
        dbConn.commit()
        cursor.close()
        cursor2.close()
        cursor3.close()
        dbConn.close()


@app.route('/list_substancia_prescrita')
def list_substancia_prescrita():
    try:
        return render_template("list_substancia_prescrita.html", params=request.args)
    except Exception as e:
        return str(e)  # Renders a page with the error.


@app.route('/list_substancia_prescrita_display', methods=["POST"])
def list_substancia_prescrita_display():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = f'''SELECT substancia FROM prescricao WHERE num_cedula = %s AND date_part('month', data_prescricao) = right(%s, 2)::double precision AND date_part('year', data_prescricao) = left(%s, 4)::double precision;'''
        cursor.execute(
            query, (request.form["num_cedula"], request.form["data"], request.form["data"]))
        rowcount = cursor.rowcount

        html = f'''
		<doctype html>
		  <title>Substância prescritas por um médico num dado mês do ano</title>
		  <body style="padding:20px">
		    <table border="3">
		      <thead>
		        <tr>
		          <th>Substância</th>
		        </tr>
		      </thead>
		      <tbody>
		'''
        for record in cursor:
            html += f'''
		            <tr>
		              <td>{record[0]}</td>
		          </tr>
		  '''
        html += '''
		          <tbody
		        </table>
		  </body>
		</doctype>
		'''

        return html  # Renders the html string
    except Exception as e:
        return str(e)  # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close()


@app.route('/max_min_valor_glicemia')
def max_min_valor_glicemia():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = f'''\
				select c.num_concelho, num_doente, quant
				from(select * from analise a join instituicao b on a.inst = b.nome)c
				join
				(select distinct t.num_concelho, max(t.quant)
				from(select num_concelho, quant, num_doente from analise a join instituicao b on a.inst = b.nome 
				where a.nome = 'glicemia')t group by t.num_concelho)b
				on (c.num_concelho=b.num_concelho AND c.quant = b.max);
				'''
        cursor.execute(query)
        rowcount = cursor.rowcount

        html = f'''
		<doctype html>
		  <title>Valores de Glicemia</title>
		  <header0> <b>Valores de Glicemia</b> </header0>
		  <body style="padding:20px">
		    <table border="3">
		      <thead>
		        <tr>
		          <th>Concelho</th>
				  <th>Número Doente</th>
				  <th>Valor Máximo</th>
		        </tr>
		      </thead>
		      <tbody>
		'''
        for record in cursor:
            html += f'''
		            <tr>
		              <td>{record[0]}</td>
					  <td>{record[1]}</td>
					  <td>{record[2]}</td>
		          </tr>
		  '''

        query = f'''\
				select c.num_concelho, num_doente, quant
				from(select * from analise a join instituicao b on a.inst = b.nome)c
				join
				(select distinct t.num_concelho, min(t.quant)
				from(select num_concelho, quant, num_doente from analise a join instituicao b on a.inst = b.nome 
				where a.nome = 'glicemia')t group by t.num_concelho)b
				on (c.num_concelho=b.num_concelho AND c.quant = b.min);
				'''
        cursor.execute(query)
        rowcount = cursor.rowcount

        html += f'''
		    <table border="3">
		      <thead>
		        <tr>
		          <th>Concelho</th>
				  <th>Número Doente</th>
				  <th>Valor Mínimo</th>
		        </tr>
		      </thead>
		      <tbody>
		'''
        for record in cursor:
            html += f'''
		            <tr>
		              <td>{record[0]}</td>
					  <td>{record[1]}</td>
					  <td>{record[2]}</td>
		          </tr>
		  '''
        html += '''
		          <tbody
		        </table>
		  </body>
		</doctype>
		'''

        return html  # Renders the html string
    except Exception as e:
        return str(e)  # Renders a page with the error.
    finally:
        cursor.close()
        dbConn.close()


CGIHandler().run(app)
