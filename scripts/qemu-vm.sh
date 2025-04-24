#!/bin/bash

set -e

if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 <iso-or-disk.qcow2> <install|start>"
    exit 1
fi

INPUT="$1"
MODE="$2"
VM_NAME=$(basename "$INPUT" | cut -d. -f1)
DISK_IMAGE="${VM_NAME}.qcow2"
RAM="4096"
CPUS="2"

# Platform detection
KVM_OPTS=""
OS_TYPE="$(uname)"
if [[ "$OS_TYPE" == "Linux" ]]; then
    KVM_OPTS="-enable-kvm"
elif [[ "$OS_TYPE" == "Darwin" ]]; then
    KVM_OPTS="-accel hvf"
else
    echo "Unsupported OS: $OS_TYPE"
    exit 1
fi

# VM start command shared by both modes
run_vm() {
    echo "Launching VM: $VM_NAME"
    qemu-system-x86_64 \
        $KVM_OPTS \
        -m "$RAM" \
        -smp "$CPUS" \
        -drive file="$DISK_IMAGE",format=qcow2 \
        -netdev user,id=net0,hostfwd=tcp::2222-:22 \
        -device e1000,netdev=net0 \
        -device usb-ehci -device usb-tablet \
        -vga virtio \
        -display sdl \
        -name "$VM_NAME" "$@"
}

if [[ "$MODE" == "install" ]]; then
    ISO_PATH="$INPUT"

    if [[ ! -f "$ISO_PATH" ]]; then
        echo "ISO not found: $ISO_PATH"
        exit 1
    fi

    if [[ ! -f "$DISK_IMAGE" ]]; then
        echo "Creating disk image: $DISK_IMAGE"
        qemu-img create -f qcow2 "$DISK_IMAGE" 20G
    fi

    run_vm -boot d -cdrom "$ISO_PATH"

elif [[ "$MODE" == "start" ]]; then
    if [[ ! -f "$INPUT" ]]; then
        echo "Disk image not found: $INPUT"
        exit 1
    fi

    DISK_IMAGE="$INPUT"
    run_vm

else
    echo "Invalid mode: $MODE"
    echo "Expected 'install' or 'start'"
    exit 1
fi

exit 0
