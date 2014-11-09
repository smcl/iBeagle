#!/usr/bin/python

import uinput
import SocketServer
import json
import time
import pybonjour
import os 
import select

class iBeagle(SocketServer.ThreadingTCPServer):
    allow_reuse_address = True

class iBeagleHandler(SocketServer.BaseRequestHandler):
    def handle(self):
        try:
            commands = json.loads(self.request.recv(1024).strip())
            for command in commands:
                try:
                    devName = command["dev"]
                    if (devName == "mouse"):
                        dev = mouse
                       
                    elif (devName == "kb"):
                        dev = kb
                    else:
                        continue

                    event = getattr(uinput, command["event"])
                    value = int(command["value"])
                    if value > 0:
                    	value %= 127
                    else:
                    	value %= -127

                    dev.emit(event, int(value))
                except Exception as e:
                    print e

            # send some 'ok' back
            self.request.send(json.dumps({'success':'1'}))
        except Exception, e:
            print "Exception while receiving message: ", e
            self.request.send(json.dumps({'success':'0'}))


def register_callback(sdRef, flags, errorCode, name, regtype, domain):
    if errorCode == pybonjour.kDNSServiceErr_NoError:
        print 'Registered service:'
        print '  name    =', name
        print '  regtype =', regtype
        print '  domain  =', domain

host, port = "", 0

# setup the tcp server and prepare the uinput devices
server = iBeagle((host, port), iBeagleHandler)
port = server.socket.getsockname()[1]
mouse = uinput.Device([uinput.BTN_LEFT, uinput.BTN_RIGHT, uinput.REL_X, uinput.REL_Y, uinput.REL_WHEEL])
kb = uinput.Device([uinput.KEY_A,uinput.KEY_B,uinput.KEY_C,uinput.KEY_D,uinput.KEY_E,uinput.KEY_F,uinput.KEY_G,uinput.KEY_H,uinput.KEY_I,uinput.KEY_J,uinput.KEY_K,uinput.KEY_L,uinput.KEY_M,uinput.KEY_N,uinput.KEY_O,uinput.KEY_P,uinput.KEY_Q,uinput.KEY_R,uinput.KEY_S,uinput.KEY_T,uinput.KEY_U,uinput.KEY_V,uinput.KEY_W,uinput.KEY_X, uinput.KEY_Y,uinput.KEY_Z, uinput.KEY_ENTER, uinput.KEY_BACKSPACE, uinput.KEY_SPACE, uinput.KEY_LEFTSHIFT])

# now split off into two processes
# parent: serves the iBeagle requests
# child:  advertises the iBeagle service via bonjour 
pid = os.fork()
if pid == 0:  
    server.serve_forever()
else:
    name = os.uname()[1]
    regtype = "_ibeagle._tcp"

    sdRef = pybonjour.DNSServiceRegister(name = name,
                                         regtype = regtype,
                                         port = port,
                                         callBack = register_callback)

    try:
        try:
            while True:
                ready = select.select([sdRef], [], [])
                if sdRef in ready[0]:
                    pybonjour.DNSServiceProcessResult(sdRef)
        except KeyboardInterrupt:
            pass
    finally:
        sdRef.close()
