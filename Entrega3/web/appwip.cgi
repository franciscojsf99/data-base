#!/usr/bin/python3

from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template, request

## Libs postgres
import psycopg2
import psycopg2.extras

app = Flask(__name__)

## SGBD configs
DB_HOST="db.tecnico.ulisboa.pt"
DB_USER="ist192565"
DB_DATABASE=DB_USER
DB_PASSWORD="bonc1323"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)

@app.route('/')
def index():
	try:
		return render_template("index.html")
	except Exception as e:
		return str(e) #Renders a page with the error.

@app.route('/inserir_instituicao')
def inserir_instituicao():
	try:
		return render_template("inserir_instituicao.html",params=request.args)
	except Exception as e:
		return str(e) #Renders a page with the error.

@app.route('/inserir_instituicao_update', methods=["POST"])
def inserir_instituicao_update():
	dbConn=None
	cursor=None
	try:
		dbConn = psycopg2.connect(DB_CONNECTION_STRING)
		cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
		query = f'''INSERT INTO instituicao VALUES (%s,%s,%d,%d);'''
		cursor.execute(query, (request.form["nome"],request.form["tipo"],request.form["num_regiao"],request.form["num_concelho"]))
		return query
	except Exception as e:
		return str(e) #Renders a page with the error.
	finally:
		dbConn.commit()
		cursor.close()
		dbConn.close()

@app.route('/list_substancia_prescrita')
def list_substancia_prescrita():
	try:
		return render_template("list_substancia_prescrita.html",params=request.args)
	except Exception as e:
		return str(e) #Renders a page with the error.

@app.route('/list_substancia_prescrita_display', methods=["POST"])
def list_substancia_prescrita_display():
	dbConn=None
	cursor=None
	try:
		dbConn = psycopg2.connect(DB_CONNECTION_STRING)
		cursor = dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
		query = f'''SELECT substancia FROM prescricao WHERE num_cedula = %d AND date_part('month', data_prescricao) = right(%s, 2)::double precision AND date_part('year', data_prescricao) = left(%s, 4)::double precision;'''
		cursor.execute(query, (request.form["num_cedula"],request.form["data"],request.form["data"]))
		rowcount=cursor.rowcount

		html=f'''
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
		  html+=f'''
		            <tr>
		              <td>{record[0]}</td>
		          </tr>
		  '''
		html+='''
		          <tbody
		        </table>
		  </body>
		</doctype>
		'''

		return html #Renders the html string
	except Exception as e:
		return str(e) #Renders a page with the error.
	finally:
		cursor.close()
		dbConn.close()

CGIHandler().run(app)
