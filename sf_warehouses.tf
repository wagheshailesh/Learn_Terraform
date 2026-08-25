resource "snowflake_warehouse" "Global_Warehouses" {
    provider = snowflake.SYSADMIN
  for_each = local.Global_warehouse_Names.warehouse_names
  name     = each.value
}