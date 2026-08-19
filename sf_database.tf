resource "snowflake_database" "Global_Databases" {
  provider = snowflake.SYSADMIN
  for_each = local.Global_Databases_Types.database_names
  name = "${each.value}CLINIC"
  comment = "This will dynamically gets the database names from local variable and creates databases in your snowflake account"
  }