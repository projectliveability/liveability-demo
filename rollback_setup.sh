# Scripts for rolling back the project resources.
export PROJECT_ID="project-liveability-demo"
# Sets the project in the shell
gcloud config set project ${PROJECT_ID}

export LOCATION="australia-southeast1"
export SERVICE_ACCOUNT_ID="sa-project-liveability-demo"

export MYSQL_INSTANCE="liveability-mysql-instance"
export MYSQL_PORT="3306"
export MYSQL_USER="datastream"
export MYSQL_PASS="12345678"


#Parameters for the Datastream Connection Profile generation.
export MYSQL_CONN_PROFILE="liveability-mysql-conprofile"
export GCS_CONN_PROFILE="liveability-gcs-conprofile"
export GCS_DS_PATH_PREFIX="/data/stream_data/"
export DS_PUBSUB_TOPIC="liveability-pubsub-topic"
export DS_PUBSUB_SUBSCRIPTION="liveability-pubsub-subscription"
export DS_DIR_PATH="data/stream_data/"
export DS_DATAFLOW_REPLICATION="liveability-dataflow-replication"

#Parameters for the Datastream creation.
export DS_MYSQL_GCS_NAME="liveability-mysql-to-gcs-stream"
export DS_SOURCE_JSON="mysql_source_user_activities_config.json"
export DS_TARGET_JSON="gcs_destination_user_activities_config.json"



export BQ_DATASET="liveability"

# Cancelling Dataflow job
gcloud dataflow jobs cancel ${DS_DATAFLOW_REPLICATION} --force --region=${LOCATION}

# Rollback the Datastream set up
gcloud datastream streams delete ${DS_MYSQL_GCS_NAME} --location=${LOCATION}
gcloud datastream connection-profiles delete ${GCS_CONN_PROFILE} --location=${LOCATION}
gcloud datastream connection-profiles delete ${MYSQL_CONN_PROFILE} --location=${LOCATION}


# Removes the pubsub topic and subsctiption.
gcloud pubsub subscriptions delete ${DS_PUBSUB_SUBSCRIPTION}
gcloud pubsub topics delete ${DS_PUBSUB_TOPIC}



#Delete BigQuery dataset
bq rm -r -f "liveability

# To remove the service accounts we have.
gcloud iam service-accounts delete ${SERVICE_ACCOUNT_ID}@${PROJECT_ID}.iam.gserviceaccount.com

#Disable APIs 
# dataflow 
gcloud services disable dataflow.googleapis.com --force
gcloud services disable datapipelines.googleapis.com --force 
gcloud services disable cloudscheduler.googleapis.com --force
#firestore
gcloud services disable firestore.googleapis.com --force
#appengine for firestore
gcloud services disable appengine.googleapis.com --force
#cloud sql
gcloud services disable sqladmin.googleapis.com --force 
#datastream
gcloud services disable datastream.googleapis.com --force 
#pubsubapi
gcloud services disable pubsub.googleapis.com --force 
#cloudbuild
gcloud services disable cloudbuild.googleapis.com --force 
#gcloud services disable compute.googleapis.com --force 
#gcloud services disable iam.googleapis.com --force 
#cloud composer
gcloud services disable composer.googleapis.com --force 


#Clean up the GCS bucket and its contents.
gcloud storage rm --recursive "gs://${PROJECT_ID}"


# Delete the cloud sql instance

gcloud sql instances delete ${MYSQL_INSTANCE}




