from R import app,db,lm
from flask import url_for, redirect, render_template, flash, g, session,request
#from flask_login import login_user, logout_user, current_user, login_required

from user.forms  import LoginForm,RegisterForm
from user.models import User
from mongo import mongo_objects
import bcrypt




@app.route('/inicio/<usr>/<pwd>')
def inicio(usr,pwd):
	if (not usr or not pwd):
		return "Datos vacios"
	else:
		return 'Hello World! usuario registrado %s %s' % (usr,pwd)

@app.route('/login', methods=('GET','POST'))
def login():
	form=LoginForm()
	error=None
	if request.method == 'GET' and request.args.get('next'):
		session['next'] = request.args.get('next', None)
	if form.validate_on_submit():
		usr=form.username.data
		pwd=form.password.data
		usuario=mongo_objects.find_login_operation(usr)
		if usuario:
			mongo_usr=usuario[0]
			mongo_pwd=usuario[1]
#			if usr == mongo_usr and bcrypt.hashpw((form.password.data).encode('utf-8'), mongo_pwd.encode('utf-8')) == mongo_pwd.encode('utf-8'):
			if usr == mongo_usr and pwd==mongo_pwd:
				session['username'] = usr
				if 'next' in session:
					next= session.get('next')
					session.pop('next')
					return redirect(next)
				else:
					return redirect(url_for('bayes'))
			else:
				error="Incorrect password"
		else:
			error="user invalid try again!"
			#return redirect(url_for('login_wrong'))
	return render_template('/user/login.html',form=form, error=error)



@app.route('/register', methods=['GET','POST'])
def register():
	form=RegisterForm()
	error=None
	if form.validate_on_submit():
		salt=bcrypt.gensalt()                     #Encriptacion password
		fullname=form.fullname.data
		email=form.email.data
		username=form.username.data
		password=form.password.data
#		hashed_password=str(bcrypt.hashpw((form.password.data).encode('utf-8'), salt) )   #Encriptacion password
		USR=User(fullname=fullname,email=email,username=username,password=password)
		USR.save()
		return redirect(url_for('login'))
	else:
		error="Incorrect password / user incorrect"
	return render_template('/user/register.html',form=form, error=error)



@app.route('/bayes')
def bayes():
	return render_template('/app/bayes.html')

"""

@app.route('/list/')
def posts():
	return render_template('list.html')

@app.route('/new/')
@login_required
def new():
	form = ExampleForm()
	return render_template('new.html', form=form)

@app.route('/save/', methods = ['GET','POST'])
@login_required
def save():
	form = ExampleForm()
	if form.validate_on_submit():
		print "salvando os dados:"
		print form.title.data
		print form.content.data
		print form.date.data
		flash('Dados salvos!')
	return render_template('new.html', form=form)

@app.route('/view/<id>/')
def view(id):
	return render_template('view.html')

# === User login methods ===

@app.before_request
def before_request():
    g.user = current_user

@lm.user_loader
def load_user(id):
    return User.query.get(int(id))

@app.route('/login/', methods = ['GET', 'POST'])
def login():
    if g.user is not None and g.user.is_authenticated():
        return redirect(url_for('login'))
    form = LoginForm()
    if form.validate_on_submit():
        login_user(g.user)

    return render_template('login.html', 
        title = 'Sign In',
        form = form)

@app.route('/logout/')
def logout():
    logout_user()
    return redirect(url_for('login'))

"""