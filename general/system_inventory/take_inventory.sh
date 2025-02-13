#!/bin/bash

# Generate a random 10-digit serial number
SERIAL_NUMBER=$((RANDOM * 10000000000))
SERIAL_NUMBER=$(printf %010d "$SERIAL_NUMBER")

# Get timestamps
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
CSV_TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Log and CSV file names
LOG_FILE="${SERIAL_NUMBER}_${TIMESTAMP}.log"
CSV_FILE="system_info2.csv"

# Function to log messages
log_message() {
    echo "$@" &>> "$LOG_FILE"
}

# Data collection functions
get_cpu_info() {
    # Basic info
    local cpu_model=$(cat /proc/cpuinfo | grep "model name" | uniq | awk -F: '{print $2}' | xargs)
    local cpu_count=$(nproc --all)
    echo "$cpu_model,$cpu_count"

    # Detailed info
    log_message "CPU Information:"
    cat /proc/cpuinfo | grep "model name" | uniq &>> "$LOG_FILE"
    nproc --all &>> "$LOG_FILE"
    log_message ""
}

get_memory_info() {
    local ram_volume=$(free -h | grep Mem | awk '{print $2}')
    log_message "Memory Information:"
    sudo dmidecode -t memory | grep -E "Size:|Type:|Speed:" &>> "$LOG_FILE"
    free -h &>> "$LOG_FILE"
    log_message ""
    echo "$ram_volume"
}

get_storage_info() {
    local num_disks=$(lsblk -d | wc -l)
    num_disks=$((num_disks - 1)) #subtract header line
    local total_storage=$(lsblk -b | awk '{sum+=$4} END {printf "%.2f", sum/1024/1024/1024}') # Total in GB, formatted to 2 decimals
    log_message "Storage Information:"
    lsblk -b &>> "$LOG_FILE"
    sudo fdisk -l &>> "$LOG_FILE"
    log_message ""
    echo "$num_disks,$total_storage"
}

get_pci_info() {
    local gpu_model=$(lspci -vnn | grep VGA | awk -F: '{print $3}' | head -n 1 | xargs)
    local num_gpus=$(lspci -vnn | grep VGA | wc -l)
    log_message "PCI Devices:"
    lspci -vnn &>> "$LOG_FILE"
    log_message ""
    echo "$gpu_model,$num_gpus"
}

check_ipmi() {
    local ipmi_status="No"
    log_message "IPMI Check:"
    if command -v ipmitool &> /dev/null; then
        log_message "ipmitool is installed. Checking IPMI functionality..."
        if ipmitool lan print > /dev/null 2>&1; then
            log_message "IPMI appears to be functional."
            ipmitool lan print &>> "$LOG_FILE"
            ipmi_status="Yes"
        else
            log_message "IPMI is present but not responding. Check BMC configuration."
        fi
    else
        log_message "ipmitool is not installed. Cannot check IPMI functionality."
    fi

    log_message ""
    echo "$ipmi_status"
}

# Main Script
log_message "$(date "+%Y-%m-%d %H:%M:%S") - $(hostname)"

# Collect and log data
cpu_data=$(get_cpu_info)
memory_data=$(get_memory_info)
storage_data=$(get_storage_info)
pci_data=$(get_pci_info)
ipmi_data=$(check_ipmi)

# Format for CSV
cpu_model=$(echo "$cpu_data" | cut -d',' -f1)
cpu_count=$(echo "$cpu_data" | cut -d',' -f2)
ram_volume=$(echo "$memory_data")
num_disks=$(echo "$storage_data" | cut -d',' -f1)
total_storage=$(echo "$storage_data" | cut -d',' -f2)
gpu_model=$(echo "$pci_data" | cut -d',' -f1)
num_gpus=$(echo "$pci_data" | cut -d',' -f2)
ipmi_status=$(echo "$ipmi_data")

# CSV output
if [[ ! -f "$CSV_FILE" ]]; then
    echo "serial number,timestamp,hostname,cpu model name,cpu count,available RAM volume,num local storage disks,total local storage volume,GPU model,num GPUs,IPMI present and functional" > "$CSV_FILE"
fi

hostname=$(hostname)
echo "$SERIAL_NUMBER,$CSV_TIMESTAMP,$hostname,$cpu_model,$cpu_count,$ram_volume,$num_disks,$total_storage,$gpu_model,$num_gpus,$ipmi_status" >> "$CSV_FILE"

log_message "Script execution complete."