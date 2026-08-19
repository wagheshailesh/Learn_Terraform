locals {
  
    # Snowflake Account databases
    Global_Databases_Types = {
        comment = "For every team in the future will have all this databases"
        database_names = toset(["TEST_","UAT_","PROD_"])
    }

    Global_Schemas_Names = {
        comment = "Here Security Admin can add Schemas which they want to add into Snowflake databases"
        schema_names = toset(["FINANACE_SCHEMA","SALES_SCHEMA","LANDING_SCHEMA","ROW_SCHEMA","CURATED_SCHEMA","TRANSFORMATION_SCHEMA","REPORTING_SCHEMA"])
    }

}