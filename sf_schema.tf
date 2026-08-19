locals {
  database_to_schema_Map = {
    for database in local.Global_Databases_Types.database_names : database => [
      for schema in local.Global_Schemas_Names.schema_names : schema
    ]
  }

  #Outputting the database_to_schema_Map in a flattened format for easier consumption
#   database_to_schema_Map = {
#   "TEST_" = ["FINANACE_SCHEMA", "SALES_SCHEMA", "LANDING_SCHEMA", "ROW_SCHEMA", "CURATED_SCHEMA", "TRANSFORMATION_SCHEMA", "REPORTING_SCHEMA"]
#   "UAT_"  = ["FINANACE_SCHEMA", "SALES_SCHEMA", "LANDING_SCHEMA", "ROW_SCHEMA", "CURATED_SCHEMA", "TRANSFORMATION_SCHEMA", "REPORTING_SCHEMA"]
#   "PROD_" = ["FINANACE_SCHEMA", "SALES_SCHEMA", "LANDING_SCHEMA", "ROW_SCHEMA", "CURATED_SCHEMA", "TRANSFORMATION_SCHEMA", "REPORTING_SCHEMA"]
#   }

  Flattened_database_to_schema_pairs = flatten([
    for database, schemas in local.database_to_schema_Map : [
      for schema in schemas : {
        database_key = database
        schema_key   = schema
      }
    ]
  ])
  # Outputting the flattened database_to_schema_pairs in a more readable format
#   Flattened_database_to_schema_pairs = 
# [
#   { database_key = "TEST_", schema_name = "FINANACE_SCHEMA" },
#   { database_key = "TEST_", schema_name = "SALES_SCHEMA" },
#   { database_key = "TEST_", schema_name = "LANDING_SCHEMA" },
#   { database_key = "TEST_", schema_name = "ROW_SCHEMA" },
#   { database_key = "TEST_", schema_name = "CURATED_SCHEMA" },
#   { database_key = "TEST_", schema_name = "TRANSFORMATION_SCHEMA" },
#   { database_key = "TEST_", schema_name = "REPORTING_SCHEMA" },
# ]
  
  db_schema_pairs = {
    for pair in local.Flattened_database_to_schema_pairs : "${pair.database_key}_${pair.schema_key}" => pair
  }
}

resource "time_sleep" "wait_for_databases" {
  depends_on      = [snowflake_database.Global_Databases]
  create_duration = "10s"
}

resource "snowflake_schema" "Global_schemas" {
    provider = snowflake.SYSADMIN
    for_each = local.db_schema_pairs
    name = each.value.schema_key
    database = "${each.value.database_key}CLINIC"
    depends_on = [time_sleep.wait_for_databases] 
}