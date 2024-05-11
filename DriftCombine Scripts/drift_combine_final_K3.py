'''
drift_combine.py 
V.130906
Takes three arguments, first two are the mdoc files, third one
is final filename of the (sorted and joined) tomogram.

Script with the following functions in this particular order:

1.) Take mdoc files and parse tiltangles and single frames filenames
2.) Sort the angles and with it the attached images 
3.) Convert to MRC and build up stack, then flip them along X to have same orientation as in origninal MRCs
4.) Crop stack (if flag is set)
'''

import re
import fileinput
import subprocess
import os
import sys

###
# Change these settings
###

# final squared image size
resize= 0 # set 0 if no resize is wanted
imfilesize=3704

# Adjust path to DriftCorrected folder created by Digital Micrograph Batch align
r1=sys.argv[1]

###
# end of user parameters.
###



# Other regexp
sfile= r"SubFramePath = (?:.+\\)*(.+)$"
chmod_cmd='chmod 770 ' +r1+'*.mrc'


# Collect mdoc files from argument list
files=sys.argv[2:-1]
end_file=sys.argv[-1]

print "Use following mdoc files:", files
print "Combine all series into this file:", end_file


## Loop over each file
list_mix=[] # List of all angles and files

for mdoc in files:
	mdoc= str(mdoc)
	# normally not needed to change.
	stilt= r"TiltAngle = (-?[0-9]*\.?[0-9]+)"
	file_open= open(mdoc,'r')


	endfile = str(end_file) #use as basename for rawtlt as well

	# Get files and angles from the mdoc files
	# Write them in different files



	filelist = open(endfile+'_filelist_bothsides.txt','w+')



	for line in file_open.readlines():
	  tiltline = re.match(stilt, line)
	  if tiltline:
		print 'Tilt:', tiltline.group(1)
		list_mix.append(tiltline.group(1))
	  fileline = re.match(sfile, line)
	  if fileline:
		print 'File:', fileline.group(1)
		list_mix.append(fileline.group(1).rstrip())


print list_mix

# Sort by angle

diction_im={} # Dictionary for sorting 
temp=iter(list_mix)
diction_im=dict(zip(temp,temp)) #

tiltfile = open(endfile[:-3]+'.rawtlt','w+')
filelist = open(endfile+'_filelist.txt','w+')

for key in sorted (diction_im.iterkeys(), key=float):
  print "%s %s" %(key,diction_im[key])
  tiltfile.write(key) 
  tiltfile.write('\r\n')
  filelist.write(diction_im[key])
  filelist.write('\r\n')
tiltfile.close()
filelist.close()


cmd1="tr -d '\015' <"+endfile[:-3]+".rawtlt >"+endfile[:-3]+"_t.rawtlt"
cmd2="mv "+endfile[:-3]+"_t.rawtlt "+endfile[:-3]+".rawtlt"
os.system(cmd1)
os.system(cmd2)


# Read filelist and replace with the drift corrected files.
filelist = open(endfile+'_filelist.txt','r')
driftlist = open(endfile+'_filelist_drift.txt','w+')

# Search and replace 
s1= r"^"


for line in filelist.readlines():
  driftlist.write(re.sub(s1,r1, line))

filelist.close()
driftlist.close()


# Convert to MRCs (could be made better...like the whole program.)
#driftlist = open(endfile+'_filelist_drift.txt','r')
#for filename in driftlist.readlines():
#  filenamedm4= filename[:-6]+'.dm4'
#  filenamemrc= filename[:-6]+'.mrc'
#  print filenamedm4, filenamemrc
#  subprocess.call(["dm2mrc", filenamedm4, filenamemrc])

#driftlist.close()  
#print 'DM4 conversion done.'


# Build up new stack .st file

driftlist = open(endfile+'_filelist_drift.txt','r')

os.system(chmod_cmd.replace(' ', '\ '))
# for fi in os.listdir(r1):
# 	fix_file = os.path.join(r1, fi)
# 	print "Fixing permissions for %s" %(fix_file)
# 	os.chmod(fix_file, 770)
cmd3="tr -d '\015' <"+endfile+"_filelist_drift.txt >"+endfile+"_filelist_drift_t.txt"
cmd4="mv "+endfile+"_filelist_drift_t.txt "+endfile+"_filelist_drift.txt"
os.system(cmd3)
os.system(cmd4)

cmd5="cat -v " +endfile+"_filelist_drift.txt"
os.system(cmd5)

driftlist = open(endfile+'_filelist_drift.txt','r')
command = ''
nextround=0
for i in driftlist.readlines():
  i=i.replace(' ', '\ ')
  if nextround:
    command= command + str(i) + " "
  if not nextround:
    command="newstack " + str(i) + " "
    nextround=1

print 'Running command:\n'
print 'After:'
print command
print '\n'

# Cut accordingly to specific size
if resize:
  command=command + " -size" + ' ' + str(imfilesize) + ',' + str(imfilesize)+ ' ' + endfile
if not resize:
  command=command + ' ' + endfile
command= command.replace('\n', '')
os.system(command)
print 'Stack written.'

# Flip volume correctly

#cmd6='clip flipx ' + endfile + " " + endfile + '_temp'
#cmd7= 'mv ' +endfile + '_temp '  + endfile
#os.system(cmd6)
#os.system(cmd7)

#subprocess.call(["newstack", "$(<" +endfile+"_filelist_bothsides_drift.txt)", "000total.mrc"])


