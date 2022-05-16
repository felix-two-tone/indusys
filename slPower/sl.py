#!/usr/bin/python

import urllib.parse
import urllib.request

# #################################################
# Routine to send the information to the prim
#     submitInformation(url,information)
#
def submitInformation(url,parameters) :
    # Set the parameters to be sent.
    encodedParams =  urllib.parse.urlencode(parameters).encode("utf-8")

    # Post the data.
    req = urllib.request.Request(url)
    net =  urllib.request.urlopen(req,encodedParams);

    # return the result.
    return(net.read());



if __name__ == "__main__":

    # Set the URL manually
    url = 'http://simhost-0c1464d1a148e8c0e.agni.secondlife.io:12046/cap/467f07d2-e2bb-fad8-c41f-2b4eabef02e3';

    # Define the parameters
    parameters = {'circut':'0'}

    # Pass the information along to the prim
    info = submitInformation(url,parameters);
    print(info);
