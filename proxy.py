from __future__ import print_function

import json
import urllib2
import ssl

import time
import datetime

def lambda_handler(event, context):

    #return "time= " + str(time.time()) + " | new time= " + str((datetime.datetime.utcnow() + datetime.timedelta(days=7)))
    out = {}

    out['statusCode'] = 200
    out['body'] = ''

    return out