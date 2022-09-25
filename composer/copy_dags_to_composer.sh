# Codes to create a service account and add the necessary roles
export PROJECT_ID="project-liveability-demo"
export LOCATION="australia-southeast1"
export KEY_PATH="gs://${PROJECT_ID}/credentials/key.json"

# Takes the value of the cloud composer DAG path to a variable
CC_DAG_PATH=$1

# Sets the project in the shell
gcloud config set project ${PROJECT_ID}

export GOOGLE_APPLICATION_CREDENTIALS=${KEY_PATH}

# Copies all the DAG py files to the DAGs folder.
gsutil cp DAGs/*.py ${CC_DAG_PATH}
