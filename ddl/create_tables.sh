
export PROJECT_ID="project-liveability-demo"
gcloud config set project ${PROJECT_ID}
export LOCATION="australia-southeast1"

#export GOOGLE_APPLICATION_CREDENTIALS=../key.json
#export GOOGLE_APPLICATION_CREDENTIALS= gs://${PROJECT_ID}/json_key/key.json
#gsutil cp gs://${PROJECT_ID}/json_key/key.json .
#export GOOGLE_APPLICATION_CREDENTIALS=key.json
#Sets the keypath
export KEY_PATH="gs://${PROJECT_ID}/credentials/key.json"
export GOOGLE_APPLICATION_CREDENTIALS=${KEY_PATH}

export MYSQL_INSTANCE="liveability-mysql-instance"


#Copy the files to cloud storage
gsutil cp ../data/* gs://${PROJECT_ID}/data/batch_data/
gsutil cp ../ddl/* gs://${PROJECT_ID}/ddl/
gsutil cp ../composer/schema/* gs://${PROJECT_ID}/data/comp_schema/
gsutil cp ../composer/DAGs/* gs://${PROJECT_ID}/composer/DAGs/             # Moving all the composer DAGs files.
gsutil cp key.json gs://${PROJECT_ID}/credentials/key.json


#Datastream user creation replica process and allowing privilleges for the 'datastream' user.
SERVICE_ACCOUNT=$(gcloud sql instances describe ${MYSQL_INSTANCE} | grep serviceAccountEmailAddress | awk '{print $2;}')
gsutil iam ch serviceAccount:$SERVICE_ACCOUNT:objectViewer gs://${PROJECT_ID}
gcloud sql import sql ${MYSQL_INSTANCE} gs://${PROJECT_ID}/ddl/create-ds-user-privileges.sql --quiet

#Create table in mysql
gcloud sql import sql ${MYSQL_INSTANCE} gs://${PROJECT_ID}/ddl/ddl_user_activity.sql --quiet

#create childcare center table
bq mk -t --description "childcare centers"  \liveability.childcarecenters  Name:STRING,Categories:STRING,Address:STRING,City:STRING,State:STRING,Postcode:STRING,Phone:STRING,Fax:STRING,Latitude:STRING,Longitude:STRING,Employees:STRING,Established:STRING,ABN_Status:STRING,ABN:STRING,ABN_Name:STRING,Accuracy:STRING,ABN_2:STRING,ACN:STRING,Created_Date:TIMESTAMP
 
##create hospitals  table
bq mk -t --description "hospitals"  \liveability.hospitals  Name:STRING,Categories:STRING,Address:STRING,City:STRING,State:STRING,Postcode:STRING,Phone:STRING,Fax:STRING,Latitude:STRING,Longitude:STRING,Employees:STRING,Established:STRING,ABN_Status:STRING,ABN:STRING,ABN_Name:STRING,Accuracy:STRING,ABN_2:STRING,ACN:STRING,Created_Date:TIMESTAMP

#create religiousorganizations table
bq mk -t --description "religiousorganizations"  \liveability.religiousorganizations  Category:STRING,Name:STRING,Address:STRING,Suburb:STRING,State:STRING,Postcode:STRING,CombinedAddress:STRING,Latitude:STRING,Longitude:STRING,Fax:STRING,Email:STRING,Website:STRING,Staff:STRING,Established:STRING,ABN:STRING,ABN_Status:STRING,ABN_Type:STRING,ABN_Accuracy:STRING,Created_Date:TIMESTAMP

#create restaurants  table
bq mk -t --description "restaurants"  \liveability.restaurants  Name:STRING,Categories:STRING,Address:STRING,City:STRING,State:STRING,Postcode:STRING,Phone:STRING,Website:STRING,Email:STRING,Fax:STRING,Latitude:STRING,Longitude:STRING,Employees:STRING,Established:STRING,Licence_No:STRING,ABN_Status:STRING,ABN:STRING,ABN_Name:STRING,Accuracy:STRING,ABN_2:STRING,ACN:STRING,Created_Date:TIMESTAMP

#create schools table
bq mk -t --description "schools"  \liveability.schools  Name:STRING,Categories:STRING,Address:STRING,City:STRING,State:STRING,Postcode:STRING,Phone:STRING,Website:STRING,Email:STRING,Fax:STRING,Latitude:STRING,Longitude:STRING,Employees:STRING,Established:STRING,Licence_No:STRING,ABN_Status:STRING,ABN:STRING,ABN_Name:STRING,Accuracy:STRING,ABN_2:STRING,ACN:STRING,Created_Date:TIMESTAMP

#create shoppingcentres table
bq mk -t --description "shoppingcentres"  \liveability.shoppingcentres  Name:STRING,Categories:STRING,Address:STRING,City:STRING,State:STRING,Postcode:STRING,Phone:STRING,Website:STRING,Email:STRING,Fax:STRING,Latitude:STRING,Longitude:STRING,Employees:STRING,Established:STRING,Licence_No:STRING,ABN_Status:STRING,ABN:STRING,ABN_Name:STRING,Accuracy:STRING,ABN_2:STRING,ACN:STRING,Created_Date:TIMESTAMP

#create sportsclubs table
bq mk -t --description "sportsclubs"  \liveability.sportsclubs  Name:STRING,Categories:STRING,Address:STRING,City:STRING,State:STRING,Postcode:STRING,Phone:STRING,Website:STRING,Email:STRING,Fax:STRING,Latitude:STRING,Longitude:STRING,Employees:STRING,Established:STRING,Licence_No:STRING,ABN_Status:STRING,ABN:STRING,ABN_Name:STRING,Accuracy:STRING,ABN_2:STRING,ACN:STRING,Created_Date:TIMESTAMP
