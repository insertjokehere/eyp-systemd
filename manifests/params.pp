class systemd::params {

  case $facts['os']['family']
  {
    'redhat' :
    {
      case $facts['os']['name']
      {
        'Fedora':
        {
          case $facts['os']['release']['full']
          {
            /^1[5-9].*$/:
            {
            }
            /^[23][0-9].*$/:
            {
            }
            default: { fail('Unsupported RHEL/CentOS version!')  }
          }
        }
        'Amazon':
        {
          case $facts['os']['release']['full']
          {
            /^[2].*$/:
            {
            }
            default: { fail('Unsupported RHEL/CentOS version!')  }
          }
        }
        default:
        {
          case $facts['os']['release']['full']
          {
            /^[78].*$/:
            {
            }
            default: { fail('Unsupported RHEL/CentOS version!')  }
          }
        }
      }
    }
    'Debian':
    {
      case $facts['os']['name']
      {
        'Ubuntu':
        {
          case $facts['os']['release']['full']
          {
            /^1[68].*$/:
            {
            }
            /^2[02].*$/:
            {
            }
            default: { fail('Unsupported Ubuntu version!')  }
          }
        }
        'Debian':
        {
          case $facts['os']['release']['full']
          {
            /^[89].*$/:
            {
            }
            /^1[01].*$/:
            {
            }
            default: { fail('Unsupported Debian version!')  }
          }
        }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    'Suse' :
    {
      case $facts['os']['release']['full']
      {
        /11.4/:
        {
        }
        /^1[235].*/:
        {
        }
        /^42.*/:
        {
        }
        default: { fail('Unsupported Suse/OpenSuse version!')  }
      }
    }
    'Archlinux' :
    {
    }
    default  : { fail('Unsupported OS!') }
  }
}
