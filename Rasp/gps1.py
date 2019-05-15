import serial
import pynmea2

#ubidots
# Create an ApiClient object
#api = ApiClient(token="A1E-nKW53X87wrEGf5TGEtZYFCq3yvBxLD")
# Get a Ubidots Variable
#variable_lat = api.get_variable("5cc4cae6c03f971fe2979772")
#variable_lon = api.get_variable("5cc4cae3c03f97201bb7f1c2")
def parseGPS(str):
    if str.find('GGA') > 0:
        msg = pynmea2.parse(str)
        print "Timestamp: %s -- Lat: %s %s -- Lon: %s %s -- Altitude:%s %s" %(msg.timestamp,msg.lat,msg.lat_dir,msg.lon,msg.lon_dir,msg.altitude,msg.altitude_units)

serialPort = serial.Serial("/dev/ttyS0", 9600, timeout=0.5)
while True:
    str = serialPort.readline()
    parseGPS(str)
