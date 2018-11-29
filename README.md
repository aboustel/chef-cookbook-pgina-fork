pgina
=====
This Chef cookbook installs pGina fork.

pGina is a pluggable Open Source GINA and CredentialProvider replacement. This allows for alternate methods of interactive user authentication
and access management on machines running the Windows operating system. In short, allow your windows users to login using the backend of your choice.

Requirements
------------
* Microsoft Visual C++ 2012 Redistributable (x64)
* Microsoft Visual C++ 2012 Redistributable (x86)

A cookbook for installing thse is available [in NetSrv's cookbooks repository](from https://github.com/netsrv-cookbooks/ms-cpp-redistributable).

Usage
-----
Add pgina to your run list.

Using With Terminal Services
----------------------------
Users must be added to the Remote Desktop Users group (or granted "Allow log on through Terminal Services").

To make pGina the main provider for terminal services, the password provider has to be disabled.

Attributes
----------
#### pgina::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['pgina']['installer_url']</tt></td>
    <td>String</td>
    <td>The URL to fetch the installer from</td>
    <td><tt>https://github.com/MutonUfoAI/pgina/releases/download/3.2.4.1/pGinaSetup-3.2.4.1.exe</tt></td>
  </tr>
  <tr>
    <td><tt>['pgina']['application_string']</tt></td>
    <td>String</td>
    <td>The string that appears in the list of installed programs</td>
    <td><tt>pGina v3.2.4.1</tt></td>
  </tr>
</table>

Adding to Local Groups
----------------------

node[:pgina][:ldap][:always_add_to_groups] is an array of local group names to always add the user to

node[:pgina][:ldap][:add_to_groups_if] is a hash that adds the user to the local groups if a member of the ldap group

    { "ldapgroup" : [ "localgroup1", "localgroup2" ] }

node[:pgina][:ldap][:add_to_groups_not_if] is a hash that adds the user to the local groups if is not a member of the ldap group

    { "ldapgroup" : [ "localgroup1", "localgroup2" ] }

License
-------
    Copyright 2013, NetSrv Consulting Ltd.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

Authors
-------
* Colin Woodcock (<cwoodcock@netsrv-consulting.com>)

