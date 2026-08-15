
resource "snowflake_database" "Databases" {
  provider = snowflake.SYSADMIN
  name = var.DatabaseName
}

resource "github_branch" "GitHub_Prod_Branch" {
  repository = "Learn_Terraform"
  branch     = "Production"
  source_branch = "main"
}

resource "snowflake_account_role" "Super_clinic_admin" {
  provider = snowflake.SECURITYADMIN
  name    = "SUPER_CLINIC_ADMIN"
  comment = "THIS role will have all the access of all the databases of Snowflake account"
}

resource "snowflake_account_role" "Super_clinic_analyst" {
  provider = snowflake.SECURITYADMIN
  name    = "SUPER_CLINIC_ANALYST"
  comment = "THIS role will have all the access of all the databases of Snowflake account"
}

resource "snowflake_account_role" "super_clinic_Engineer" {
  provider = snowflake.SECURITYADMIN
  name    = "SUPER_CLINIC_ENGINEER"
  comment = "THIS role will have all the access of all the databases of Snowflake account"
}