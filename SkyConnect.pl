import subprocess
import re

mac_list = []  # a unique list of MAC addresses
doi_dict = {}  # a dictionary with MAC as the key and a list of SSIDs as the values

# Run Tshark and collect probe requests for 10 seconds printing the MAC and SSID fields.
# The -n option disables MAC address resolution. AKA this will show the full MAC address
# Using shell=True in this case is safe because we are not relying on external input
subprocess.check_call("sudo tshark -i mon0 -f 'subtype probereq' -a duration:10 -n 2>/dev/null | awk '{print $3,$13;}' | grep -v 'Broadcast' >> tshark-data.txt", shell=True)

for data in open('tshark-data.txt', 'r'):
	regex = re.match('(\w\w:\w\w:\w\w:\w\w:\w\w:\w\w)', data)
	mac_list.append(regex.group(1))

# creating a set from a list will remove duplicates
mac_list = list(set(mac_list))

# go back through captured data and compare each line to the unique set of MAC addresses we created
# if there is a match, extract the SSID that the MAC broadcasted
for data in open('tshark-data.txt', 'r'):
	regex = re.match('(\w\w:\w\w:\w\w:\w\w:\w\w:\w\w)\sSSID=(\w+)', data)
	for mac in mac_list:
		if mac == regex.group(1):
			doi_dict.setdefault(mac, [])
			doi_dict[mac].append(regex.group(2))

# the above block will extract numerous duplicate SSIDS (because the device constantly broadcasts searching for it)
# create a set out of the list to remove duplicates
for mac in mac_list:
	doi_dict[mac] = list(set(doi_dict[mac]))

# print the SSIDs that the individual MACs have broadcasted
for mac in mac_list:
	print "MAC:  ", mac
	for ssid in doi_dict[mac]:
		print "SSID: ", ssid



