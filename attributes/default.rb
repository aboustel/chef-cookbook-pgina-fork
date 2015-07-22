default[:pgina][:installer_url]      = "https://github.com/MutonUfoAI/pgina/releases/download/3.2.4.1/pGinaSetup-3.2.4.1.exe"
default[:pgina][:application_string] = "pGina v3.2.4.1"
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
default[:pgina][:ldap][:tls_enabled]            = "False"
default[:pgina][:ldap][:require_cert]           = "False"
default[:pgina][:ldap][:server_cert_file]       = ""
default[:pgina][:ldap][:user_dn_pattern]        = "uid=%u,dc=example,dc=com"
default[:pgina][:ldap][:search_enabled]         = "False"
default[:pgina][:ldap][:bind_with_user_credentials] = "True"
default[:pgina][:ldap][:search_dn]              = ""
default[:pgina][:ldap][:search_filter]          = ""
default[:pgina][:ldap][:search_contexts]        = [ ]
default[:pgina][:ldap][:require_groups]         = [ ]
default[:pgina][:ldap][:always_add_to_groups]   = [ "Users", "Remote Desktop Users" ]
default[:pgina][:ldap][:add_to_groups_if]       = { }
default[:pgina][:ldap][:add_to_groups_not_if]   = { }
