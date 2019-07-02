view: mx_analytics_core_live {
  label: "GA Analytics"

  derived_table: {
    datagroup_trigger: dg_bc360_mx_analytics

    sql:  SELECT
            *
          FROM `bc360-main.mx_analytics.mx_analytics_core_live`;;
  }



  dimension: minute_index {
    label: "Minute (Index)"
    hidden: no
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

  measure: users_new {
    label: "# Users (New)"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.users_new ;;
  }

}
