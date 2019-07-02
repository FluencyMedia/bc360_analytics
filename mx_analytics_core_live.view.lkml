view: mx_analytics_core_live {
  sql_table_name: mx_analytics.mx_analytics_core_live ;;

  dimension: minute_index {
    type: number
    sql: ${TABLE}.minute_index ;;
  }

  dimension: pageviews {
    type: number
    sql: ${TABLE}.pageviews ;;
  }

  dimension: sessions {
    type: number
    sql: ${TABLE}.sessions ;;
  }

  dimension_group: timestamp {
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

  dimension: users {
    type: number
    sql: ${TABLE}.users ;;
  }

  dimension: users_new {
    type: number
    sql: ${TABLE}.users_new ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
