#!/usr/bin/python
import argparse, MySQLdb

prod_db_host = "sdi-test.cpdwzct6mxqm.us-west-2.rds.amazonaws.com"

def start_data_service(host = "localhost"):
    db = MySQLdb.connect(host=host,
                         user="sdi",
                         passwd="sdipassword",
                         db="MRDD")

    cur = db.cursor()
    cur.execute("SELECT * FROM Author")

    ret_str = "STUB: Data Service does not actually aggregate data.  Here are the authors in the database:"
    for row in cur.fetchall() :
        ret_str += "\n" + str(row)
    print(ret_str)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='SDI Data Service by Team DJADOM')
    parser.add_argument('-p', '--prod', action="store_true", help='Turn on production (AWS) mode', required=False)
    args = parser.parse_args()

    ## show values ##
    if args.prod:
        start_data_service(prod_db_host)
    else:
        start_data_service()