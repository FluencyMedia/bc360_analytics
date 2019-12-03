view: mx_analytics_core_live {
  label: "GA Analytics"

  derived_table: {
    datagroup_trigger: dg_bc360_mx_analytics

    sql:  SELECT
            ##### DIMENSIONS
            timestamp,
            minute_index,

            ##### MEASURES: Current Minute
            users,
            users_new,
            sessions,
            pageviews
          FROM `bc360-main.mx_analytics.mx_analytics_core_live`;;
  }




  dimension: minute_index {
    label: "Minute (Index)"
    hidden: yes
    type: number
    sql: ${TABLE}.minute_index ;;
  }

  dimension: minute_key {
    label: "Minute (Key)"
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.minute_index ;;
  }

  dimension_group: timestamp {
    hidden: no
    type: time
    timeframes: [
      raw,
      time,
      hour_of_day,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.timestamp ;;
  }

  ##### MEASURES: Users { #####

  measure: users_new {
    label: "# New Users"
    type: number
    value_format_name: decimal_0
    sql: NULLIF(SUM(${TABLE}.users_new),0) ;;
  }

  measure: users {
    label: "# Users"
    type: number
    value_format_name: decimal_0
    sql: NULLIF(SUM(${TABLE}.users),0) ;;
  }

  ##### All Users } #####


  ##### MEASURES: Sessions / Pageviews { #####

  measure: sessions {
    label: "# Sessions"
    type: number
    value_format_name: decimal_0
    sql: NULLIF(SUM(${TABLE}.sessions),0) ;;
  }

  measure: pageviews {
    label: "# Pageview"
    type: number
    value_format_name: decimal_0
    sql: NULLIF(SUM(${TABLE}.pageviews),0) ;;
  }

  ##### Sessions / Pageviews} #####

}
