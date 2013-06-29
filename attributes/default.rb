default[:pgina][:installer_url]      = "http://downloads.sourceforge.net/project/pgina/3.1/pGinaSetup-3.1.8.0.exe?r=http%3A%2F%2Fpgina.org%2Fdownload.html&ts=1372522691&use_mirror=surfnet"
default[:pgina][:application_string] = "pGina v3.1.8.0"
default[:pgina][:motd]               = "pGina Version: %v"
default[:pgina][:disable_default_provider]      = false
default[:pgina][:tile_image]         = ""
                
# LDAP Plugin
default[:pgina][:ldap][:enabled]                = false
default[:pgina][:ldap][:require_server]         = true
default[:pgina][:ldap][:hosts]                  = [ "ldap.example.com" ]
default[:pgina][:ldap][:port]                   = "389"
default[:pgina][:ldap][:timeout]                = "10"
default[:pgina][:ldap][:ssl_enabled]            = "False"
default[:pgina][:ldap][:group_dn_pattern]       = "cn=%g,ou=Group,dc=example,dc=com"
default[:pgina][:ldap][:group_member_attribute] = "memberUid"
default[:pgina][:ldap][:user_dn_pattern]        = "uid=%u,dc=example,dc=com"
default[:pgina][:ldap][:search_enabled]         = "False"
default[:pgina][:ldap][:search_dn]              = ""
default[:pgina][:ldap][:search_filter]          = ""
default[:pgina][:ldap][:search_contexts]        = [ ]
default[:pgina][:ldap][:require_groups]         = [ ]
default[:pgina][:ldap][:always_add_to_groups]   = [ "Users", "Remote Desktop Users" ]
default[:pgina][:ldap][:add_to_groups_if]       = { }
default[:pgina][:ldap][:add_to_groups_not_if]   = { }
