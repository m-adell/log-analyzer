#!/usr/bin/env bash 
set -euo pipefail

LOG_FILE="${1:-$HOME/projects/log-analyzer/access.log}"
REPORT_LOG=""$HOME"/projects/log-analyzer/report.log"

echo "SERVER ANALISES $(date "+%Y-%m-%d %A")" >> "$REPORT_LOG"

# top IPs accessing
analyze_ip(){
echo "----------------------
Top 10 IPs accessing:" >> "$REPORT_LOG"
echo "Rank   count  ip" >> "$REPORT_LOG"
echo "$(awk '{ print $1 }' "$LOG_FILE" | sort | uniq -c | sort -rn | head | awk '{printf "%-7s%-7s%s\n",NR,$1,$2}' )" >> "$REPORT_LOG"
}
# top requested URLs
analyze_url(){
echo "
Top 10 requested URLs:" >> "$REPORT_LOG"
echo "Rank   Count  URL    " >> "$REPORT_LOG"
echo "$(awk '{ print $6 }' "$LOG_FILE" | sort | uniq -c | sort -rn | head | awk '{printf "%-7s%-7s%s\n",NR,$1,$2}')" >> "$REPORT_LOG"
}
# ERRs
analyze_errs(){
echo "HTTP Response Code: " >> "$REPORT_LOG"
echo "OK [200]        : $(grep -c '200' "$LOG_FILE" |wc -l) " >> "$REPORT_LOG"
echo "Not Found [404] : $(grep -c '404' "$LOG_FILE" |wc -l) " >> "$REPORT_LOG"
echo "Forbidden [403] : $(grep -c '403' "$LOG_FILE" |wc -l) " >> "$REPORT_LOG"
echo "Server Err [500]: $(grep -c '500' "$LOG_FILE" |wc -l) " >> "$REPORT_LOG"
echo "-------------------------------------------">>"$REPORT_LOG"
}

analyze_ip
analyze_url
analyze_errs
