variable "DatabaseName" {
    description = "This variable gives the name of the database 'DEV','UAT','PROD'"
    type = string
}
variable "GitAccessToken" {
    description = "This is for storing tokens"
    type = string
    sensitive = true
}
variable "Snowflake_account_name" {
    description = "This is the Snowflake account name"
    type = string
    sensitive = true
}

variable "Snowflake_organisation_name" {
    description = "This is the Snowflake account name"
    type = string
    sensitive = true
}

variable "Snowflake_password_value" {
    description = "This is the Snowflake account name"
    type = string
    sensitive = true
}