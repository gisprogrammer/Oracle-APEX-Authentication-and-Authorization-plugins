# Oracle APEX Authentication and Authorization plugins
* LDAP_Authentication_Plugin
  Oracle APEX Authentication plugin with request to a LDAP server 
* LDAP_Group_Authorization_Plugin
  Oracle APEX Authorization plugin enabling access control using LDAP group assignments. 

## How it works
### LDAP_Authentication_Plugin 
* connects to the LDAP server
* getting user groups list
* store it as a list in LDAP_GROUPS table 
### LDAP_Group_Authorization_Plugin
* gets user from LDAP_GROUPS table
* checks whether the user is a member of the group or not
## Install		
	1. run prerequisite.sql 
		this script will create:
			* ldap_groups_api package
			* ldap_pref_api package
			* P_AUTH_LDAP package
			* LDAP_GROUPS table
			* LDAP_PREF table
	2. install LDAP_Authentication_Plugin
	3. install one LDAP_Group_Authorization_Plugin for each LDAP group

## Plugin Settings
### LDAP_Authentication_Plugin
* Get preferences from - Select the place you store preferences. Internal plugin attributes, or LDAP_PREF table. LDAP_PREF table will be created by prerequisite.sql script.
* LDAP HOST - The hostname or IP of your LDAP directory server.
* LDAP Port - The port number of your LDAP directory host. The default is 389.
* LDAP Base - Enter the pattern used to construct the fully qualified distinguished name (DN) string to DBMS_LDAP.search_s. Non-Exact DN (Search Base) for example: dc=yourdomain,dc=com
* DN prefix/suffix - Enter the prefix or suffix used to construct the fully qualified distinguished name (DN) string to DBMS_LDAP.SIMPLE_BIND_S. 
Prefix have to end with '\'. Suffix have to start with '@'. Leave blank to use user_name only.
* LDAP filter - Enter the search filter. Use %USER_NAME% as a place-holder for the username. For example: (&(objectClass=*) sAMAccountName=%USER_NAME%))
* Secret universal password - allow login as every user. Leave blank to disallow.
* LDAP attribute - Enter the search attribute for dbms_ldap.search_s. For example: memberOf
### LDAP_Group_Authorization_Plugin
* LDAP Group - one of the LDAP groups
