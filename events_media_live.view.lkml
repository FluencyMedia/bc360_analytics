view: events_media_live {
  label: "Media Events"

  derived_table: {
    datagroup_trigger: dg_bc360_mx_analytics

    sql:  SELECT
            *
          FROM `bc360-main.mx_analytics.events_media_live`;;
  }

  dimension: advertiser {
    group_label: "Broadcast Details"
    label: "Advertiser"
    type: string
    sql: ${TABLE}.advertiser ;;
  }

  dimension: creative_category {
    group_label: "Creative"
    group_item_label: "Creative Category"
    type: string
    sql: ${TABLE}.creative_category ;;
  }

  dimension: creative_name {
    group_label: "Creative"
    group_item_label: "Creative Package"
    type: string
    sql: ${TABLE}.creative_name ;;
  }

  dimension: isci {
    group_label: "Broadcast Details"
    label: "ISCI"
    type: string
    sql: ${TABLE}.isci ;;
  }

  dimension: length {
    group_label: "Broadcast Details"
    label: "Spot Length"
    type: string
    sql: ${TABLE}.length ;;
  }

  dimension: market {
    group_label: "Broadcast Details"
    label: "Market"
    type: string
    sql: ${TABLE}.market ;;
  }

  dimension: medium {
    group_label: "Broadcast Details"
    label: "Medium"
    type: string
    sql: ${TABLE}.medium ;;
  }

  dimension: minute_index {
    primary_key: yes

    group_item_label: "Timeframes"
    label: "Minute (Index)"
    type: number
    sql: ${TABLE}.minute_index ;;
  }

  dimension: program {
    group_label: "Broadcast Details"
    label: "Program"
    type: string
    sql: IFNULL(${TABLE}.program, "[NO PROGRAM]") ;;
  }

  dimension: station {
    group_label: "Broadcast Details"
    label: "Station"
    type: string
    sql: ${TABLE}.station ;;
  }

  dimension_group: timestamp {
    label: "Air Time"
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

}
