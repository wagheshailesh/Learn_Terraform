variable "DatabaseName" {
  description = "This variable gives the name of the database 'DEV','UAT','PROD'"
  type        = string
}
variable "GitAccessToken" {
  description = "This is for storing tokens"
  type        = string
  sensitive   = true
}
variable "Snowflake_account_name" {
  description = "This is the Snowflake account name"
  type        = string
  sensitive   = true
}
variable "Snowflake_organisation_name" {
  description = "This is the Snowflake account name"
  type        = string
  sensitive   = true
}
variable "Snowflake_password_value" {
  description = "This is the Snowflake account name"
  type        = string
  sensitive   = true
}
variable "Landing_Schema" {
  description = "This schema name for landing layer where file is going to land first"
  type        = string
}
variable "RAW_Schema" {
  description = "This schema name for Raw layer where file is going to land first"
  type        = string
}
variable "Curated_MatrixDental_Schema" {
  description = "This schema name for Curated_MatrixDental_Schema layer where file is going to land first"
  type        = string
}
variable "Curated_MatrixSkin_Schema" {
  description = "This schema name for Curated_MatrixSkin_Schema layer where file is going to land first"
  type        = string
}
variable "Curated_Waghesortho_Schema" {
  description = "This schema name for Curated_Waghesortho_Schema layer where file is going to land first"
  type        = string
}
variable "EDW_Schema" {
  description = "This schema name for EDW_Schema layer where file is going to land first"
  type        = string
}
variable "Semantic_Schema" {
  description = "This schema name for Semantic_Schema layer where file is going to land first"
  type        = string
}
variable "Audit_Schema" {
  description = "This schema name for Audit_Schema layer where file is going to land first"
  type        = string
}
variable "Config_Schema" {
  description = "This schema name for Config_Schema layer where file is going to land first"
  type        = string
}
