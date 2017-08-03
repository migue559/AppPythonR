# -*- encoding: utf-8 -*-
"""
Python Aplication Template
Licence: GPLv3
"""
from R import db
from R import db
from flask_mongoalchemy import BaseQuery
import datetime


class User(db.Document):
    fullname = db.StringField()
    email = db.StringField()
    username = db.StringField()
    password = db.StringField()

class PostQuery(BaseQuery):

    def filter_by_active(self):
        return self.filter({'live': True})

    def editPost(self):
        #id=float(id_post)
        return self.filter({'id':2})
