#!/usr/bin/env bash
#
# Drata Compliance Artifact Collector - Arch Linux Disk Encryption (LUKS / dm-crypt)
# Outputs structured text (.log) and PDF evidence suitable for Drata uploads.

set -euo pipefail

# ------------------------------------------------------------------------------
# 0. ROOT / SUDO ENFORCEMENT CHECK
# ------------------------------------------------------------------------------
if [ "$EUID" -ne 0 ]; then
    echo "================================================================================" >&2
    echo " ERROR: ROOT PRIVILEGES REQUIRED" >&2
    echo "================================================================================" >&2
    echo " Querying device mapper targets, cryptsetup status, and /etc/crypttab" >&2
    echo " requires root access to avoid 'Permission denied' evidence errors." >&2
    echo "" >&2
    echo " Please re-run this script with sudo:" >&2
    echo "   sudo $0" >&2
    echo "================================================================================" >&2
    exit 1
fi

# Determine original invoking user to write output files to their home directory
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"
OUTPUT_DIR="${REAL_HOME}"

TIMESTAMP="$(date +'%Y-%m-%d_%H-%M-%S')"
BASE_NAME="drata_disk_encryption_evidence_${TIMESTAMP}"
LOG_FILE="${OUTPUT_DIR}/${BASE_NAME}.log"
PDF_FILE="${OUTPUT_DIR}/${BASE_NAME}.pdf"

# Direct console output to both stdout and the log file
exec > >(tee "${LOG_FILE}") 2>&1

echo "================================================================================"
echo "                   DRATA COMPLIANCE EVIDENCE REPORT                             "
echo "                      CONTROL: DISK ENCRYPTION (LUKS)                           "
echo "================================================================================"
echo "Generated On : $(date -u +'%Y-%m-%dT%H:%M:%SZ')"
echo "Hostname     : $(hostname)"
echo "OS / Kernel  : $(uname -sr)"
echo "System User  : ${REAL_USER} (via sudo)"
echo "================================================================================"
echo ""

echo "--------------------------------------------------------------------------------"
echo "1. BLOCK DEVICE & FILE SYSTEM ENCRYPTION OVERVIEW"
echo "--------------------------------------------------------------------------------"
if lsblk -f | grep -q "crypto_LUKS"; then
    echo "Disk Encryption Status: DETECTED (crypto_LUKS volumes found)"
else
    echo "Disk Encryption Status: WARNING / UNCHECKED (no crypto_LUKS devices identified)"
fi
echo ""
echo "[lsblk -o NAME,FSTYPE,FSVER,TYPE,SIZE,MOUNTPOINTS]"
lsblk -o NAME,FSTYPE,FSVER,TYPE,SIZE,MOUNTPOINTS || true
echo ""

echo "--------------------------------------------------------------------------------"
echo "2. ACTIVE MAPPED ENCRYPTED VOLUMES (dm-crypt)"
echo "--------------------------------------------------------------------------------"
echo "[dmsetup status --target crypt]"
if command -v dmsetup >/dev/null 2>&1; then
    dmsetup status --target crypt || echo "No active dm-crypt targets found."
else
    echo "ERROR: dmsetup utility not found!"
fi
echo ""

echo "[cryptsetup status for active mapped devices in /dev/mapper/]"
if [ -d /dev/mapper ]; then
    for mapdev in /dev/mapper/*; do
        if [ "$mapdev" = "/dev/mapper/control" ]; then
            continue
        fi
        if [ -b "$mapdev" ]; then
            echo "--- Mapping Status: $mapdev ---"
            cryptsetup status "$mapdev" 2>/dev/null || echo "Could not query $mapdev."
            echo ""
        fi
    done
else
    echo "No mapped devices directory (/dev/mapper) found."
fi
echo ""

echo "--------------------------------------------------------------------------------"
echo "3. ROOT VOLUME & MOUNT POINT ENCRYPTION VERIFICATION"
echo "--------------------------------------------------------------------------------"
ROOT_DEV="$(df -P / | tail -n 1 | awk '{print $1}')"
echo "Root (/) Device Path : ${ROOT_DEV}"
if [[ "${ROOT_DEV}" == /dev/mapper/* ]] || [[ "${ROOT_DEV}" == /dev/dm-* ]]; then
    echo "Root Filesystem Mode : ENCRYPTED (Mounted via Device Mapper)"
else
    echo "Root Filesystem Mode : UNENCRYPTED / DIRECT PARTITION"
fi
echo ""
echo "[df -hT /]"
df -hT / || true
echo ""

echo "--------------------------------------------------------------------------------"
echo "4. CRYPTTAB & FSTAB SYSTEM CONFIGURATION"
echo "--------------------------------------------------------------------------------"
echo "[Cat /etc/crypttab]"
if [ -f /etc/crypttab ]; then
    grep -v '^#' /etc/crypttab | grep -v '^$' || echo "/etc/crypttab exists but contains no active volume entries."
else
    echo "NOTE: /etc/crypttab file not found."
fi
echo ""
echo "[Cat /etc/fstab]"
if [ -f /etc/fstab ]; then
    grep -v '^#' /etc/fstab | grep -v '^$' || echo "/etc/fstab empty or unreadable."
else
    echo "ERROR: /etc/fstab not found!"
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

# Fix file ownership so the log and PDF are owned by the regular user
chown "${REAL_USER}:" "${LOG_FILE}" 2>/dev/null || true

# Convert log to PDF (Landscape 1-column 7pt Courier, clean UTF-8 sanitization)
if command -v enscript >/dev/null 2>&1 && command -v ps2pdf >/dev/null 2>&1; then
    sed 's/[●•]/*/g' "${LOG_FILE}" | enscript -q -r -1 -B -f Courier7 -M Letter -o - | ps2pdf - "${PDF_FILE}"
    chown "${REAL_USER}:" "${PDF_FILE}" 2>/dev/null || true
    echo "-> Log generated : ${LOG_FILE}"
    echo "-> PDF generated : ${PDF_FILE}"
else
    echo "-> Log generated : ${LOG_FILE}"
    echo "-> WARNING: 'enscript' or 'ghostscript' missing. PDF creation skipped."
    echo "   To enable PDF conversion, run: sudo pacman -S enscript ghostscript"
fi
