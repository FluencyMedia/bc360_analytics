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

    join: mx_analytics_core_legacy {
      sql_on: ${events_media_live.minute_key} = ${mx_analytics_core_legacy.minute_key} ;;
      relationship: many_to_one
      type:  full_outer
    }
}

  explore: mx_analytics_core_legacy {
    label: "BC360 - GA Metrics [TEST]"

    join: events_media_live {
      sql_on: ${mx_analytics_core_legacy.minute_key} = ${events_media_live.minute_key};;
      relationship: one_to_many
      type:  full_outer
    }
}
