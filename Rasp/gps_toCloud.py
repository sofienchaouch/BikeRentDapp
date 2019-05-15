import time
import requests
import math
import random
import os
import serial 
import string
import pynmea2


TOKEN = ""  # Put your TOKEN here
DEVICE_LABEL = "machine"  # Put your device label here 
#VARIABLE_LABEL_1 = "temperature"  # Put your first variable label here
#VARIABLE_LABEL_2 = "humidity"  # Put your second variable label here
VARIABLE_LABEL_3 = "position"  # Put your second variable label here
port = "/dev/ttyS0"
ser = serial.Serial(port, baudrate=9600, timeout=0.5 )

def build_payload(variable_3):
    # Creates two random values for sending data
   # value_1 = random.randint(-10, 50)
    #value_2 = random.randint(0, 85)

    # Creates a random gps coordinates
    

	dataout = pynmea2.NMEAStreamReader()
	newdata = ser.readline()
	
	#print ("Get Latitude and Longitude")
	#print(newdata)
	#time.sleep(5)
	if newdata[0:6] == '$GPGGA' :
		newmsg = pynmea2.parse(newdata)
		lat = newmsg.latitude
		print(lat)
		lng  = newmsg.longitude
		print(lng)
		payload = {variable_3: {"value": 1, "context": {"lat": lat, "lng": lng}}}
		return payload
		time.sleep(10)
    
    

    


def post_request(payload):
    # Creates the headers for the HTTP requests
    url = "http://industrial.api.ubidots.com"
    url = "{}/api/v1.6/devices/{}".format(url, DEVICE_LABEL)
    headers = {"X-Auth-Token": TOKEN, "Content-Type": "application/json"}

    # Makes the HTTP requests
    status = 400
    attempts = 0
    while status >= 400 and attempts <= 5:
        req = requests.post(url=url, headers=headers, json=payload)
        status = req.status_code
        attempts += 1
        time.sleep(1)

    # Processes results
    if status >= 400:
        print("[ERROR] Could not send data after 5 attempts, please check \
            your token credentials and internet connection")
        return False

    print("[INFO] request made properly, your device is updated")
    return True


def main():
    payload = build_payload(VARIABLE_LABEL_3)

    print("[INFO] Attemping to send data")
    post_request(payload)
    print("[INFO] finished")


if __name__ == '__main__':
    while (True):
        main()
        time.sleep(1)
