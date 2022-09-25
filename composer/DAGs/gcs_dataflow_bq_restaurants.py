import datetime

from airflow import models
from airflow.providers.google.cloud.operators.dataflow import DataflowTemplatedJobStartOperator
from airflow.utils.dates import days_ago

from airflow.operators.dummy import  DummyOperator

bucket_path = models.Variable.get("GCS_BUCKET")
project_id = models.Variable.get("PROJECT_ID")
gce_region= models.Variable.get("LOCATION")


default_args = {
    # Tell airflow to start one day ago, so that it runs as soon as you upload it
    "start_date": days_ago(1),
    "dataflow_default_options": {
        "project": project_id,
        # Set to your zone
         "location": gce_region,
        # This is a subfolder for storing temporary files, like the staged pipeline job.
        "tempLocation": bucket_path + "/tmp/",
    },
}

# Define a DAG (directed acyclic graph) of tasks.
# Any task you create within the context manager is automatically added to the
# DAG object.
with models.DAG(
    # The id you will see in the DAG airflow page
    "dag_to_load_restaurants_data",
    default_args=default_args,
    # The interval with which to schedule the DAG
    schedule_interval=datetime.timedelta(days=1),  # Override to match your needs
) as dag:

    read_from_cloudstorage = DummyOperator(
        task_id='read_from_cloudstorage',
        dag=dag
    )

    write_to_bigquery = DummyOperator(
        task_id='write_to_bigquery',
        dag=dag
    )

    """
    gcloud dataflow jobs run JOB_NAME \
    --gcs-location gs://dataflow-templates/VERSION/GCS_Text_to_BigQuery \
    --region REGION_NAME \
    --parameters \
javascriptTextTransformFunctionName=JAVASCRIPT_FUNCTION,\
JSONPath=PATH_TO_BIGQUERY_SCHEMA_JSON,\
javascriptTextTransformGcsPath=PATH_TO_JAVASCRIPT_UDF_FILE,\
inputFilePattern=PATH_TO_TEXT_DATA,\
outputTable=BIGQUERY_TABLE,\
bigQueryLoadingTemporaryDirectory=PATH_TO_TEMP_DIR_ON_GCS
    
    """

    run_dataflow_pipeline = DataflowTemplatedJobStartOperator(
        # The task id of your job
        task_id="dataflow_restaurants_data",
        # https://cloud.google.com/dataflow/docs/guides/templates/provided-batch#gcstexttobigquery
        template="gs://dataflow-templates/latest/GCS_Text_to_BigQuery",
        location=gce_region,
        # Use the link above to specify the correct parameters for your template.
        parameters={
            "javascriptTextTransformFunctionName":"transform",
            "JSONPath": bucket_path + "/data/comp_schema/restaurants_schema.json",
            "javascriptTextTransformGcsPath": bucket_path + "/data/comp_schema/restaurants_transform.js",
            "inputFilePattern": bucket_path + "/data/batch_data/restaurants.csv",
            "outputTable": project_id + ":liveability.restaurants",
            "bigQueryLoadingTemporaryDirectory": bucket_path + "/tmp/",
        },
        dag=dag
    )

    read_from_cloudstorage >> run_dataflow_pipeline >> write_to_bigquery
    
  
