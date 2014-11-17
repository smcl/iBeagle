I thought it would be an interesting exercise to use my iPhone as an input device instead of a physical mouse and keyboard. It turns out it's pretty simple, thanks to Tuomas Räsänen's cool python-uinput module together with bonjour for simple device discovery.

The "server" running on the Beagle and the iOS "client" (bad metaphors, sorry) can be retrieved via git:

		$ git clone https://github.com/smcl/iBeagle.git
		$ cd iBeagle

### Preparing your Beaglebone Black ###

First copy the iBeagle.py file to your beagle. 

		$ cd iBeagleServer
		$ scp iBeagle.py root@beaglebone.local: # or whatever the IP is

Next there's a little bit of setup on the BeagleBone Black is required, as a kernel module and a couple of libraries are required

		$ ssh root@beaglebone.local

Load the "uinput" module. this requires libudev, 

		$ modprobe uinput 

The python module for uinput we're using requires udev-systemd, so install via opkg

		$ opkg install udev-systemd
		$ git clone https://github.com/tuomasjjrasanen/python-uinput.git
		$ cd python-uinput && python setup.py install

Ensure avahi-daemon process is up and running

		$ ps ax | grep avahi | grep running

Finally setup pybonjour - bonjour library I used for this. If you're having trouble relating to libdns_sd.so see note [0] at the bottom

		$ pushd /usr/src
		$ wget https://pybonjour.googlecode.com/files/pybonjour-1.1.1.tar.gz
		$ pushd pybonjour-1.1.1
		$ tar -xzf  pybonjour-1.1.1.tar.gz
		$ cd pybonjour-1.1.1
		$ python setup.py install

Finally return to your iBeagleServer directory and run the client

		$ popd && popd
		$ python iBeagle.py


### Preparing the iPhone Client ###

Currently you need to load the application using Xcode, so you'll need an iOS dev account and an iOS device authorised to your account. Open up `iBeagleClient/iBeagleClient.xcodeproj`, and build + run on your hardware.

When the server is running you should see your BeagleBone Black listed on the table when you launch the app. If not then try restarting the server, or waiting a few seconds.


### [0] libudev - if you're having trouble ###

I actually had a bit of trouble with this step initially. libdns_sd.so was missing, so I retrieved the avahi sources and built my own copy. The libdns_sd.so library was missing on my version of Angstrom Linux, so I built and installed it separately (which is slightly hacky, there's probably a more sensible way to achieve this)

		$ wget http://avahi.org/download/avahi-0.6.31.tar.gz
		$ tar -xzf avahi-0.6.31.tar.gz && cd avahi-0.6.31

We need to grab some pre-requisites + set PTHREAD_CFLAGS

		$ export PTHREAD_CFLAGS='-lpthread'
		$ opkg install libssp-dev
		$ opkg install libintltool

And run `configure` so we only build as little as possible to just get the library we want

		$ ./configure --disable-static --disable-mono --disable-monodoc --disable-gtk3 --disable-gtk --disable-qt3 --disable-python --disable-qt4 --disable-core-docs --enable-compat-libdns_sd --disable-tests --with-distro=none
		$ make

Then (*without* running `make install`) we copy libdns_sd.so and libdns_sd.h into /usr/lib and /usr/include respectively

		$ cp ./avahi-compat-libdns_sd/.libs/libdns_sd.so /usr/lib
		$ cp ./avahi-compat-libdns_sd/dns_sd.h /usr/include

In my case it was trying to use libdns_sd.so.1 - so I also created a symlink to libdns_sd.so.1.