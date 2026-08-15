terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "snowflake" {
  alias = "SECURITYADMIN"
  organization_name      = var.Snowflake_organisation_name # required if not using profile. Can also be set via SNOWFLAKE_ORGANIZATION_NAME env var
  account_name           = var.Snowflake_account_name # required if not using profile. Can also be set via SNOWFLAKE_ACCOUNT_NAME env var
  user                   = "SVC_TERRAFORM" # required if not using profile or token. Can also be set via SNOWFLAKE_USER env var
  authenticator          = "SNOWFLAKE_JWT"
  private_key            = file("D:/TERRAFORM PRIVATE KEYS/rsa_key.p8")
  private_key_passphrase = var.Snowflake_password_value
  role = "SECURITYADMIN"
}
provider "snowflake" {
  alias = "SYSADMIN"
  organization_name      = var.Snowflake_organisation_name # required if not using profile. Can also be set via SNOWFLAKE_ORGANIZATION_NAME env var
  account_name           = var.Snowflake_account_name # required if not using profile. Can also be set via SNOWFLAKE_ACCOUNT_NAME env var
  user                   = "SVC_TERRAFORM" # required if not using profile or token. Can also be set via SNOWFLAKE_USER env var
  authenticator          = "SNOWFLAKE_JWT"
  private_key            = file("D:/TERRAFORM PRIVATE KEYS/rsa_key.p8")
  private_key_passphrase = var.Snowflake_password_value
  role = "SYSADMIN"
}
provider "snowflake" {
  alias = "USERADMIN"
  organization_name      = var.Snowflake_organisation_name # required if not using profile. Can also be set via SNOWFLAKE_ORGANIZATION_NAME env var
  account_name           = var.Snowflake_account_name # required if not using profile. Can also be set via SNOWFLAKE_ACCOUNT_NAME env var
  user                   = "SVC_TERRAFORM" # required if not using profile or token. Can also be set via SNOWFLAKE_USER env var
  authenticator          = "SNOWFLAKE_JWT"
  private_key            = file("D:/TERRAFORM PRIVATE KEYS/rsa_key.p8")
  private_key_passphrase = var.Snowflake_password_value
  role = "USERADMIN"
}

provider "github" {
  owner = "wagheshailesh"
  token = var.GitAccessToken
}