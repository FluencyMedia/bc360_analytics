view: mx_analytics_core_legacy {
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
            COUNT(minute_index) OVER (ORDER BY minute_index ASC ROWS BETWEEN CURRENT ROW AND 7 FOLLOWING) minutes_post_spot,

            ##### MEASURES: Span two 30-Minute "Collars" Before and After 8-Minute Trailing Window
            (SUM(users)     OVER (ORDER BY minute_index ASC RANGE BETWEEN 8 FOLLOWING AND 37 FOLLOWING) + SUM(users)     OVER (ORDER BY minute_index ASC RANGE BETWEEN 30 PRECEDING AND 1 PRECEDING)) users_collar,
            (SUM(users_new) OVER (ORDER BY minute_index ASC RANGE BETWEEN 8 FOLLOWING AND 37 FOLLOWING) + SUM(users_new) OVER (ORDER BY minute_index ASC RANGE BETWEEN 30 PRECEDING AND 1 PRECEDING)) users_new_collar,
            (SUM(sessions)  OVER (ORDER BY minute_index ASC RANGE BETWEEN 8 FOLLOWING AND 37 FOLLOWING) + SUM(sessions)  OVER (ORDER BY minute_index ASC RANGE BETWEEN 30 PRECEDING AND 1 PRECEDING)) sessions_collar,
            (SUM(pageviews) OVER (ORDER BY minute_index ASC RANGE BETWEEN 8 FOLLOWING AND 37 FOLLOWING) + SUM(pageviews) OVER (ORDER BY minute_index ASC RANGE BETWEEN 30 PRECEDING AND 1 PRECEDING)) pageviews_collar,
            (COUNT(minute_index) OVER (ORDER BY minute_index ASC ROWS BETWEEN 8 FOLLOWING AND 37 FOLLOWING) + COUNT(minute_index) OVER (ORDER BY minute_index ASC RANGE BETWEEN 30 PRECEDING AND 1 PRECEDING)) minutes_collar
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

  measure: minutes_post_total {
    label: "Total Minutes [TREATED]"
    type: max
    sql: ${TABLE}.minutes_post_spot ;;
  }

  measure: minutes_collar_total {
    label: "Total Minutes [BASELINE]"
    type: max
    sql: ${TABLE}.minutes_collar ;;
  }

  ##### MEASURES: New Users { #####

  measure: users_new {
    label: "# New Users"
    type: number
    value_format_name: decimal_0
    sql: NULLIF(AVG(${TABLE}.users_new),0) ;;
  }

  measure: users_new_post_spot_total {
    view_label: "Lift Measurements"
    label: "# New Users [TREATED]"
    type: number
    value_format_name: decimal_0
    sql: NULLIF(SUM(${TABLE}.users_new_post_spot),0) ;;
  }

  measure: users_new_collar_total {
    view_label: "Lift Measurements"
    label: "# New Users [BASELINE]"
    type: number
    value_format_name: decimal_0
    sql: NULLIF(SUM(${TABLE}.users_new_collar),0) ;;
  }

  measure: users_new_avg_min_post {
    view_label: "Lift Measurements"
    label: "@ New Users/Min [TREATED]"
    type: number
    value_format_name: decimal_0
    # sql: SAFE_DIVIDE(${users_new_post_spot_total},8) ;;
    sql: SAFE_DIVIDE(${users_new_post_spot_total},${minutes_post_total}) ;;
  }

  measure: users_new_avg_min_collar {
    view_label: "Lift Measurements"
    label: "@ New Users/Min [BASELINE]"
    type: number
    value_format_name: decimal_0
    # sql: SAFE_DIVIDE(${users_new_collar_total},60) ;;
    sql: SAFE_DIVIDE(${users_new_collar_total},${minutes_collar_total}) ;;
  }

  measure: users_new_lift_raw {
    view_label: "Lift Measurements"
    label: "+ New Users: Lift (RAW)"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${users_new_avg_min_post} - ${users_new_avg_min_collar}), ${users_new_avg_min_collar}) ;;
  }

  measure: users_new_lift {
    view_label: "Lift Measurements"
    label: "+ New Users: Lift"
    type: number
    value_format_name: percent_1
    sql: IF(${users_new_lift_raw}>0, ${users_new_lift_raw}, NULL);;
  }

  ##### New Users } #####

  ##### MEASURES: All Users { #####

  measure: users {
    label: "# Users"
    type: number
    value_format_name: decimal_0
    sql: NULLIF(AVG(${TABLE}.users),0) ;;
  }

  measure: users_post_spot_total {
    view_label: "Lift Measurements"
    label: "# Users [TREATED]"
    type: number
    value_format_name: decimal_0
    sql: NULLIF(SUM(${TABLE}.users_post_spot),0) ;;
  }

  measure: users_collar_total {
    view_label: "Lift Measurements"
    label: "# Users [BASELINE]"
    type: number
    value_format_name: decimal_0
    sql: NULLIF(SUM(${TABLE}.users_collar),0) ;;
  }

  measure: users_avg_min_post {
    view_label: "Lift Measurements"
    label: "@ Users/Min [TREATED]"
    type: number
    value_format_name: decimal_0
    # sql: SAFE_DIVIDE(${users_post_spot_total},8) ;;
    sql: SAFE_DIVIDE(${users_post_spot_total},${minutes_post_total}) ;;
  }

  measure: users_avg_min_collar {
    view_label: "Lift Measurements"
    label: "@ Users/Min [BASELINE]"
    type: number
    value_format_name: decimal_0
    # sql: SAFE_DIVIDE(${users_collar_total},60) ;;
    sql: SAFE_DIVIDE(${users_collar_total},${minutes_collar_total}) ;;
  }

  measure: users_lift_raw {
    view_label: "Lift Measurements"
    label: "+ Users: Lift (RAW)"
    type: number
    value_format_name: percent_1
    sql: SAFE_DIVIDE((${users_avg_min_post} - ${users_avg_min_collar}), ${users_avg_min_collar}) ;;
  }

  measure: users_lift {
    view_label: "Lift Measurements"
    label: "+ Users: Lift"
    type: number
    value_format_name: percent_1
    sql: IF(${users_lift_raw}>0, ${users_lift_raw}, NULL);;
  }

  ##### All Users } #####

}
