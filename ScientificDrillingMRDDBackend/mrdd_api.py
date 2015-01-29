#!/bin/python
from flask import Flask
import argparse, MySQLdb

prod_db_host = "sdi-test.cpdwzct6mxqm.us-west-2.rds.amazonaws.com"
# As selected by the passed in CLI args.  There should be a better way to do this...
global_host = "localhost"

def stub_db_call():
    db = MySQLdb.connect(host=global_host,
                         user="sdi",
                         passwd="sdipassword",
                         db="MRDD")

    cur = db.cursor()
    cur.execute("SELECT * FROM Author")

    ret_str = "STUB: MRDD api does not present useful data yet.  Here are the authors in the database:"
    for row in cur.fetchall() :
        ret_str += "\n" + str(row)
    return ret_str

# Flask app definitions & routes
app = Flask(__name__)

@app.route('/')
def index():
    return stub_db_call()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='SDI Data Service by Team DJADOM')
    parser.add_argument('-p', '--prod', action="store_true", help='Turn on production (AWS) mode', required=False)
    args = parser.parse_args()

    if args.prod:
        global_host = prod_db_host
        app.run(host='0.0.0.0', port=80, debug=True)
    else:
        app.run(host='0.0.0.0', port=8080, debug=True)

def get_all():
    return "UNIMPLEMENTED"