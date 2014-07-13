# Usage: chewdata.py [input CSV filename] [output JSON filename]
# Must be tab delimited csv files
import csv, sys, json
import time, math
from pprint import pprint
from sets import Set

def readcsv(path):
	out = []
	with open(path, 'rb') as csvfile:
		csvdata = csvfile.read()
		try: # UTF-8 is the default
			out = csv.reader(csvdata.decode('utf-8-sig').encode('utf-8').splitlines())
		except UnicodeDecodeError: # Try ISO 8859-15
			out = csv.reader(csvdata.decode('iso8859-15').encode('utf-8').splitlines())
		except:
			print "ERROR: I can't read that file. Check that input file is encoded as UTF-8."
			out = csv.reader(csvdata.decode('utf-8-sig').encode('utf-8').splitlines())
		return out

def writecsv(path, block):
	with open(path, 'wb') as csvfile:
		csvobj = csv.writer(csvfile, delimiter=',', quotechar='"', quoting=csv.QUOTE_NONNUMERIC)
		for row in block:
			csvobj.writerow(row)

with open('routesbytime.json') as data_file:
    data = json.load(data_file)

TICK = 10
i = 0;

routes = Set()
schedule = [[] for x in range(1440 / TICK)]

for row in data:
	routes.add(row['route_id'])
	dep_time = int((time.mktime(time.strptime(row['departure_time'], '%H:%M:%S')) + 2209030200) / 60)
	dur = int((time.mktime(time.strptime(row['duration'], '%H:%M:%S')) + 2209030200) / 60)
	block = int(math.floor(dep_time / TICK))
	schedule[block].append([row['route_id'], dur])

for name in routes:
	print name

out = json.dumps(schedule) # Convert to JSON
f = open("schedule.json", "w") # Open output file (argument 3)
f.write(out) # Write

