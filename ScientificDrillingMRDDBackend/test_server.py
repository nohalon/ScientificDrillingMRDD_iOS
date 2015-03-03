# Requires flask, PyJWT.

from flask import Flask, make_response, request
from random import random
from json import dumps
import jwt
app = Flask(__name__)

# TODO: Replace with something that isn't this trivial.
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
    value = []
    if (curveName == "Depth"):
    	value.append(random() * 99999)
    else:
	value.append(random() * 100)
    if (wellName in Wells or wellName == "test") and curveName in _default_curves:
        return make_response(dumps(value))
    return make_response(dumps("N/A"))

@app.route('/authenticate/', methods=["POST"])
# Requires a parameter "token" with that being the access token in the POST request.
def authenticate():
    token = request.form['token']
    # TODO(dhnishi): Actually return something of value.
    try:
        jwt_decoded = jwt.decode(token, verify=False)
        return make_response(dumps(jwt_decoded['sub']))
    except Exception, e:
        pass

    return make_response(dumps("Failed to parse the jwt access token."), 500)

if __name__ == '__main__':
    GenerateWells();
    app.run(debug=True, port=5000)
