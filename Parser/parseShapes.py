# Usage: chewdata.py [input CSV filename] [output JSON filename]
# Must be tab delimited csv files
import csv, sys, json

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

active_routes = [e[0] for e in readcsv("activeroutes.csv")]
source = readcsv("shapes.txt")

i = 0
routes = {}
for r in source:
	if (i > 0):
		if r[0] not in routes: routes[r[0]] = []
		routes[r[0]].insert(int(r[3]), [round(float(r[2]), 4), round(float(r[1]), 4)])
	i += 1

pos = 0
neg = 0
out = {}
for r in routes:
	name = r.split('.')[0]
	if name[-1] == '2': name = name[0:-1] + '1'
	if (name not in active_routes): neg += 1
	else:
		out[name] = routes[r]
		pos += 1
print str(pos) + " were active routes, and " + str(neg) + " inactive routes."

pos = 0
neg = 0
for r in active_routes:
	if (r not in out):
		neg += 1
		print r
	else:
		pos += 1
print "Of the " + str(len(active_routes)) + " routes from active_routes, " + str(pos) + " were found, and " + str(neg) + " were not."



out = json.dumps(out) # Convert to JSON
f = open("shapes.json", "w") # Open output file (argument 3)
f.write(out) # Write
