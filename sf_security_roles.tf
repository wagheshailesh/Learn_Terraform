
/*
Here we are granting the Global Account Roles to SYSADMIN role 
so that sysadmin can have access to all the databases of Snowflake account 
*/

resource "snowflake_grant_account_role" "global_account_to_systemadmin" {
    depends_on = [snowflake_account_role.Super_clinic_admin, snowflake_account_role.Super_clinic_analyst, snowflake_account_role.Super_clinic_Engineer]
  provider = snowflake.SECURITYADMIN
  for_each = local.Global_Account_Roles_Names.role_names
  role_name = each.value
  parent_role_name = "SYSADMIN"
}

/*
Here we are creating the database roles.
*/

locals {
  database_role_pairs = {
    for database in local.Global_Databases_Types.database_names : database => [
      for role in local.Global_Database_Role_Names.database_role_names : role
    ]
  }

/*
Output:
    TEST_ = ["DB_Writer", "DB_Reader"]
    UAT_  = ["DB_Writer", "DB_Reader"]
    PROD_ = ["DB_Writer", "DB_Reader"]
Now we will flatten the database_role_pairs to create a list of maps for easier consumption.
*/
flattened_database_role_pairs = flatten([
  for database, roles in local.database_role_pairs : [
    for role in roles : {
      database_key = database
      role_key     = role
    }
  ]
])

/*
Output:
[
  { database_key = "TEST_", role_key = "DB_Writer" },
  { database_key = "TEST_", role_key = "DB_Reader" },
  { database_key = "UAT_", role_key = "DB_Writer" },
  { database_key = "UAT_", role_key = "DB_Reader" },
  { database_key = "PROD_", role_key = "DB_Writer" },
  { database_key = "PROD_", role_key = "DB_Reader" }
]
*/
  db_role_pairs = {
    for pair in local.flattened_database_role_pairs : "${pair.database_key}_${pair.role_key}" => pair
  }
/*
output:
{
  "TEST__DB_Writer" = { database_key = "TEST_", role_key = "DB_Writer" }
  "TEST__DB_Reader" = { database_key = "TEST_", role_key = "DB_Reader" }
  "UAT__DB_Writer"  = { database_key = "UAT_", role_key = "DB_Writer" }
  "UAT__DB_Reader"  = { database_key = "UAT_", role_key = "DB_Reader" }
  "PROD__DB_Writer" = { database_key = "PROD_", role_key = "DB_Writer" }
  "PROD__DB_Reader" = { database_key = "PROD_", role_key = "DB_Reader" }
}
*/

    db_write_roles = {
        for key, pair in local.db_role_pairs : key => pair
        if pair.role_key == "DB_Writer"
    }

    db_read_roles = {
        for key, pair in local.db_role_pairs : key => pair
        if pair.role_key == "DB_Reader"
    }


    account_role_user_pairs = {
        for account_role in local.Global_Account_Roles_Names.role_names : account_role => [
            for user in local.Global_User_Names.user_names : user
        ]
        if strcontains(account_role, "CLINIC") #Only grant the SUPER_CLINIC_ADMIN role to the users
    }

/*
output:
{
  "SUPER_CLINIC_ADMIN" = ["SHAILESHLEARNING"]
}
*/

    flattened_account_role_user_pairs = flatten([
        for account_role, users in local.account_role_user_pairs : [
            for user in users : {
                account_role_key = account_role
                user_key         = user
            }
        ]
    ])
/*
Output:
[
  { account_role_key = "SUPER_CLINIC_ADMIN", user_key = "SHAILESHLEARNING" }
]
*/

    account_role_user_pairs_map = {
        for pair in local.flattened_account_role_user_pairs : "${pair.account_role_key}_${pair.user_key}" => pair
    }
}
    
