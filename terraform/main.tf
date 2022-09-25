# CloudSQL MySQL instance creation point-in-time-recovery.
module "gcloud" {
  source  = "terraform-google-modules/gcloud/google"
  version = "3.1.1"
}

variable "gcp_region" {
  type        = string
  description = "Region of Liveability project execution"
  default     = "australia-southeast1"
}

variable "gcp_project" {
  type        = string
  description = "Project to use for this config" 
  default     = "project-liveability-demo"
}

variable "gcp_services_list" {
  description ="The list of APIs necessary for the project"
  type = list(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "dataflow.googleapis.com",
    "datapipelines.googleapis.com",
    "cloudscheduler.googleapis.com",
	"firestore.googleapis.com",
	"appengine.googleapis.com",
    "datastream.googleapis.com",
    "sqladmin.googleapis.com",
    "bigqueryconnection.googleapis.com",
    "pubsub.googleapis.com",
    "cloudbuild.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "composer.googleapis.com"
  ]
}

variable "rolesList" {
  type =list(string)
  default = [
    "roles/iam.serviceAccountAdmin",
    "roles/storage.admin",
    "roles/iam.serviceAccountUser",
    "roles/dataflow.admin",
	"roles/dataflow.worker",
    "roles/bigquery.admin",
    "roles/storage.objectViewer",
    "roles/storage.objectCreator",
    "roles/cloudsql.admin",
    "roles/pubsub.subscriber",
    "roles/pubsub.admin",
    "roles/pubsub.viewer",
    "roles/bigquery.jobUser",
    "roles/cloudbuild.builds.editor",
    "roles/cloudbuild.workerPoolUser",
    "roles/logging.logWriter",
    "roles/workflows.invoker",
    "roles/compute.admin",
    "roles/iam.serviceAccountTokenCreator",
    "roles/composer.worker",
	"roles/datastore.user"
  ]
}

variable "liv_bq_dataset" {
  type = list(object({
    id       = string
    location = string
  }))
}

provider "google" {
  region  = var.gcp_region
  project = var.gcp_project
}

# Creates the Cloud Storage Bucket.
resource "google_storage_bucket" "storage_bucket" {
  name          = var.gcp_project
  location      = var.gcp_region
  project       = var.gcp_project
  force_destroy = true
}

# Enables the Google Services for the Liveability project.
resource "google_project_service" "gcp_services" {
  for_each  = toset(var.gcp_services_list)
  project   = var.gcp_project
  service   = each.key
}

# Creates the service account for the project execution
resource "google_service_account" "service_account" {
  account_id    = "sa-project-liveability-demo"
  display_name  = "Liveability Service Account"
  description   = "Service account for the Liveability project"
  project       = var.gcp_project
}

# Assigns different rols specific to the project
resource "google_project_iam_member" "sa_iam_binding" {
  project = var.gcp_project
  count   = length(var.rolesList)
  role    = var.rolesList[count.index]
  member  = "serviceAccount:${google_service_account.service_account.email}"
  depends_on  = [google_service_account.service_account]
}

# Creates the service account key.
resource "google_service_account_key" "service_account_key" {
  service_account_id  = google_service_account.service_account.name
  public_key_type     = "TYPE_X509_PEM_FILE"
}

# Generates the servce account key and copies it to the path locally.
resource "local_file" "service_account_key" {
    content  = base64decode(google_service_account_key.service_account_key.private_key)
    filename = "../key.json"
}

# Creates new object in the bucket with the proper file.
resource "google_storage_bucket_object" "service_account_key_gcs" {
  name          = "credentials/key.json"
  source        = "../key.json"
  bucket        = "${var.gcp_project}"
  depends_on    = [local_file.service_account_key]
}
 
