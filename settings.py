SECRET_KEY='Un cadena bien pinche loca'
MONGOALCHEMY_DATABASE='AppPythonR'
DEBUG=True
BOOTSTRAP_FONTAWESOME = True
CSRF_ENABLED = True


class Config(object):
	"""
Configuration base, for all environments.
	"""
	#DEBUG = False
	#TESTING = False
	#DATABASE_URI = 'sqlite:///application.db'
	#SECRET_KEY = "MINHACHAVESECRETA"

	#Get your reCaptche key on: https://www.google.com/recaptcha/admin/create
	#RECAPTCHA_PUBLIC_KEY = "6LffFNwSAAAAAFcWVy__EnOCsNZcG2fVHFjTBvRP"
	#RECAPTCHA_PRIVATE_KEY = "6LffFNwSAAAAAO7UURCGI7qQ811SOSZlgU69rvv7"

#class ProductionConfig(Config):
#	DATABASE_URI = 'mysql://user@localhost/foo'
#
#class DevelopmentConfig(Config):
#	DEBUG = True

#class TestingConfig(Config):
#	TESTING = True