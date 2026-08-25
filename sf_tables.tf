
locals {
  csv_schema_dir = "${path.module}/Schema_Sample"

    table_columns = {
        for file in fileset(local.csv_schema_dir,"*.csv") : 
        trimsuffix(file,".csv") => [
            for col in split(",", trimspace(element(split("\n",file("${local.csv_schema_dir}/${file}")),0))): trimspace(col)
        ]
    }
}

resource "snowflake_table" "landing_tables" {
    provider = snowflake.SYSADMIN
    for_each = local.table_columns
    database = var.DatabaseName
    schema = var.Landing_Schema
    name = upper(each.key)

    dynamic "column" {
      for_each = each.value
      content {
        name = upper(replace(column.value," ","_"))
        type = "VARCHAR"
      }
    }
    column {
        name = "_Loaded_AT"
        type = "TIMESTAMP_NTZ"
    }
    column {
        name = "_SOURCE_FILE"
        type = "VARCHAR"
    }
}
