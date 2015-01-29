import matplotlib
import urllib2
import json
from flask import Flask, send_file
from pylab import *
from random import random
app = Flask(__name__)

# TODO: Use the real server with a SOAP API, rather than RESTful.
SDI_server = "http://localhost:5001/"

# TODO: Replace this garbage mock data.
Temperature = [20]
Depth = [0]

@app.route('/')
def hello_world():
    # TODO: Replace this mock data crapping.
    # Call the mock server.

    try:
        print "woo"
        sdi_mock_data = json.loads(urllib2.urlopen(SDI_server + 'fetch').read())
        print sdi_mock_data
        Temperature = sdi_mock_data[0]
        Depth = sdi_mock_data[1]
        print "hoo"
    except urllib2.HTTPError, e:
        print "HTTP error: %d" % e.code
    except urllib2.URLError, e:
        print "Network error: %s" % e.reason.args[1]

    fig = plt.figure()
    ax = fig.add_subplot(111)

    ax.plot(Temperature, Depth, 'go--')
    ax.xaxis.tick_top()

    ax.set_ylabel('depth [ft]')
    ax.set_ylim(max(Depth) * 1.1, 0)
    ax.set_xlim(20, max(Temperature + [100]))
    ax.set_xlabel('Temperature [C]')
    # TODO: This will break horrifyingly bad with concurrent users.
    # TODO: Let's find a way to do this in memory.
    fig.set_size_inches(3,5.1*2)
    plt.tight_layout()
    fig.savefig('foo.png',dpi=100)
    print "sending file"
    return send_file('foo.png', mimetype='image/png')


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=False)