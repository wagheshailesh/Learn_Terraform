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
  organization_name      = "YGAFZOS" # required if not using profile. Can also be set via SNOWFLAKE_ORGANIZATION_NAME env var
  account_name           = "MI13593" # required if not using profile. Can also be set via SNOWFLAKE_ACCOUNT_NAME env var
  user                   = "SVC_TERRAFORM" # required if not using profile or token. Can also be set via SNOWFLAKE_USER env var
  authenticator          = "SNOWFLAKE_JWT"
  private_key            = file("D:/TERRAFORM PRIVATE KEYS/rsa_key.p8")
  private_key_passphrase = "Sharavi@112023"
}

provider "github" {
  owner = "wagheshailesh"
  token = "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"
}