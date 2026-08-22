locals {
  
    # Snowflake Account databases
    Global_Databases_Types = {
        comment = "For every team in the future will have all this databases"
        database_names = toset(["TEST_","UAT_","PROD_"])
    }

    Global_Schemas_Names = {
        comment = "Here Security Admin can add Schemas which they want to add into Snowflake databases"
        schema_names = toset(["LANDING",
        "RAW",
        "CURATED_MATERIXDENTAL","CURATED_MATERIXSKIN","CURATED_WAGHESORTHO","CURATED_CLINIC","CONFIG","AUDIT",
        "EDW","SEMANTIC"])
    }

}