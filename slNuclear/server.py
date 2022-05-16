import urllib.parse
import urllib.request
import os
import re
import psycopg2
from dotenv import load_dotenv
load_dotenv()
from flask import Flask,render_template,request
app = Flask(__name__)

#database
conn = psycopg2.connect(
   database="dasrex", user='admin', password='os.getenv("DBPASS")', host='127.0.0.1', port= '5432'
)


@app.route('/')
def index():
  print ('Initilizing')
  parameters = {'1234567890 abcdefghijklmnopqrstuvwxyz':''}
  info = submitInformation(url,parameters);
  print(info.decode('utf-8'));
  return render_template('index.html')




@app.route('/poweron/')
def poweron():
  print ('Power On!')
  parameters = {'circut':'1'}
  info = submitInformation(url,parameters);
  print(info.decode('utf-8'));
  return render_template('index.html')

@app.route('/poweroff/')
def poweroff():
  print ('Power Off!')
  parameters = {'circut':'0'}
  info = submitInformation(url,parameters);
  print(info.decode('utf-8'));
  return render_template('index.html')

@app.route('/rodsup/')
def rodsup():
  print ('Raising Rods!')
  parameters = {'rods':'plus'}
  info = submitInformation(url,parameters);
  print(info.decode('utf-8'));
  return render_template('index.html')

@app.route('/rodsdown/')
def rodsdown():
  print ('Increasing load!')
  parameters = {'rods':'minus'}
  info = submitInformation(url,parameters);
  print(info.decode('utf-8'));
  return render_template('index.html')

@app.route('/fusionmode/')
def fusionmode():
  print ('fusion mode activated!')
  parameters = {'mode':'2'}
  info = submitInformation(url,parameters);
  print(info.decode('utf-8'));
  return render_template('index.html')

@app.route('/disconnect/')
def disconnect():
  print ('system disconnected!')
  parameters = {'mode':'0'}
  info = submitInformation(url,parameters);
  print(info.decode('utf-8'));
  return render_template('index.html')

def submitInformation(url,parameters) :
    # Set the parameters to be sent.
    encodedParams =  urllib.parse.urlencode(parameters).encode("utf-8")

    # Post the data.
    req = urllib.request.Request(url)
    net =  urllib.request.urlopen(req,encodedParams);

    # return the result.
    return(net.read());

@app.route('/listen/',methods = ["POST","GET"])
def listenfordata():
    parameters = {'mode':'2'}
    info = submitInformation(url,parameters);
    output = request.form.to_dict()
    print (info.decode('utf-8'));
    return (Output) # response to your request


@app.route('/cam/',methods = ['POST',"GET"])
def cam():
  print('Displaying Webcam')
  return render_template('index.html',cam = cam)

@app.route('/info/',methods = ['POST',"GET"])
def info():
  print('info Change')
  parameters = {'info':'get'}
  output = request.form.to_dict()
  info = submitInformation(url,parameters);
  return render_template('index.html',info = int(float(info.decode('utf-8'))))

if __name__ == '__main__':
  # Set the URL manually
  url = os.getenv("SLURL")
  # Define the parameters
  parameters = {'circut':'0'}
  # Pass the information along to the prim
  app.run(host="localhost", port=8080, debug=True)

