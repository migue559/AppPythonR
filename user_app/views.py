from R import app,db,lm,api_twitter
from flask import url_for, redirect, render_template, flash, g, session,request, jsonify
from mongo import mongo_objects
from user_app.forms  import WordSearch




@app.route('/index')
def index():
	usr=session['username']
	#return "este es el usuario logueado %s" % usr
	return render_template('/user_app/index.html', usr=usr)

@app.route('/_add_numbers2')
def add_numbers2():
	word = request.args.get('word', '', type=str)
	if word:
		result=api_twitter.GetUsersSearch(word)
		mi_lista=list=[]
		for u in result:
			mi_lista.append(u.screen_name)
		return jsonify(result=mi_lista)
		return mi_lista
	else:
		word='vacio'
		return jsonify(result=word)


@app.route('/bayes', methods=['GET','POST'])
def bayes():
	usr=session['username']
	error=None	
	word=request.form.get('word_search')
	if word:
		result=api_twitter.GetUsersSearch(word)
		mi_lista=list=[]
		for u in result:
			mi_lista.append(u.screen_name)
		return redirect(url_for('prueba',lista=mi_lista))
	return render_template('/user_app/bayes.html',usr=usr,error=error)

@app.route('/prueba/<lista>', methods=['GET','POST'])
def prueba(lista):
	usr=session['username']
	error=None	
	newstr = lista.replace("'", "")
	newstr=newstr[1:-1]
	mi_lista=newstr.split(",") 	
	return render_template('/user_app/prueba.html',usr=usr,error=error,lista=mi_lista)


@app.route('/algo', methods=['GET','POST'])
def algo():
	usr=session['username']
	error="sin error"	
	word=request.form.get('user')
	return "algo aqui %s %s %s " %(usr,error,word)

"""	
	try:
		word=request.form['word_search']
		word=request.form['word_search']
		if word != "" and word!=None:
			result=api_twitter.GetUsersSearch(word)
			mi_lista=list=[]
			milista=list=[1,2,3,4]
			for u in result:
				mi_lista.append(u.screen_name)
			#return "result. %s" %mi_lista
			render_template('/user_app/bayes.html',usr=usr,error=error)
			#return "Obtener las cuentas para obtener el top hashtag %s" %mi_lista
		else:
			render_template('/user_app/bayes.html', usr=usr,error=error)	
	except:
		return render_template('/user_app/bayes.html', usr=usr,error=error)	
"""	
@app.route('/arima')
def arima():
	usr=session['username']
	#return "este es el usuario logueado %s" % usr
	return render_template('/user_app/arima.html', usr=usr)		




@app.route('/_add_numbers')
def add_numbers():
    """Add two numbers server side, ridiculous but well..."""
    a = request.args.get('a', 0, type=int)
    b = request.args.get('b', 0, type=int)
    return jsonify(result=a + b)


@app.route('/test')
def test():
    return render_template('test.html')

