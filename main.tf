
resource "snowflake_database" "Test_Database" {
  name = "TEST_TF"
}

resource "snowflake_database" "UAT_Database" {
  name = "UAT_TF"
}

resource "github_branch" "GitHub_Prod_Branch" {
  repository = "Learn_Terraform"
  branch     = "Production"
  source_branch = "main"
}