# Creates the CloudSQL instance with the MySQL as database.
resource "google_sql_database_instance" "instance-mysql" {
  name             = "liveability-mysql-instance"
  region           = var.gcp_region
  database_version = "MYSQL_8_0"
  settings {
    #tier = "db-f1-micro"
    tier = "db-custom-2-7680"
    user_labels = {
      "environment" = "development"
    }
    backup_configuration {
      enabled                        = true
      binary_log_enabled             = true
      start_time                     = "20:55"
      transaction_log_retention_days = "5"
    }
    ip_configuration {
      # [START cloud_sql_postgres_instance_authorized_network]
      authorized_networks {
        name = "AppSheet_01"
        value = "34.71.7.214"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_02"
        value = "34.82.138.241"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_03"
        value = "34.83.247.7"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_04"
        value = "34.86.96.199"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_05"
        value = "34.87.102.230"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_06"
        value = "34.87.103.64"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_07"
        value = "34.87.131.237"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_08"
        value = "34.87.159.166"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_09"
        value = "34.87.233.115"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_10"
        value = "34.91.142.99"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_11"
        value = "34.91.161.74"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_12"
        value = "34.116.117.132"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_13"
        value = "34.123.81.112"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_14"
        value = "34.141.206.242"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_15"
        value = "34.145.159.146"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_16"
        value = "35.189.26.70"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_17"
        value = "35.194.89.186"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_18"
        value = "35.197.185.203"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_19"
        value = "35.203.191.15"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_20"
        value = "35.204.102.20"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_21"
        value = "35.204.159.159"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_22"
        value = "35.204.213.55"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_23"
        value = "35.222.253.144"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_24"
        value = "35.230.32.44"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_25"
        value = "35.232.30.149"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_26"
        value = "35.239.112.17"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_27"
        value = "35.239.203.99"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_28"
        value = "35.240.241.182"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_29"
        value = "35.240.247.148"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_30"
        value = "35.244.107.184"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_31"
        value = "35.244.126.141"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_32"
        value = "35.245.45.144"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_33"
        value = "35.245.209.204"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_34"
        value = "35.245.229.252"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_35"
        value = "35.247.40.210"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "AppSheet_36"
        value = "35.247.56.116"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      # [END cloud_sql_mysql_instance_authorized_network]
      
       # [START cloud_sql_mysql_instance_datastream]
      authorized_networks {
        name = "Datastream_US_Central1_01"
        value = "34.72.28.29"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_Central1_02"
        value = "34.67.234.134"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_Central1_03"
        value = "34.67.6.157"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_Central1_04"
        value = "34.72.239.218"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_Central1_05"
        value = "34.71.242.81"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_West1_01"
        value = "35.247.10.221"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_West1_02"
        value = "35.233.208.195"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_West1_03"
        value = "34.82.253.59"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_West1_04"
        value = "35.247.95.52"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_US_West1_05"
        value = "34.82.254.46"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_AU_SouthEast1_01"
        value = "34.116.127.89"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_AU_SouthEast1_02"
        value = "35.201.23.39"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_AU_SouthEast1_03"
        value = "35.197.161.138"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_AU_SouthEast1_04"
        value = "35.244.113.19"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      authorized_networks {
        name = "Datastream_AU_SouthEast1_05"
        value = "35.201.16.163"
        expiration_time = "3021-11-15T16:19:00.094Z"
      }
      # [END cloud_sql_mysql_instance_datastream]
    }
  }
  deletion_protection = false # set to true to prevent destruction of the resource
}

# Generates the user for CloudSQL database
resource "google_sql_user" "users" {
  name     = "appsheet"
  instance = google_sql_database_instance.instance-mysql.name
  host = "%"
  password = "12345678"
}

# Generates the database in cloud sql
resource "google_sql_database" "database" {
  name     = "db_liveability"
  instance = google_sql_database_instance.instance-mysql.name
}

# Creates the BigQuery dataset.
resource "google_bigquery_dataset" "liv_bq_dataset" {
  project    = var.gcp_project  
  dataset_id = var.liv_bq_dataset["id"]
  location   = var.liv_bq_dataset["location"]

  labels = {
    "environment" = "development"
  }
}