/*
Here we are creating the database roles dynamically based on the local variable "Global_Database_Role_Names" which contains the database role names.
The database roles will be created in the respective databases which are created dynamically based on the local variable "Global_Databases_Types" which contains the database names.
*/
resource "snowflake_database_role" "Global_Database_Roles" {
  provider = snowflake.SYSADMIN
  depends_on = [snowflake_database.Global_Databases]
  for_each = local.db_role_pairs
  name     = "${each.value.database_key}${each.value.role_key}" #Output: TEST_DB_Writer, TEST_DB_Reader, UAT_DB_Writer, UAT_DB_Reader, PROD_DB_Writer, PROD_DB_Reader
  comment  = "This will dynamically gets the database role names from local variable and creates database roles in your snowflake account"
  database = "${each.value.database_key}CLINIC"
}

/*
Here we are granting the database roles to the respective databases and schemas.
*/
resource "snowflake_grant_privileges_to_database_role" "Global_Database_Roles_Grants" {
    depends_on = [snowflake_database_role.Global_Database_Roles, snowflake_schema.Global_schemas]
  provider = snowflake.SYSADMIN
  for_each = local.db_role_pairs
  database_role_name = snowflake_database_role.Global_Database_Roles[each.key].fully_qualified_name
  
 #${each.value.database_key}${each.value.role_key}" #Output: TEST_DB_Writer, TEST_DB_Reader, UAT_DB_Writer, UAT_DB_Reader, PROD_DB_Writer, PROD_DB_Reader
  privileges = ["USAGE"]
  on_database = each.value.database_key == "TEST_" ? "TEST_CLINIC" : each.value.database_key == "UAT_" ? "UAT_CLINIC" :  "PROD_CLINIC"
}


/*
Here we are granting the database roles to thier respective database and schemas.
*/
resource "snowflake_grant_privileges_to_database_role" "Global_Database_Roles_Write_Grants_Schema" {
    depends_on = [snowflake_database_role.Global_Database_Roles, snowflake_schema.Global_schemas]
  provider = snowflake.SYSADMIN
  for_each = local.db_write_roles
  database_role_name = snowflake_database_role.Global_Database_Roles[each.key].fully_qualified_name
  privileges = ["USAGE","CREATE TABLE","CREATE VIEW","CREATE STAGE","CREATE FILE FORMAT","CREATE FUNCTION","CREATE PROCEDURE","CREATE SEQUENCE","CREATE STREAM","CREATE TASK","CREATE PIPE"]
  on_schema {
    all_schemas_in_database = "${each.value.database_key}CLINIC"
   # future_schemas_in_database = each.value.database_key == "TEST_" && each.value.role_key == "DB_Writer" ? "TEST_CLINIC" : each.value.database_key == "UAT_" && each.value.role_key == "DB_Writer" ? "UAT_CLINIC" : each.value.database_key == "PROD_" && each.value.role_key == "DB_Writer" ?  "PROD_CLINIC" : null
  }
}

resource "snowflake_grant_privileges_to_database_role" "Global_Database_Roles_Reader_Grants_Schema" {
    depends_on = [snowflake_database_role.Global_Database_Roles, snowflake_schema.Global_schemas]
  provider = snowflake.SYSADMIN
  for_each = local.db_read_roles
  database_role_name = snowflake_database_role.Global_Database_Roles[each.key].fully_qualified_name
  privileges = ["USAGE"]
  on_schema {
    all_schemas_in_database = "${each.value.database_key}CLINIC"
   # future_schemas_in_database = each.value.database_key == "TEST_" && each.value.role_key == "DB_Reader" ? "TEST_CLINIC" : each.value.database_key == "UAT_" && each.value.role_key == "DB_Reader" ? "UAT_CLINIC" : each.value.database_key == "PROD_" && each.value.role_key == "DB_Reader" ?  "PROD_CLINIC" : null
  }
}

