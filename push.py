#!/usr/bin/env python3
# This script is used to push the pycsep docker image to dockerhub
# User must be logged into dockerhub and have write permissions to sceccode
#

import os
import datetime

# build date tag
#dt=datetime.datetime.today()
#month=dt.month
#day=dt.day
#mdate="%02d%02d"%(month,day)

#cmd = "docker tag pycsep_jup sceccode/pycsep_jup"
#print("Running: ",cmd)
#os.system(cmd)
cmd = "docker push sceccode/pycsep_scec_workshop"
print("Running: ",cmd)
os.system(cmd)
