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
  tile_image = File.join(Chef::Config[:file_cache_path],node[:pgina][:tile_image])
else
  tile_image = ""
end

windows_registry pGina3 do
  values(
    "Motd" => node[:pgina][:motd],
    "TileImage" => tile_image
  )
  type :string
  action :create
end

# Disabling the password provider allows pGina to control RDP logons by default
windows_registry pGina3 do
  values "CredentialProviderFilters" => [ "{6f45dc1e-5384-457a-bc13-2cd81b0d28ed}\t15" ]
  type :multi_string
  only_if { node[:pgina][:disable_default_provider] }
  action :create
end

# LDAP Plugins
#--------------
windows_registry ldap_plugin do
  values(
    'LdapPort'    => node[:pgina][:ldap][:port],  
    'LdapTimeout' => node[:pgina][:ldap][:timeout]
  )
  type :dword
  action :create
end

windows_registry ldap_plugin do
  values(
    'DnPattern'   => node[:pgina][:ldap][:user_dn_pattern],
    'UseSsl'      => node[:pgina][:ldap][:ssl_enabled],
    'SearchDN'    => node[:pgina][:ldap][:search_dn],
    'SearchPW'    => node[:pgina][:ldap][:search_password],
    'GroupDnPattern'    => node[:pgina][:ldap][:group_dn_pattern],
    'GroupMemberAttrib' => node[:pgina][:ldap][:group_member_attribute],
    'DoSearch'          => node[:pgina][:ldap][:search_enabled],
    'SearchFilter'      => node[:pgina][:ldap][:search_filter],
  )
  type :string
  action :create
end

windows_registry ldap_plugin do
  values(
    'SearchContexts' => node[:pgina][:ldap][:search_contexts],
    'LdapHost'       => node[:pgina][:ldap][:hosts]
  )
  type :multi_string
  action :create
end

# The plugin state is a binary flag, this says all or nothing
ldap_plugin_state = node[:pgina][:ldap][:enabled] ? 14 : 0

windows_registry pGina3 do
  values(
    "0f52390b-c781-43ae-bd62-553c77fa4cf7" => ldap_plugin_state,
    "12FA152D-A2E3-4C8D-9535-5DCD49DFCB6D" => 10                       # Enable local machine for auth and gateway
  )
  type :dword
  action :create
end


# Authorisation

# If we require the server than we need it to be up and for authentication to succeed
windows_registry ldap_plugin do 
  values(
    "AuthzAllowOnError" => node[:pgina][:ldap][:require_server] ? "False" : "True",
    "AuthzRequireAuth" => node[:pgina][:ldap][:require_server] ? "True" : "False"
  )
  type :string
  action :create
end

authz_groups = node[:pgina][:ldap][:require_groups]
authz_rules = ldap_authz_rules( authz_groups )
windows_registry ldap_plugin do 
  values "GroupAuthzRules" => authz_rules
  type :multi_string
  action :create
end

# Gateway
always_groups = node[:pgina][:ldap][:always_add_to_groups]
add_groups_if = node[:pgina][:ldap][:add_to_groups_if]
add_groups_if_not = node[:pgina][:ldap][:add_to_groups_not_if]
rules = ldap_gateway_group_rules(always_groups, add_groups_if, add_groups_if_not)

windows_registry ldap_plugin do 
  values "GroupGatewayRules" => rules
  type :multi_string
  action :create
end

# -------

# Make sure LDAP is first otherwise users will not be able to login
windows_registry pGina3 do
  values(
    "IPluginAuthenticationGateway_Order" => [ "0f52390b-c781-43ae-bd62-553c77fa4cf7","12fa152d-a2e3-4c8d-9535-5dcd49dfcb6d" ],
    "IPluginAuthentication_Order"        => [ "0f52390b-c781-43ae-bd62-553c77fa4cf7","12fa152d-a2e3-4c8d-9535-5dcd49dfcb6d" ]
  )
  type :multi_string
  only_if { node[:pgina][:ldap][:enabled] }
  action :create
end
