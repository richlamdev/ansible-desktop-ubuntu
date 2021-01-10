def to_ini(settings = {}):
    """
    Custom Ansible filter to print out a YAML dictionary in the INI file format.
    Similar to the built-in to_yaml/to_json filters.
    """
    s = ''
    # loop through each section
    for section in settings:
        # print the section header
        s += '[%s]\n' % section
        # loop through each option in the section
        for option in settings[section]:
            # if the value is a list, join it with commas
            if isinstance(settings[section][option], list):
                value = ' '.join(settings[section][option])
            else: # otherwise just use it as is
                value = settings[section][option]
            # print the option and value
            s += '%s = %s\n' % (option, value)
            s.rstrip()
        # add some separation between sections
        s += '\n'
    return s.rstrip()


class FilterModule():
    def filters(self):
        return {'grafana_to_ini': to_ini}
