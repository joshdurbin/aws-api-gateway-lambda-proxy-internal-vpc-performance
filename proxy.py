from __future__ import print_function

import json
import urllib2
import ssl
import os

target_server = os.environ['webserver_internal_ip']

def lambda_handler(event, context):

    print("Got event\n" + json.dumps(event, indent=2))

    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE

    req = urllib2.Request(target_server + event['path'])

    if event['body']:
        req.add_data(event['body'])

    for header in event['headers']:
        req.add_header(header, event['headers'][header])

    out = {}

    try:
        resp = urllib2.urlopen(req, context=ctx)
        out['statusCode'] = resp.getcode()
        out['body'] = resp.read()

    except urllib2.HTTPError as e:

        out['statusCode'] = e.getcode()
        out['body'] = e.read()

    return out