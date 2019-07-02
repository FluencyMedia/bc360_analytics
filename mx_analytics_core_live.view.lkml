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
            pageviews,

            ##### MEASURES: Over 8-Minute Trailing Window
            SUM(users)     OVER (ORDER BY minute_index ASC RANGE BETWEEN CURRENT ROW AND 7 FOLLOWING) users_post_spot,
            SUM(users_new) OVER (ORDER BY minute_index ASC RANGE BETWEEN CURRENT ROW AND 7 FOLLOWING) users_new_post_spot,
            SUM(sessions)  OVER (ORDER BY minute_index ASC RANGE BETWEEN CURRENT ROW AND 7 FOLLOWING) sessions_post_spot,
            SUM(pageviews) OVER (ORDER BY minute_index ASC RANGE BETWEEN CURRENT ROW AND 7 FOLLOWING) pageviews_post_spot,

            ##### MEASURES: Span two 30-Minute "Collars" Before and After 8-Minute Trailing Window
            ((SUM(users)     OVER (ORDER BY minute_index ASC RANGE BETWEEN 9 FOLLOWING AND 39 FOLLOWING) + SUM(users)     OVER (ORDER BY minute_index ASC RANGE BETWEEN 31 PRECEDING AND 1 PRECEDING))/2) users_collar,
            ((SUM(users_new) OVER (ORDER BY minute_index ASC RANGE BETWEEN 9 FOLLOWING AND 39 FOLLOWING) + SUM(users_new) OVER (ORDER BY minute_index ASC RANGE BETWEEN 31 PRECEDING AND 1 PRECEDING))/2) users_new_collar,
            ((SUM(sessions)  OVER (ORDER BY minute_index ASC RANGE BETWEEN 9 FOLLOWING AND 39 FOLLOWING) + SUM(sessions)  OVER (ORDER BY minute_index ASC RANGE BETWEEN 31 PRECEDING AND 1 PRECEDING))/2) sessions_collar,
            ((SUM(pageviews) OVER (ORDER BY minute_index ASC RANGE BETWEEN 9 FOLLOWING AND 39 FOLLOWING) + SUM(pageviews) OVER (ORDER BY minute_index ASC RANGE BETWEEN 31 PRECEDING AND 1 PRECEDING))/2) pageviews_collar
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

  measure: users_new {
    label: "# New Users"
    type: number
    value_format_name: decimal_0
    sql: NULLIF(AVG(${TABLE}.users_new),0) ;;
  }

  measure: users_new_post_spot_total {
    label: "# New Users [POST]"
    type: number
    value_format_name: decimal_0
    sql: NULLIF(SUM(${TABLE}.users_new_post_spot),0) ;;
    }

  measure: users_new_collar_total {
    label: "# New Users [COLLAR]"
    type: number
    value_format_name: decimal_0
    sql: NULLIF(SUM(${TABLE}.users_new_collar),0) ;;
  }

  measure: users_new_avg_min_post {
    label: "@ New Users/Min [POST]"
    type: number
    value_format_name: decimal_0
    sql: SAFE_DIVIDE(${users_new_post_spot_total},8) ;;
  }

  measure: users_new_avg_min_collar {
    label: "@ New Users/Min [COLLAR]"
    type: number
    value_format_name: decimal_0
    sql: SAFE_DIVIDE(${users_new_collar_total},60) ;;
  }

  measure: users_new_lift {
    label: "+ New Users"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${users_new_avg_min_post} - ${users_new_avg_min_collar}), ${users_new_avg_min_collar}) ;;
  }

}
