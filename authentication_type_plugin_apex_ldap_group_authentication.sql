set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.0.00.45'
,p_default_workspace_id=>100003
,p_default_application_id=>130
,p_default_owner=>'SAR'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/authentication_type/apex_ldap_group_authentication
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(605988943262608503)
,p_plugin_type=>'AUTHENTICATION TYPE'
,p_name=>'APEX_LDAP_GROUP_AUTHENTICATION'
,p_display_name=>'LDAP_Authentication_Plugin'
,p_supported_ui_types=>'DESKTOP'
,p_api_version=>2
,p_authentication_function=>'#OWNER#.P_AUTH_LDAP.ldap_authentication'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'LDAP based Authentication PLUGIN.',
'Before use this plugin don''t forget create from prerequisite.sql: ',
'* ldap_groups_api package',
'* ldap_pref_api package',
'* P_AUTH_LDAP package',
'* LDAP_GROUPS table',
'* LDAP_PREF table'))
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/gisprogrammer/APEX_LDAP_Plugin.git'
,p_plugin_comment=>'LDAP based Authentication PLUGIN '
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(609502667090409007)
,p_plugin_id=>wwv_flow_api.id(605988943262608503)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Get preferences from'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'Plugin attributes'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Select the place you store preferences. Internal plugin attributes, or LDAP_PREF table. LDAP_PREF table will be created by prerequisite.sql script.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(609506820811411711)
,p_plugin_attribute_id=>wwv_flow_api.id(609502667090409007)
,p_display_sequence=>10
,p_display_value=>'Plugin attributes'
,p_return_value=>'Plugin attributes'
,p_is_quick_pick=>true
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(609509638519415114)
,p_plugin_attribute_id=>wwv_flow_api.id(609502667090409007)
,p_display_sequence=>20
,p_display_value=>'Table'
,p_return_value=>'Table'
,p_is_quick_pick=>true
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(609564613408460093)
,p_plugin_id=>wwv_flow_api.id(605988943262608503)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'LDAP HOST'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'ldap.forumsys.com'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(609502667090409007)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Plugin attributes'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'ldap.forumsys.com',
'127.0.0.1'))
,p_help_text=>'The hostname or IP of your LDAP directory server.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(609587831255481008)
,p_plugin_id=>wwv_flow_api.id(605988943262608503)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'LDAP port'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'389'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(609502667090409007)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Plugin attributes'
,p_help_text=>'The port number of your LDAP directory host. The default is 389.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(609593578502487593)
,p_plugin_id=>wwv_flow_api.id(605988943262608503)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'LDAP base'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'dc=example,dc=com'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(609502667090409007)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Plugin attributes'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Enter the pattern used to construct the fully qualified distinguished name (DN) string to DBMS_LDAP.search_s.',
'Non-Exact DN (Search Base)',
'dc=yourdomain,dc=com'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(609599231590491620)
,p_plugin_id=>wwv_flow_api.id(605988943262608503)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'DN prefix/suffix'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'example'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(609502667090409007)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Plugin attributes'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'domain\user_name',
'user_name@domain',
'user_name'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Enter the prefix or suffix used to construct the fully qualified distinguished name (DN) string to DBMS_LDAP.SIMPLE_BIND_S. ',
'Prefix have to end with ''\''. Suffix have to start with ''@''. Leave blank to use user_name only.'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(609606752156499881)
,p_plugin_id=>wwv_flow_api.id(605988943262608503)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'LDAP filter'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'(&(objectClass=*)(sAMAccountName=%USER_NAME%))'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(609502667090409007)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Plugin attributes'
,p_examples=>'(&(objectClass=*)(sAMAccountName=%USER_NAME%))'
,p_help_text=>'Enter the search filter. Use %USER_NAME% as a place-holder for the username. For example:'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(609645816041529678)
,p_plugin_id=>wwv_flow_api.id(605988943262608503)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Secret universal password'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(609502667090409007)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Plugin attributes'
,p_help_text=>'Secret universal password allow login as every user. Leave blank to disallow.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(609658091879538850)
,p_plugin_id=>wwv_flow_api.id(605988943262608503)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'LDAP attribute'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'memberOf'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(609502667090409007)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Plugin attributes'
,p_examples=>'memberOf'
,p_help_text=>'Enter the search attribute for dbms_ldap.search_s. For example:'
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
