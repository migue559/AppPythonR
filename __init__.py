from flask import Flask
from flask_mongoalchemy import MongoAlchemy
from flask import Flask
from flask_bootstrap import Bootstrap
from flask_login import LoginManager
import twitter

consumer_key   ='obq2QrxhOIIZ37NMjLHqYypZG'
consumer_secret='26iqjXmefh9mZDTIqETMcxr039hdSSdMP7TbQylBSiRn9JL0aI'

access_token='94405848-33WhwS8vHl6L0Pk7XqdRrxFDVKiXFDyxVXBxDiVMF'
access_secret='Gr9bsG94HDcsmQ3h8Cc40tj5WWb2GipFCwCJI5JiohUFj'

api_twitter=twitter.Api(consumer_key=consumer_key,
				consumer_secret=consumer_secret,
				access_token_key=access_token,
				access_token_secret=access_secret,
				)


app =Flask(__name__)
app.config.from_object('settings')
db = MongoAlchemy(app)

bs = Bootstrap(app) #flask-bootstrap
lm = LoginManager()
lm.setup_app(app)
lm.login_view = 'login'


from user import views, models
from user_app import views

