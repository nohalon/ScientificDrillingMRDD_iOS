from flask import Flask, make_response, request
from random import random
from json import dumps
import datetime
import suds
app = Flask(__name__)

# TODO: Replace with something that isn't this trivial.
soap_server = 'http://localhost:49467/WebService1.asmx?wsdl'

Wells_Words = ["Texas", "California", "Oily", "Drilling", "Pikachu", "JP Tu", "Delicious", "Tasty", "Taco", "Words"]

Wells = []
_default_curves = ["Time", "Depth", "Temperature"]

def GenerateWells():
    for _ in xrange(0, 20):
        new_well = Wells_Words[int(random() * len(Wells_Words))] + " " + Wells_Words[int(random() * len(Wells_Words))] 
        Wells.append(new_well)

@app.route('/getWells')
def mock_fetch():
    return make_response(dumps(Wells));

@app.route('/getCurvesForWell')
# Requires a parameter "well"
# Call like "localhost:5000/getCurvesForWell?well=well name here"
def get_curves():
    wellName = request.args.get('well')
    print wellName
    if (wellName in Wells or wellName == "test"):
        return make_response(dumps(_default_curves));
    return make_response(dumps([]))

@app.route('/getCurveValue')
# Requires a parameter "well", "curve"
# Call like "localhost:5000/getCurvesForWell?well=well name here&curve=curve name here"
def get_curve_value():
    wellName = request.args.get('well')
    curveName = request.args.get('curve')
    print wellName
    print curveName
    if (wellName in Wells or wellName == "test") and curveName in _default_curves:
        return make_response(dumps(random() * 100))
    return make_response(dumps("N/A"))


def initializeSuds():
    print "Woot"
    global client
    client = suds.client.Client(soap_server)


if __name__ == '__main__':
    initializeSuds()
    client.set_options(port='DefaultBinding_WellServicesContract')

    test =  client.factory.create('ns0:UTCTime')
    test.Ticks = 500

    print "attempting WSDL call"
    print client.service.GetWells(test)
    print "Done"
    GenerateWells();
    app.run(debug=True, port=5000)
