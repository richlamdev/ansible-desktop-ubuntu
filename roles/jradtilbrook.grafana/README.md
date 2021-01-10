# Ansible Role: Grafana [![Build Status](https://travis-ci.org/jradtilbrook/ansible-role-grafana.svg?branch=master)](https://travis-ci.org/jradtilbrook/ansible-role-grafana)

This role installs and configures Grafana - for analytics and monitoring.

It has only been designed to work on Ubuntu 16.04, but other Debian flavours
should also work.


## Requirements

None.


## Role Variables

`grafana_configuration`: This variable is persisted to the Grafana configuration
file in INI format. Any valid configuration properties are supported. For
example, setting up GitHub OAuth would look something like this:

```yaml
grafana_configuration:
  'auth.github':
    enabled: yes
    allow_sign_up: yes
    client_id: <your_client_id>
    client_secret: <your_client_secret>
    scopes: user:email
    auth_url: https://github.com/login/oauth/authorize
    token_url: https://github.com/login/oauth/access_token
    api_url: https://api.github.com/user
```

**Note**: some settings expect space separated arguments. These can either be
specified in a YAML array or as a single string. Other settings need to be comma
separated and these must use a single string.

`grafana_install_state`: This is useful for updating Grafana to newer versions
after it has already been installed. Use `latest` to achieve this functionality.


## Resources

Documentation related to Grafana can be found at the links below:

- [documentation](http://docs.grafana.org/)


## Dependencies

None, but you may want to run grafana behind a webserver - I recommend using the
[geerlingguy.nginx](https://github.com/geerlingguy/ansible-role-nginx) role.


## Example Playbook

```yaml
- hosts: servers
  become: yes

  roles:
    - role: jradtilbrook.grafana
```


## License

MIT