/*
Here we are granting ownership of the database roles to the respective databases and schemas.
*/
resource "snowflake_grant_ownership" "Global_Database_Roles_Ownership_Grants_Schema" {
    depends_on = [snowflake_database_role.Global_Database_Roles, snowflake_schema.Global_schemas]
  provider = snowflake.SYSADMIN
  for_each = local.db_write_roles
  database_role_name = snowflake_database_role.Global_Database_Roles[each.key].fully_qualified_name
  on {
    all {
     object_type_plural = "SCHEMAS"
     in_database = each.value.database_key == "TEST_" ? "TEST_CLINIC" : each.value.database_key == "UAT_" ? "UAT_CLINIC" :  "PROD_CLINIC"
    } 
    }
  outbound_privileges = "COPY"
}

/*
Here we are granting account level privileges to account roles.
*/

resource "snowflake_grant_privileges_to_account_role" "Global_Account_Roles_Grants_Admin_Management" {
    depends_on = [snowflake_account_role.Super_clinic_admin]
  provider = snowflake.ACCOUNTADMIN
  account_role_name = "SUPER_CLINIC_ADMIN"
  privileges = ["MANAGE GRANTS","CREATE DATABASE", "CREATE INTEGRATION"]
  on_account = true
}

resource "snowflake_grant_privileges_to_account_role" "Global_Account_Roles_Grants_Engineer" {
    depends_on = [snowflake_account_role.Super_clinic_Engineer]
  provider = snowflake.ACCOUNTADMIN
  account_role_name = "SUPER_CLINIC_ENGINEER"
  privileges = ["CREATE DATABASE", "CREATE INTEGRATION"]
  on_account = true
}

/*
Here we are granting database roles to account roles.
*/
# SUPER_CLINIC_ENGIEER will have writer access and SUPER_CLINIC_ANALYST will have reader access to all the databases of Snowflake account
resource "snowflake_grant_database_role" "Global_Account_Roles_Functional_to_Database_Roles" {
    depends_on = [snowflake_database_role.Global_Database_Roles, snowflake_account_role.Super_clinic_Engineer,snowflake_account_role.Super_clinic_analyst]
  provider = snowflake.SECURITYADMIN
  for_each = local.db_role_pairs
  database_role_name = snowflake_database_role.Global_Database_Roles[each.key].fully_qualified_name
  parent_role_name = each.value.role_key == "DB_Writer" ? "SUPER_CLINIC_ENGINEER" : each.value.role_key == "DB_Reader" ? "SUPER_CLINIC_ANALYST" : null
}

#SUPER_CLINIC_ADMIN will have all the access of all the databases of Snowflake account
resource "snowflake_grant_database_role" "Global_Account_Roles_Admin_to_Database_Roles" {
    depends_on = [snowflake_database_role.Global_Database_Roles]
  provider = snowflake.SECURITYADMIN
  for_each = local.db_role_pairs
  database_role_name = snowflake_database_role.Global_Database_Roles[each.key].fully_qualified_name #Output: TEST_DB_Writer, TEST_DB_Reader, UAT_DB_Writer, UAT_DB_Reader, PROD_DB_Writer, PROD_DB_Reader
  parent_role_name = "SUPER_CLINIC_ADMIN"
}

resource "snowflake_grant_privileges_to_account_role" "Global_Account_Roles_Grants_Warehouse" {
    depends_on = [snowflake_warehouse.Global_Warehouses]
  provider = snowflake.SECURITYADMIN
  for_each = local.Global_Account_Roles_Names.role_names
  account_role_name = each.value
  privileges = ["USAGE","OPERATE"]
  on_account_object {   
    object_type = "WAREHOUSE"
    object_name = "CLINIC_WH"
  }
}

resource "snowflake_grant_account_role" "Global_Account_Roles_to_Users" {
    depends_on = [snowflake_account_role.Super_clinic_admin, snowflake_account_role.Super_clinic_analyst, snowflake_account_role.Super_clinic_Engineer]
  provider = snowflake.SECURITYADMIN
  for_each = local.account_role_user_pairs_map
  role_name = each.value.account_role_key
  user_name = each.value.user_key
}