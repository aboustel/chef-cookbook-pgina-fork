#
# Cookbook Name:: pgina
# Recipe:: default
#
# Copyright 2013, NetSrv Consulting Ltd.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

::Chef::Recipe.send(:include, PGina::Helper)

windows_package node[:pgina][:application_string] do
  source node[:pgina][:installer_url]
  action :install
end

pGina3 ="HKLM\\SOFTWARE\\pGina3"
ldap_plugin ="#{pGina3}\\Plugins\\0f52390b-c781-43ae-bd62-553c77fa4cf7"

# General Config
#----------------

# The tile_image attrib is relative to the cache path
if node[:pgina][:tile_image]
  tile_image = node[:pgina][:tile_image]
else
  tile_image = ""
end

registry_key pGina3 do
  values [
    {
      :name => "Motd",
      :type => :string,
      :data => node['pgina']['motd']
    },
    {
      :name => "TileImage",
      :type => :string,
      :data => tile_image
    }
  ]
  action :create
end


registry_key pGina3 do
  values [
    {
      :name => "CredentialProviderFilters",
      :type => :multi_string,
      :data => [ "{6f45dc1e-5384-457a-bc13-2cd81b0d28ed}\t15" ]
    }
  ]
  only_if { node[:pgina][:disable_default_provider] }
  action :create
end

# LDAP Plugins
#--------------
registry_key ldap_plugin do
  values [
    {
      :name => "LdapPort",
      :type => :dword,
      :data => node[:pgina][:ldap][:port]
    },
    {
      :name => "LdapTimeout",
      :type => :dword,
      :data => node[:pgina][:ldap][:timeout]
    },
    {
      :name => "DnPattern",
      :type => :string,
      :data => node[:pgina][:ldap][:user_dn_pattern]
    },
    {
      :name => "UseSsl",
      :type => :string,
      :data => node[:pgina][:ldap][:ssl_enabled]
    },
    {
      :name => "UseTls",
      :type => :string,
      :data => node[:pgina][:ldap][:tls_enabled]
    },
    {
      :name => "RequireCert",
      :type => :string,
      :data => node[:pgina][:ldap][:require_cert]
    },
    {
      :name => "ServerCertFile",
      :type => :string,
      :data => node[:pgina][:ldap][:require_cert]
    },
    {
      :name => "UseAuthBindForAuthzAndGateway",
      :type => :string,
      :data => node[:pgina][:ldap][:bind_with_user_credentials]
    },
    {
      :name => "SearchDN",
      :type => :string,
      :data => node[:pgina][:ldap][:search_dn]
    },
    {
      :name => "DoSearch",
      :type => :string,
      :data => node[:pgina][:ldap][:search_enabled]
    },
    {
      :name => "SearchFilter",
      :type => :string,
      :data => node[:pgina][:ldap][:search_filter]
    },

    {
      :name => "SearchContexts",
      :type => :multi_string,
      :data => node[:pgina][:ldap][:search_contexts]
    },
    {
      :name => "LdapHost",
      :type => :multi_string,
      :data => node[:pgina][:ldap][:hosts]
    }
  ]
  action :create
end

# The plugin state is a binary flag, this says all or nothing
ldap_plugin_state = node[:pgina][:ldap][:enabled] ? 46 : 0

registry_key pGina3 do
  values [ 
    {
      :name => "0f52390b-c781-43ae-bd62-553c77fa4cf7",
      :type => :dword,
      :data => ldap_plugin_state
    },
    {
      :name => "12FA152D-A2E3-4C8D-9535-5DCD49DFCB6D",
      :type => :dword,
      :data => 8
    }
  ]
  action :create
end


# Authorisation

# If we require the server than we need it to be up and for authentication to succeed
registry_key ldap_plugin do
  values [ 
    {
      :name => "AuthzAllowOnError",
      :type => :string,
      :data => node[:pgina][:ldap][:require_server] ? "False" : "True"
    },
    {
      :name => "AuthzRequireAuth",
      :type => :string,
      :data => node[:pgina][:ldap][:require_server] ? "True" : "False"
    }
  ]
  action :create

end

authz_groups = node[:pgina][:ldap][:require_groups]
authz_rules = ldap_authz_rules( authz_groups )
registry_key ldap_plugin do 
  values [ 
    {
      :name => "GroupAuthzRules",
      :type => :multi_string,
      :data => authz_rules
    }
  ]
  action :create
end

# Gateway
always_groups = node[:pgina][:ldap][:always_add_to_groups]
add_groups_if = node[:pgina][:ldap][:add_to_groups_if]
add_groups_if_not = node[:pgina][:ldap][:add_to_groups_not_if]
rules = ldap_gateway_group_rules(always_groups, add_groups_if, add_groups_if_not)


registry_key ldap_plugin do 
  values [ 
    {
      :name => "GroupGatewayRules",
      :type => :multi_string,
      :data => rules
    }
  ]
  action :create
end

# -------

# Make sure LDAP is first otherwise users will not be able to login
registry_key pGina3 do 
  values [ 
    {
      :name => "IPluginAuthenticationGateway_Order",
      :type => :multi_string,
      :data => [ "0f52390b-c781-43ae-bd62-553c77fa4cf7","12fa152d-a2e3-4c8d-9535-5dcd49dfcb6d" ]
    },
    {
      :name => "IPluginAuthentication_Order",
      :type => :multi_string,
      :data => [ "0f52390b-c781-43ae-bd62-553c77fa4cf7"]
    }
  ]
  only_if { node[:pgina][:ldap][:enabled] }
  action :create
end
