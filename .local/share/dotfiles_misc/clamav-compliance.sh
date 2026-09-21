#!/usr/bin/env bash
#
# Drata Compliance Artifact Collector - Arch Linux Antivirus (ClamAV)
# Outputs structured text (.log) and PDF evidence suitable for Drata uploads.

set -euo pipefail

# Output directory and base filename (~/)
OUTPUT_DIR="${HOME}"
TIMESTAMP="$(date +'%Y-%m-%d_%H-%M-%S')"
BASE_NAME="drata_antivirus_evidence_${TIMESTAMP}"
LOG_FILE="${OUTPUT_DIR}/${BASE_NAME}.log"
PDF_FILE="${OUTPUT_DIR}/${BASE_NAME}.pdf"

# Direct console output to both stdout and the log file
exec > >(tee "${LOG_FILE}") 2>&1

echo "================================================================================"
echo "                   DRATA COMPLIANCE EVIDENCE REPORT                             "
echo "                       CONTROL: ANTIVIRUS (CLAMAV)                              "
echo "================================================================================"
echo "Generated On : $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
echo "Hostname     : $(hostname)"
echo "OS / Kernel  : $(uname -sr)"
echo "System User  : $(whoami)"
echo "================================================================================"
echo ""

echo "--------------------------------------------------------------------------------"
echo "1. ANTIVIRUS PACKAGE INSTALLATION & SERVICE STATUS"
echo "--------------------------------------------------------------------------------"
if systemctl is-active --quiet clamav-freshclam.service; then
    echo "Freshclam Status : ACTIVE (signature updater daemon running)"
else
    echo "Freshclam Status : INACTIVE / WARNING (check systemctl status)"
fi
echo ""
echo "[pacman -Qi clamav]"
if command -v pacman >/dev/null 2>&1; then
    pacman -Qi clamav | grep -E "Name|Version|Install Date|Licenses|Architecture" || true
else
    echo "ERROR: pacman package manager not found!"
fi
echo ""
echo "[systemctl status clamav-freshclam.service clamav-daemon.service]"
systemctl status clamav-freshclam.service clamav-daemon.service --no-pager || true
echo ""

echo "--------------------------------------------------------------------------------"
echo "2. SCHEDULED SCAN TIMER CONFIGURATION & STATUS"
echo "--------------------------------------------------------------------------------"
if systemctl is-active --quiet clamscan.timer; then
    echo "Timer Status: ACTIVE (scheduled scan timer is running)"
else
    echo "Timer Status: INACTIVE / WARNING (check systemctl status clamscan.timer)"
fi
echo ""
echo "[systemctl status clamscan.timer]"
systemctl status clamscan.timer --no-pager || true
echo ""
echo "[systemctl list-timers clamscan.timer]"
systemctl list-timers clamscan.timer --no-pager || true
echo ""

echo "--------------------------------------------------------------------------------"
echo "3. VIRUS DEFINITION DATABASE FRESHNESS"
echo "--------------------------------------------------------------------------------"
echo "[ls -la --time-style=full-iso /var/lib/clamav/]"
if [ -d /var/lib/clamav ]; then
    ls -lh --time-style=full-iso /var/lib/clamav/*.{cvd,cld} 2>/dev/null || echo "No database files found in /var/lib/clamav."
else
    echo "ERROR: /var/lib/clamav directory not found!"
fi
echo ""

echo "--------------------------------------------------------------------------------"
echo "4. RECENT SCAN EXECUTION LOGS (LAST 14 DAYS)"
echo "--------------------------------------------------------------------------------"
echo "[journalctl -u clamscan.service --since '14 days ago']"
journalctl -u clamscan.service --since "14 days ago" --no-pager || echo "No execution logs found within last 14 days."
echo ""

echo "--------------------------------------------------------------------------------"
echo "5. LIVE DETECTION VERIFICATION (EICAR TEST)"
echo "--------------------------------------------------------------------------------"
echo "[echo '<EICAR_STRING>' | clamscan -]"
EICAR_TEST_STRING='X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'
echo "$EICAR_TEST_STRING" | clamscan - 2>&1 || true
echo ""

echo "================================================================================"
echo "END OF REPORT"
echo "================================================================================"

# Close tee logging to finalize LOG_FILE
exec 1>&-
exec 2>&-

# Re-open stdout to terminal for status output
exec 1>/dev/tty 2>&1

# Convert log to PDF (Landscape 1-column 7pt Courier, clean UTF-8 sanitization)
if command -v enscript >/dev/null 2>&1 && command -v ps2pdf >/dev/null 2>&1; then
    sed 's/[●•]/*/g' "${LOG_FILE}" | enscript -q -r -1 -B -f Courier7 -M Letter -o - | ps2pdf - "${PDF_FILE}"
    echo "-> Log generated : ${LOG_FILE}"
    echo "-> PDF generated : ${PDF_FILE}"
else
    echo "-> Log generated : ${LOG_FILE}"
    echo "-> WARNING: 'enscript' or 'ghostscript' missing. PDF creation skipped."
    echo "   To enable PDF conversion, run: sudo pacman -S enscript ghostscript"
fi
