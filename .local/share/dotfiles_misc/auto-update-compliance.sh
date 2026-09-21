#!/usr/bin/env bash
#
# Drata Compliance Artifact Collector - Arch Linux Automatic Updates
# Outputs structured text (.log) and PDF evidence suitable for Drata uploads.

set -euo pipefail

# Output directory and base filename (~/)
OUTPUT_DIR="${HOME}"
TIMESTAMP="$(date +'%Y-%m-%d_%H-%M-%S')"
BASE_NAME="drata_automatic_updates_evidence_${TIMESTAMP}"
LOG_FILE="${OUTPUT_DIR}/${BASE_NAME}.log"
PDF_FILE="${OUTPUT_DIR}/${BASE_NAME}.pdf"

# Direct console output to both stdout and the log file
exec > >(tee "${LOG_FILE}") 2>&1

echo "================================================================================"
echo "                   DRATA COMPLIANCE EVIDENCE REPORT                             "
echo "                     CONTROL: AUTOMATIC UPDATES                                 "
echo "================================================================================"
echo "Generated On : $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
echo "Hostname     : $(hostname)"
echo "OS / Kernel  : $(uname -sr)"
echo "System User  : $(whoami)"
echo "================================================================================"
echo ""

echo "--------------------------------------------------------------------------------"
echo "1. AUTOMATIC UPDATE TIMER STATUS & SCHEDULE"
echo "--------------------------------------------------------------------------------"
if systemctl is-active --quiet auto-update.timer; then
    echo "Status: ACTIVE (timer is running)"
else
    echo "Status: INACTIVE / WARNING (check systemctl status)"
fi
echo ""
echo "[systemctl status auto-update.timer]"
systemctl status auto-update.timer --no-pager || true
echo ""
echo "[systemctl list-timers auto-update.timer]"
systemctl list-timers auto-update.timer --no-pager || true
echo ""

echo "--------------------------------------------------------------------------------"
echo "2. AUTOMATIC UPDATE SERVICE CONFIGURATION"
echo "--------------------------------------------------------------------------------"
echo "[Cat /etc/systemd/system/auto-update.service]"
if [ -f /etc/systemd/system/auto-update.service ]; then
    cat /etc/systemd/system/auto-update.service
else
    echo "ERROR: /etc/systemd/system/auto-update.service not found!"
fi
echo ""

echo "--------------------------------------------------------------------------------"
echo "3. RECENT SERVICE EXECUTION LOGS (LAST 14 DAYS)"
echo "--------------------------------------------------------------------------------"
echo "[journalctl -u auto-update.service --since '14 days ago']"
journalctl -u auto-update.service --since "14 days ago" --no-pager || echo "No execution logs found within last 14 days."
echo ""

echo "--------------------------------------------------------------------------------"
echo "4. PACMAN SYSTEM UPDATE LOGS (LAST 25 LINES)"
echo "--------------------------------------------------------------------------------"
echo "[tail -n 25 /var/log/pacman.log]"
if [ -f /var/log/pacman.log ]; then
    tail -n 25 /var/log/pacman.log
else
    echo "ERROR: /var/log/pacman.log not readable!"
fi
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
