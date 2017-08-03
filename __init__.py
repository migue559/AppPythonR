from flask import Flask
from flask_mongoalchemy import MongoAlchemy
from flask import Flask
from flask_bootstrap import Bootstrap
from flask_login import LoginManager


app =Flask(__name__)
app.config.from_object('settings')
db = MongoAlchemy(app)

bs = Bootstrap(app) #flask-bootstrap
lm = LoginManager()
lm.setup_app(app)
lm.login_view = 'login'


from user import views, models
