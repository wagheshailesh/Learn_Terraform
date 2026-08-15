
resource "snowflake_database" "TEST_Database" {
  name = "TEST_CLINIC"
}

resource "snowflake_database" "UAT_Database" {
  name = "UAT_CLINIC"
}

resource "snowflake_database" "PROD_Database" {
  name = "PROD_CLINIC"
}

resource "github_branch" "GitHub_Prod_Branch" {
  repository = "Learn_Terraform"
  branch     = "Production"
  source_branch = "main"
}

resource "snowflake_account_role" "Super_clinic_admin" {
  name    = "SUPER_CLINIC_ADMIN"
  comment = "THIS role will have all the access of all the databases of Snowflake account"
}

resource "snowflake_account_role" "Super_clinic_analyst" {
  name    = "SUPER_CLINIC_ANALYST"
  comment = "THIS role will have all the access of all the databases of Snowflake account"
}

resource "snowflake_account_role" "super_clinic_Engineer" {
  name    = "SUPER_CLINIC_ENGINEER"
  comment = "THIS role will have all the access of all the databases of Snowflake account"
}