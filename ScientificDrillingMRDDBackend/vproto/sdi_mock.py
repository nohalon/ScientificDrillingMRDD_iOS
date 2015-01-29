from flask import Flask, make_response
from random import random, uniform
from json import dumps
import notify, bgtimer
app = Flask(__name__)

# TODO: Use the real server with a SOAP API, rather than RESTful.
SDI_server = "http://localhost:5001/mock/"

# TODO: Replace this garbage mock data.
Temperature = [20]
Depth = [0]
GoingUp = False
AlarmThreshold = 100
UpperThreshold = 150
LowerThreshold = 50
LowerBound = 15

ForwardsVelocity = 10 # The maximum possible jump in the current moving direction
BackwardsVelocity = ForwardsVelocity / 4

"Provides the next temperature value"
def next_temp():
    print("calling next_temp()")
    global GoingUp
    change = uniform(BackwardsVelocity, ForwardsVelocity)

    prev_temp = Temperature[-1]
    if GoingUp is True:
        if prev_temp > UpperThreshold:
            GoingUp = False
    else:
        if prev_temp < LowerThreshold:
            GoingUp = True
        change = -change # Going down, so make it more likely to move negatively than positively

    new_val = prev_temp + change
    if new_val < LowerBound:
        return LowerBound
    return prev_temp + change

def add_point():
    global GoingUp
    new_temp = next_temp()

    if GoingUp and Temperature[-1] < AlarmThreshold and new_temp > AlarmThreshold:
        notify.send("Temperature " + str(round(new_temp, 2)) + " exceeded alarm threshold!")

    Temperature.append(new_temp);
    Depth.append(Depth[-1] + 1.5);

@app.route('/fetch')
def mock_fetch():
    #global GoingUp
    #new_temp = next_temp()

    #if GoingUp and Temperature[-1] < AlarmThreshold and new_temp > AlarmThreshold:
    #    notify.send("Temperature " + str(round(new_temp, 2)) + " exceeded alarm threshold!")

    #Temperature.append(new_temp);
    #Depth.append(Depth[-1] + 1.5);
    #add_point()
    return make_response(dumps([Temperature, Depth]));

if __name__ == '__main__':
    rt = bgtimer.RepeatedTimer(1, add_point)
    try:
        app.run(debug=True, port=5001)
    finally:
        rt.stop()
