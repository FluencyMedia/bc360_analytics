view: mx_analytics_core_live {
  label: "Analytics"
  sql_table_name: mx_analytics.mx_analytics_core_live ;;

  dimension: minute_index {
    label: "Minute (Index)"
    hidden: yes
    type: number
    sql: ${TABLE}.minute_index ;;
  }


  dimension_group: timestamp {
    hidden: yes
    type: time
    timeframes: [
      raw,
      time,
      date,
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
