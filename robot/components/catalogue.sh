#!/bin/bash
echo "catalogue automation script"

# set -e # exist the prog if any error ( disabled with # as comment for this prog)

COMPONENT=catalogue # to remove repetion of the name frontend. and also helps not to hardcode the filename

source components/common.sh  # load the file of functions
NODEJS # calling Node JS function


		







		
# 1	So let's switch to the	
# 	roboshop	
# 	user and run the following commands.	





		

		
# **NOTE:** You should see the log saying `connected to MongoDB`, then only your catalogue		
# will work and can fetch the items from MongoDB		
		
# **Ref Log:**		
# {"level":"info","time":1656660782066,"pid":12217,"hostname":"ip-172-31-13-123.ec2.internal","msg":**"MongoDB connected",**"v":1}		
# 1	Now, you would still see	
# 	CATEGORIES	
# 	on the frontend page as empty.	
# 2	That’s because your	
# 	frontend	
# 	doesn't know who the	
# 	CATALOGUE	
# 	is when someone clicks the	
# 	CATEGORIES	
# 	option. So, we need to update the Nginx Reverse Proxy on the frontend. If not, you’d still see the frontend without categories.	
