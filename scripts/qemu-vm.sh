#!/bin/bash

# QEMU VM Management Script
# Usage: ./vm-manager.sh <iso-or-disk.qcow2> <install|start> [options]

set -e

# Default configuration (can be overridden via environment variables)
DEFAULT_RAM="${VM_RAM:-4096}"
DEFAULT_CPUS="${VM_CPUS:-2}"
DEFAULT_DISK_SIZE="${VM_DISK_SIZE:-20G}"
DEFAULT_SSH_PORT="${VM_SSH_PORT:-2222}"

# Check dependencies
command -v qemu-system-x86_64 >/dev/null || {
    echo "Error: qemu-system-x86_64 not found. Please install QEMU."
    exit 1
}

command -v qemu-img >/dev/null || {
    echo "Error: qemu-img not found. Please install QEMU."
    exit 1
}

# Help function
show_help() {
    cat << EOF
QEMU VM Management Script

Usage: $0 <iso-or-disk.qcow2> <install|start> [options]

Modes:
  install    Install OS from ISO to new disk image
  start      Start existing VM from disk image

Options:
  --ram MB       RAM in MB (default: $DEFAULT_RAM)
  --cpus N       Number of CPUs (default: $DEFAULT_CPUS)
  --disk-size G  Disk size for install mode (default: $DEFAULT_DISK_SIZE)
  --ssh-port P   SSH port forwarding (default: $DEFAULT_SSH_PORT)
  --vnc          Use VNC display instead of SDL
  --headless     Run without display (VNC on :1)
  --help         Show this help

Environment variables:
  VM_RAM         Default RAM in MB
  VM_CPUS        Default CPU count
  VM_DISK_SIZE   Default disk size
  VM_SSH_PORT    Default SSH port

Examples:
  $0 ubuntu-22.04.iso install
  $0 ubuntu-22.04.iso install --ram 8192 --cpus 4
  $0 my-vm-abc123.qcow2 start
  $0 my-vm-abc123.qcow2 start --vnc
EOF
}

# Parse command line arguments
if [[ $# -lt 2 ]]; then
    show_help
    exit 1
fi

INPUT="$1"
MODE="$2"
shift 2

# Initialize variables with defaults
RAM="$DEFAULT_RAM"
CPUS="$DEFAULT_CPUS"
DISK_SIZE="$DEFAULT_DISK_SIZE"
SSH_PORT="$DEFAULT_SSH_PORT"
DISPLAY_TYPE="sdl"
HEADLESS=false

# Parse additional options
while [[ $# -gt 0 ]]; do
    case $1 in
        --ram)
            RAM="$2"
            shift 2
            ;;
        --cpus)
            CPUS="$2"
            shift 2
            ;;
        --disk-size)
            DISK_SIZE="$2"
            shift 2
            ;;
        --ssh-port)
            SSH_PORT="$2"
            shift 2
            ;;
        --vnc)
            DISPLAY_TYPE="vnc"
            shift
            ;;
        --headless)
            HEADLESS=true
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate numeric parameters
if ! [[ "$RAM" =~ ^[0-9]+$ ]] || [[ "$RAM" -lt 512 ]]; then
    echo "Error: RAM must be a number >= 512 MB"
    exit 1
fi

if ! [[ "$CPUS" =~ ^[0-9]+$ ]] || [[ "$CPUS" -lt 1 ]] || [[ "$CPUS" -gt 16 ]]; then
    echo "Error: CPUs must be a number between 1-16"
    exit 1
fi

if ! [[ "$SSH_PORT" =~ ^[0-9]+$ ]] || [[ "$SSH_PORT" -lt 1024 ]] || [[ "$SSH_PORT" -gt 65535 ]]; then
    echo "Error: SSH port must be between 1024-65535"
    exit 1
fi

# Extract VM base name (strip off extension and path)
VM_BASE=$(basename "$INPUT")
VM_BASE="${VM_BASE%.*}"

# Generate consistent 6-character random alphanumeric suffix for new VMs
generate_vm_name() {
    local base="$1"
    local suffix
    suffix=$(tr -dc 'a-z0-9' </dev/urandom | head -c6)
    echo "${base}-${suffix}"
}

# Platform detection and acceleration setup
setup_acceleration() {
    local os_type
    os_type="$(uname)"

    case "$os_type" in
        Linux)
            if [[ -r /dev/kvm ]]; then
                echo "-enable-kvm"
            else
                echo "Warning: KVM not available, using software emulation" >&2
                echo ""
            fi
            ;;
        Darwin)
            echo "-accel hvf"
            ;;
        *)
            echo "Warning: Unsupported OS ($os_type), using software emulation" >&2
            echo ""
            ;;
    esac
}

