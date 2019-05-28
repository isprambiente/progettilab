json.DT_RowId               "tr_#{report.id}"
json.id                     report.id
json.code                   report.code
json.issued_at              report.created_at
json.issued_on              report.issued_on
json.type                   report.report_type
json.cancelled_at           report.cancelled_at
json.cancelled_on           report.cancelled_on
json.cancellation_reason    report.cancellation_reason
json.url                    job_report_url(job_id: report.job.id, id: report.id)