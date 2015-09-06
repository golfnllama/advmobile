import subprocess
import re

subprocess.Popen(["sudo tshark", "-i mon0 -f 'subtype probereq' -a duration:10 2>/dev/null | grep SSID= | sed -n -e 's/^.*SSID=//p' | tee -a tshark-data.txt"])

for data in open("tshark-data.txt", "r"):
{
	data = data.strip(' \t\n\r')
}
