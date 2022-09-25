#1.Open cloud shell  and export and set the project

export PROJECT_ID="project-liveability-demo"   
gcloud config set project ${PROJECT_ID}
git clone https://github.com/projectliveabilitydemo/liveability

#2.bash to create service account for cloud build
cd liveability
bash CloudBuild_SvcAccount_Setup.sh

#3.Create a composer

#4.Create trigger for intial setup. Use "initial_account_setup_cloudbuild.yaml"
#5. Create trigger for terraform. "Use terraform-cloudbuild.yaml"
#6.create trigger for tables.Use "ddl_cloudbuild.yaml"
#7.Create trigger for DAG copy
#8.create trigger for datastream. Use "datastream_cloudbuild.yaml"

till here we will be setting up before the demo

In demo
----------
1.Click the trigger for inital setup
2, click the trigger for terraform
3.click the trigger for table creation
4.the trigger for DAg copy
-->For dataflow trigger click on the 4th trigger (RUN) --> then inside enter teh value as gs://<copy the dags path>/  (don't forget to put the / at the end)-->click on RUN trigger
--> clcik on Airflow UI--> admin--> variables-->enter the below one by one
    -->GCS_BUCKET= gs://project-liveability-demo
    -->LOCATION =  australia-southeast1
    -->PROJECT_ID = project-liveability-demo

5. Click the trigger for datastream



Now run dataflow (not able to figure out how to use cloud composer to trigger till now)
--------------------
cd ..
cd liveability
cd dataflow
bash dataflow_run.sh

Then in the already set up project
--------------------
show DBT, datastudio and geoviz
Then show the result in app sheet too


If the git clone asks for username and pwd
-----------------------------------------
Username for github =projectliveabilitydemo
password=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



