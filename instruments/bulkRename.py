#!/usr/bin/python

import os
import os.path
import shutil

prefix = "flute"
postfix = "a"
namesfile = "names.csv"

fd = open( namesfile )

if (os.path.exists("out")):
	shutil.rmtree("out")

os.mkdir("out")

#skip first line
fd.readline()
content = fd.readline()
while (content != "" ):
	content.replace( "\n", "" )
	# process content
	params = content.split(";")

	#checkfile
	outNum = int(params[1].strip('"').strip('T'))
	
	for i in range(3):
	
	    tmp = params[i+3].strip('"').strip('*')
	    if (tmp):
		    inName = tmp + ".png"
		    if (os.path.exists(inName)) :
			outName = "out/{0}{1}{2}.png".format(prefix, outNum, ['a','b','c'][i])
			print inName + " --> " + outName
			shutil.copy(inName, outName)
		    
	

	content = fd.readline()



