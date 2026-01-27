#!/usr/bin/env python3
# /// script
# dependencies = [
#   "inotify-simple",
# ]
# ///
"""
Screenshot Transfer Monitor
Monitors ~/Pictures/Screenshots/ and transfers new files to ~/Desktop
"""

import os
import shutil
from pathlib import Path
from inotify_simple import INotify, flags


def setup_directories():
    """Setup and validate source and destination directories."""
    # Path.home() resolves dynamically to the current user's home directory
    home = Path.home()
    source_dir = home / "Pictures" / "Screenshots"
    dest_dir = home / "Desktop"

    # Ensure source directory exists
    if not source_dir.exists():
        print(f"Creating source directory: {source_dir}")
        source_dir.mkdir(parents=True, exist_ok=True)

    # Ensure destination directory exists
    if not dest_dir.exists():
        print(f"Creating destination directory: {dest_dir}")
        dest_dir.mkdir(parents=True, exist_ok=True)

    return source_dir, dest_dir


def transfer_file(source_path, dest_dir):
    """Transfer a file from source to destination."""
    try:
        dest_path = dest_dir / source_path.name

        # Handle duplicate filenames by appending a counter
        if dest_path.exists():
            base = dest_path.stem
            ext = dest_path.suffix
            counter = 1
            while dest_path.exists():
                dest_path = dest_dir / f"{base}_{counter}{ext}"
                counter += 1

        shutil.move(str(source_path), str(dest_path))

        # Set permissions: rw-r--r-- (User: Read/Write, Group/Others: Read)
        os.chmod(dest_path, 0o644)

        # Ensure current user owns the file (important if run via sudo/root context)
        uid = os.getuid()
        gid = os.getgid()
        os.chown(dest_path, uid, gid)

        print(f"Transferred: {source_path.name} -> {dest_path}")
        return True
    except Exception as e:
        print(f"Error transferring {source_path.name}: {e}")
        return False


def main():
    """Main monitoring loop."""
    source_dir, dest_dir = setup_directories()

    print(f"Monitoring: {source_dir}")
    print(f"Destination: {dest_dir}")
    print("Press Ctrl+C to stop\n")

    # Initialize inotify
    inotify = INotify()
    watch_flags = flags.CLOSE_WRITE | flags.MOVED_TO

    # We call add_watch to register it with the kernel,
    # but we don't need to store the return value (wd) since we only watch one path.
    inotify.add_watch(str(source_dir), watch_flags)

    try:
        while True:
            # Blocking wait for events (uses 0% CPU while waiting)
            events = inotify.read()

            for event in events:
                # Skip directory events
                if event.mask & flags.ISDIR:
                    continue

                filename = event.name
                if not filename:
                    continue

                source_path = source_dir / filename

                # Check if file exists and ignore hidden files (like .temp)
                if source_path.exists() and not filename.startswith('.'):
                    transfer_file(source_path, dest_dir)

    except KeyboardInterrupt:
        print("\nStopping monitor...")
    finally:
        inotify.close()


if __name__ == "__main__":
    main()
