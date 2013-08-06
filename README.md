sms24x7rusender.sh
==============

<h3>Description</h3>
A small shell script that allows to send sms thru http://sms24x7.ru/api/ service

MAC OS X partially supported

<h3>How it works</h3>
First call determine and provide a few commands that needs to be executed under necessary privileges
```
sudo touch /var/log/smsnotifier.log
sudo chmod 0776 /var/log/smsnotifier.log
```
And check lock-file permissions
```
sudo mkdir -p /var/lock/smsnotifier/
sudo chmod -R 0776 /var/lock/smsnotifier/
```
After successful setup, the script will try to send messages thru sms24x7.ru service, in case of unsuccessful response it will be writen in log file

<h3>Dependencies</h3>
- curl 7.27.0+
- grep 2.12+

<h3>Example</h3>

Here's an example:
```
$ ./smssend.sh "message" "login" "password" "[phone]"
$ ./smssend.sh "message" "login" "password" "[phone1,phone2,phoneN]"
```

<h3>Setup</h3>
in file sms24x7rusender.sh:3
'theta' is a value in seconds that determine delay between two similar requests
