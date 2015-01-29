import urllib, urllib2, json

pushwoosh_api = "https://cp.pushwoosh.com/json/1.3/"
pushwoosh_create = "createMessage"

def send(message="Test Alert", header="SDI MRDD"):

    data = json.dumps({
        "request":{
            "application":"D27B6-775D3",
            "auth":"DjayaoQ63wUnp1fNH6JnZyi3InnqjkJa04QzZqcEba8OzjY3pCmz7Pe3hDwMs66saEhBNRmeMZw752qXVSUJ",
            "notifications":[
                {
                    "send_date":"now",
                    "ignore_user_timezone": True,
                    "content":{
                        "en":message
                    },
                    "data":{
                        "custom": "json data"
                    },
                    "platforms": [3],

                    "android_root_params": {"collapse_key": header},
                    "android_header":header,
                    "android_icon": "icon",
                    "android_custom_icon": "http://example.com/image.png"
                }
            ]
        }
    })

    #print("creating user on server: " + str(username))
    url = pushwoosh_api + pushwoosh_create
    req = urllib2.Request(url, data, {'Content-Type': 'application/json'})
    response = urllib2.urlopen(req)
    the_page = response.read()
    print(the_page)
    response.close()