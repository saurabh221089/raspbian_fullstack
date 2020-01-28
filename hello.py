from flask import Flask,render_template
import sys
import Adafruit_DHT

obj = Flask(__name__)
obj.debug = True

@obj.route("/")
def hello():
    return render_template("hello.html",message="This is a development app built in Flask Python Framework!!")

@obj.route("/web")
def web():
    return render_template("web.html",message="Flask App!!")

@obj.route("/temp")
def lab_temp():
	humidity, temperature = Adafruit_DHT.read_retry(Adafruit_DHT.AM2302, 17,retries=3, delay_seconds=1)
	if humidity is not None and temperature is not None:
		return render_template("lab_temp.html",temp=temperature,hum=humidity)
	else:
		return render_template("no_sensor.html")

if __name__ == "__main__":
    obj.run(host='0.0.0.0', port=8080)