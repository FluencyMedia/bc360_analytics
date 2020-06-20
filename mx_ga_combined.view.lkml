view: mx_ga_combined {
  sql_table_name: `bc360-main.mx_analytics.mx_ga_combined`
    ;;

  label: "GA - Core Insights"

  dimension_group: date {
    label: "Dates"
    hidden: no
    type: time
    timeframes: [
      # raw,
      # date,
      # week,
      month,
      # quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: month {
    hidden: yes
    type: date
    label: "Month"
    sql: ${TABLE}.date ;;
  }

  dimension: domain {
    group_label: "   Page Insights"
    group_item_label: "Domain"
    label: "Path - Domain"
    type: string
    sql: ${TABLE}.domain ;;
  }

  dimension: subdir {
    group_label: "   Page Insights"
    group_item_label: "Subdir"
    label: "Path - Subdir"
    type: string
    case: {
      when: {
        sql: ${TABLE}.subdir LIKE "/health-wellness/%" ;;
        label: "/health-wellness/"
      }
      when: {
        sql: ${TABLE}.subdir LIKE "/location%" ;;
        label: "/locations/"
      }
      when: {
        sql: ${TABLE}.subdir LIKE "/services%" ;;
        label: "/services/"
      }
      when: {
        sql: ${TABLE}.subdir LIKE "/conditions%" ;;
        label: "/conditions/"
      }
      when: {
        sql: ${TABLE}.subdir LIKE "/treatments%" ;;
        label: "/treatments/"
      }
      when: {
        sql: ${TABLE}.subdir LIKE "/patients-families%" ;;
        label: "/patients-families/"
      }
      when: {
        sql: ${TABLE}.subdir LIKE "/about-us%" ;;
        label: "/about-us/"
      }
      when: {
        sql: ${TABLE}.subdir LIKE "/careers%" ;;
        label: "/careers/"
      }
      when: {
        sql: ${TABLE}.subdir LIKE "/giving%" ;;
        label: "/giving/"
      }
      when: {
        sql: ${TABLE}.subdir LIKE "/research%" ;;
        label: "/research/"
      }
      when: {
        sql: ${TABLE}.subdir LIKE "/community%" ;;
        label: "/community/"
      }
      when: {
        sql: ${TABLE}.subdir LIKE "/ppclanding%" ;;
        label: "PPC-Related Pages"
      }
      when: {
        sql: ${TABLE}.subdir LIKE "/ty-%" ;;
        label: "PPC-Related Pages"
      }
      when: {
        sql: ${TABLE}.subdir LIKE "/lp-%" ;;
        label: "PPC-Related Pages"
      }
      else: "Other"
    }
  }

  dimension: is_related {
    group_label: "   Page Insights"
    label: "Related Link?"
    type: string
    case: {
      when: {
        sql: ${page_url_orig} LIKE "%related=%" ;;
        label: "Related"
      }
      else: "Unrelated"
    }
  }

  dimension: is_medical_content {
    group_label: " Content Insights"
    label: "Medical Content?"
    description: "Pages under '/services', '/conditions' and '/treatments/'"
    type: string

    case: {
      when: {
        sql: ${TABLE}.subdir LIKE "/services%" ;;
        label: "Medical Content"
      }
      when: {
        sql: ${TABLE}.subdir LIKE "/conditions%" ;;
        label: "Medical Content"
      }
      when: {
        sql: ${TABLE}.subdir LIKE "/treatments%" ;;
        label: "Medical Content"
      }
      else: "Non-medical Content"
    }

  }

  measure: pageviews_related_content {
    group_label: " Content Insights"
    label: "Pageviews - Related"
    type: sum
    value_format_name: decimal_0

    sql: NULLIF(${TABLE}.pageviews,0) ;;
    filters: [is_related: "Related"]
  }

  measure: pageviews_no_related_content {
    group_label: " Content Insights"
    label: "Pageviews - Unrelated"
    type: sum
    value_format_name: decimal_0

    sql: NULLIF(${TABLE}.pageviews,0) ;;
    filters: [is_related: "Unrelated"]
  }

  measure: share_related_links {
    group_label: " Content Insights"
    label: "Share of Related"
    type: number
    value_format_name: percent_0

    sql: (1.0*${pageviews_related_content})/NULLIF(${pageviews},0) ;;
  }

  dimension: path_3 {
    group_label: "   Page Insights"
    group_item_label: "3rd Level"
    label: "Path - 3rd Level"
    type: string
    sql: ${TABLE}.path_3 ;;
  }

  dimension: page_title {
    group_label: "   Page Insights"
    label: "Page Title"
    type: string
    sql: ${TABLE}.page_title ;;
  }

  dimension: page_url {
    group_label: "   Page Insights"
    label: "Page URL - Full"
    type: string
    sql: ${TABLE}.page_url ;;
  }

  dimension: page_url_short {
    group_label: "   Page Insights"
    label: "Page URL"
    type: string
    sql: REGEXP_REPLACE(REGEXP_REPLACE(${TABLE}.page_url, r"^[a-z,\.]*\/", "/"), r"\/[0-9]*$", "/") ;;
  }

  dimension: source {
    hidden: yes
    type: string
    sql: ${TABLE}.source ;;
  }


  dimension: is_prs {
    group_label: "Provider Insights"
    group_item_label: "PRS?"
    label: "Provider - PRS?"
    type: string

    case: {
      when: {
        sql: REGEXP_CONTAINS(${page_title_orig}, r"\ \-\ Request\ Appointment$") ;;
        label: "PRS"
      }
      else: "Non-PRS"
    }
  }

  dimension: provider_name {
    group_label: "Provider Insights"
    group_item_label: "Name"
    label: "Provider Name"
    type: string
    sql: IF((${page_url_short} LIKE "/provider%") OR (${page_url_short} LIKE "/kyruus%"), SPLIT(${page_title}," - ")[ORDINAL(1)], NULL) ;;
  }

  dimension: provider_location {
    group_label: "Provider Insights"
    group_item_label: "Location"
    label: "Provider Location"
    type: string
    sql: REGEXP_EXTRACT(
            REGEXP_REPLACE(${page_title_orig}, r"\ \-\ Request\ Appointment$", "")
            , r"\ \-\ (.*)\ \-\ .*$") ;;}

  dimension: provider_specialty {
    group_label: "Provider Insights"
    group_item_label: "Specialty"
    label: "Provider Specialty"
    type: string
    sql: REGEXP_EXTRACT(
            REGEXP_REPLACE(${page_title_orig}, r"\ \-\ Request\ Appointment$", "")
            , r"\ \-\ .*\ \-\ (.*)$") ;;
  }



  measure: pageviews {
    group_label: "   Page Insights"
    type: number
    sql: NULLIF(SUM(${TABLE}.pageviews), 0) ;;
  }

  measure: pageviews_unique {
    group_label: "   Page Insights"
    type: number
    sql: NULLIF(SUM(${TABLE}.pageviews_unique), 0) ;;
  }

  measure: session_duration {
    group_label: "   Session Insights"
    type: number
    sql: NULLIF(SUM(${TABLE}.session_duration), 0) ;;
  }

  measure: sessions {
    group_label: "   Session Insights"
    type: number
    sql: NULLIF(SUM(${TABLE}.sessions), 0) ;;
  }

  measure: time_on_page {
    group_label: "  Page Insights"
    type: number
    value_format_name: decimal_1

    sql: NULLIF(SUM(${TABLE}.time_on_page), 0) ;;
  }

  measure: time_on_page_avg {
    group_label: "  Page Insights"
    label: "Avg. Time on Page"
    type: number
    value_format_name: decimal_1
    sql: (1.0*${time_on_page})/NULLIF(${pageviews},0) ;;
  }

  measure: pageviews_per_user {
    group_label: "  Page Insights"
    label: "Avg. Pageviews per User"
    type: number
    value_format_name: decimal_1
    sql: (1.0*${pageviews})/NULLIF(${users},0) ;;
  }

  measure: users {
    group_label: "    User Insights"
    label: "Users"
    type: number
    sql: NULLIF(SUM(${TABLE}.users), 0) ;;
  }

  measure: users_new {
    group_label: "    User Insights"
    label: "Users - New"
    type: number
    sql: NULLIF(SUM(${TABLE}.users_new), 0) ;;
  }

  measure: users_returning {
    group_label: "    User Insights"
    label: "Users - Returning"
    type: number
    sql: ${users}-${users_new} ;;
  }


  dimension: page_title_orig {
    group_label: "Raw Elements"
    hidden: no
    type: string
    sql: ${TABLE}.page_title_orig ;;
  }

  dimension: page_url_orig {
    group_label: "Raw Elements"
    hidden: no
    type: string
    sql: ${TABLE}.page_url_orig ;;
  }

  dimension: path_1_orig {
    group_label: "Raw Elements"
    hidden: yes
    type: string
    sql: ${TABLE}.path_1_orig ;;
  }

  dimension: path_2_orig {
    group_label: "Raw Elements"
    hidden: no
    type: string
    sql: ${TABLE}.path_2_orig ;;
  }

  dimension: path_3_orig {
    group_label: "Raw Elements"
    hidden: yes
    type: string
    sql: ${TABLE}.path_3_orig ;;
  }

}
