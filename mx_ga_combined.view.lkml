view: mx_ga_combined {
  sql_table_name: `bc360-main.mx_analytics.mx_ga_combined`
    ;;

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: domain {
    type: string
    sql: ${TABLE}.domain ;;
  }

  dimension: page_title {
    type: string
    sql: ${TABLE}.page_title ;;
  }

  dimension: page_url {
    type: string
    sql: ${TABLE}.page_url ;;
  }

  dimension: pageviews {
    type: number
    sql: ${TABLE}.pageviews ;;
  }

  dimension: pageviews_unique {
    type: number
    sql: ${TABLE}.pageviews_unique ;;
  }

  dimension: session_duration {
    type: number
    sql: ${TABLE}.session_duration ;;
  }

  dimension: sessions {
    type: number
    sql: ${TABLE}.sessions ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  dimension: subdir {
    type: string
    sql: ${TABLE}.subdir ;;
  }

  dimension: time_on_page {
    type: number
    sql: ${TABLE}.time_on_page ;;
  }

  dimension: users {
    type: number
    sql: ${TABLE}.users ;;
  }

  dimension: users_new {
    type: number
    sql: ${TABLE}.users_new ;;
  }

  dimension: page_title_orig {
    type: string
    sql: ${TABLE}.page_title_orig ;;
  }

  dimension: page_url_orig {
    type: string
    sql: ${TABLE}.page_url_orig ;;
  }

  dimension: path_1_orig {
    type: string
    sql: ${TABLE}.path_1_orig ;;
  }

  dimension: path_2_orig {
    type: string
    sql: ${TABLE}.path_2_orig ;;
  }

  dimension: path_3 {
    type: string
    sql: ${TABLE}.path_3 ;;
  }

  dimension: path_3_orig {
    type: string
    sql: ${TABLE}.path_3_orig ;;
  }

}
