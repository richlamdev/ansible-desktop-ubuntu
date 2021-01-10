# Ansible Role: Node exporter

[![Build Status](https://travis-ci.com/geerlingguy/ansible-role-node_exporter.svg?branch=master)](https://travis-ci.com/geerlingguy/ansible-role-node_exporter)

This role installs Prometheus' [Node exporter](https://github.com/prometheus/node_exporter) on Linux hosts, and configures a systemd unit file so the service can run and be controlled by systemd.

**Note**: If you're running in a Kubernetes cluster, you could run Node exporter as a DaemonSet in the cluster, instead of installing it on individual nodes.

## Requirements

N/A

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    node_exporter_version: '0.18.1'

The version of Node exporter to install. Available releases can be found on the [tags](https://github.com/prometheus/node_exporter/tags) listing in the Node exporter repository. Drop the `v` off the tag.

If you change the version, the `node_exporter` binary will be replaced with the updated version, and the service will be restarted.

    node_exporter_arch: 'amd64'
    node_exporter_download_url: https://github.com/prometheus/node_exporter/releases/download/v{{ node_exporter_version }}/node_exporter-{{ node_exporter_version }}.linux-{{ node_exporter_arch }}.tar.gz

The architecture and download URL for Node exporter. If you're on a Raspberry Pi running Raspbian, you may need to override the `arch` value with `armv7l`.

    node_exporter_bin_path: /usr/local/bin/node_exporter

The path where the `node_exporter` binary will be installed.

    node_exporter_options: ''

Any additional options to pass to `node_exporter` when it starts, e.g. `--no-collector.wifi` if you want to ignore any WiFi data.

    node_exporter_state: started
    node_exporter_enabled: true

Controls for the `node_exporter` service.

## Dependencies

None.

## Example Playbook

    - hosts: all
      roles:
        - role: geerlingguy.node_exporter

## License

MIT / BSD

## Author Information

This role was created in 2020 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
