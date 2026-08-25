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

    Global_Account_Roles_Names = {
        comment = "This are the super users directly assigned to Snowflake account and they will have all the access of all the Clinic databases of Snowflake account"
        role_names = toset(["SUPER_CLINIC_ADMIN","SUPER_CLINIC_ANALYST","SUPER_CLINIC_ENGINEER"])
    }

    Global_Database_Role_Names = {
        comment = "Here Security Admin can add Roles which they want to add into Snowflake databases"
        database_role_names = toset(["DB_Writer","DB_Reader"])
    }

    Global_warehouse_Names = {
        comment = "Here Security Admin can add Warehouses which they want to add into Snowflake account"
        warehouse_names = toset(["CLINIC_WH"]) #Add more warehouses as per your requirement
    }

    Global_User_Names = {
        comment = "Here Security Admin can add Users which they want to add into Snowflake account"
        user_names = toset(["SHAILESHLEARNING"]) #Add more users as per your requirement
    }

}