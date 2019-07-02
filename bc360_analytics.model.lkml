connection: "bc360_main"

include: "//bc360_admin/bc360_triggers.lkml"
# include: "//bc360_admin/*.view.lkml"
include: "//bc360_clients/*.view.lkml"
include: "//bc360_services/*.view.lkml"
include: "//bc360_campaigns/*.view.lkml"
include: "//bc360_outcomes/*.view.lkml"
# include: "//bc360_users/*.view.lkml"

include: "*.view.lkml"

label: "BC360 - All Clients"

explore: events_media_live {
  label: "BC360 - Media Events"

  join: mx_analytics_core_live {
    sql_on: ${events_media_live.minute_index} = ${mx_analytics_core_live.minute_index} ;;
    relationship: many_to_one
    type:  left_outer
  }
}