# Setup display options
setup_display() {
    if [[ "$HEADLESS" == "true" ]]; then
        echo "-display none -vnc :1"
    elif [[ "$DISPLAY_TYPE" == "vnc" ]]; then
        echo "-vnc :1"
    else
        # Check if we're in a display environment
        if [[ -z "$DISPLAY" ]] && [[ "$OSTYPE" != "darwin"* ]]; then
            echo "Warning: No DISPLAY detected, falling back to VNC" >&2
            echo "-vnc :1"
        else
            echo "-display sdl"
        fi
    fi
}

# VM launch function
run_vm() {
    local kvm_opts
    local display_opts
    local extra_args=("$@")

    kvm_opts=$(setup_acceleration)
    display_opts=$(setup_display)

    echo "Launching VM: $VM_NAME"
    echo "  RAM: ${RAM}MB, CPUs: $CPUS"
    echo "  SSH: localhost:$SSH_PORT -> guest:22"

    if [[ "$HEADLESS" == "true" ]]; then
        echo "  Display: Headless (VNC on :5901)"
    elif [[ "$DISPLAY_TYPE" == "vnc" ]] || [[ "$display_opts" == *"vnc"* ]]; then
        echo "  Display: VNC on :5901"
    fi

    # Check if SSH port is already in use
    if command -v ss >/dev/null 2>&1; then
        if ss -tln | grep -q ":$SSH_PORT "; then
            echo "Warning: Port $SSH_PORT appears to be in use"
        fi
    elif command -v netstat >/dev/null 2>&1; then
        if netstat -tln 2>/dev/null | grep -q ":$SSH_PORT "; then
            echo "Warning: Port $SSH_PORT appears to be in use"
        fi
    fi

    echo "Starting VM..."

    # Build and execute QEMU command
    exec qemu-system-x86_64 \
        $kvm_opts \
        -m "$RAM" \
        -smp "$CPUS" \
        -drive file="$DISK_IMAGE",format=qcow2 \
        -netdev user,id=net0,hostfwd=tcp::"$SSH_PORT"-:22 \
        -device e1000,netdev=net0 \
        -device usb-ehci -device usb-tablet \
        -vga virtio \
        $display_opts \
        -name "$VM_NAME" \
        "${extra_args[@]}"
}

# Main logic
case "$MODE" in
    install)
        ISO_PATH="$INPUT"

        # Validate ISO file
        if [[ ! -f "$ISO_PATH" ]]; then
            echo "Error: ISO file not found: $ISO_PATH"
            exit 1
        fi

        # Generate new VM name and disk image
        VM_NAME=$(generate_vm_name "$VM_BASE")
        DISK_IMAGE="${VM_NAME}.qcow2"

        # Check if disk image already exists
        if [[ -f "$DISK_IMAGE" ]]; then
            echo "Warning: Disk image $DISK_IMAGE already exists"
            read -p "Overwrite? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "Aborted"
                exit 1
            fi
            rm -f "$DISK_IMAGE"
        fi

        echo "Creating disk image: $DISK_IMAGE ($DISK_SIZE)"
        qemu-img create -f qcow2 "$DISK_IMAGE" "$DISK_SIZE"

        echo "Starting installation from: $ISO_PATH"
        run_vm -boot d -cdrom "$ISO_PATH"
        ;;

    start)
        # Validate input file
        if [[ ! -f "$INPUT" ]]; then
            echo "Error: File not found: $INPUT"
            exit 1
        fi

        # Check file extension
        EXT="${INPUT##*.}"
        if [[ "$EXT" == "iso" ]]; then
            echo "Error: Cannot start an ISO directly. Use 'install' mode first."
            echo "Example: $0 $INPUT install"
            exit 1
        fi

        # Verify it's a QCOW2 file
        if ! qemu-img info "$INPUT" >/dev/null 2>&1; then
            echo "Error: $INPUT is not a valid disk image"
            exit 1
        fi

        DISK_IMAGE="$INPUT"
        VM_NAME="${DISK_IMAGE%.*}"  # Strip extension for VM name
        VM_NAME=$(basename "$VM_NAME")  # Remove path

        echo "Starting existing VM from: $DISK_IMAGE"
        run_vm
        ;;

    *)
        echo "Error: Invalid mode '$MODE'"
        echo "Expected 'install' or 'start'"
        show_help
        exit 1
        ;;
esac
