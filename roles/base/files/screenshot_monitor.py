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

        # Handle duplicate filenames
        if dest_path.exists():
            base = dest_path.stem
            ext = dest_path.suffix
            counter = 1
            while dest_path.exists():
                dest_path = dest_dir / f"{base}_{counter}{ext}"
                counter += 1

        shutil.move(str(source_path), str(dest_path))

        # Set proper permissions so file appears on desktop
        # 0o644 = rw-r--r-- (owner can read/write, others can read)
        os.chmod(dest_path, 0o644)

        # Ensure current user owns the file
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

    # Initialize inotify - only watch CLOSE_WRITE and MOVED_TO (file complete events)
    inotify = INotify()
    watch_flags = flags.CLOSE_WRITE | flags.MOVED_TO
    wd = inotify.add_watch(str(source_dir), watch_flags)

    # Track files already processed to avoid double-processing
    processed = set()

    try:
        while True:
            # Wait for events (blocking)
            events = inotify.read()

            for event in events:
                # Skip directories
                if event.mask & flags.ISDIR:
                    continue

                filename = event.name
                if not filename or filename in processed:
                    continue

                source_path = source_dir / filename
                if source_path.exists():
                    processed.add(filename)
                    transfer_file(source_path, dest_dir)

    except KeyboardInterrupt:
        print("\nStopping monitor...")
    finally:
        inotify.close()


if __name__ == "__main__":
    main()
