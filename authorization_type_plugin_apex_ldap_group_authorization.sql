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
prompt --application/shared_components/plugins/authorization_type/apex_ldap_group_authorization
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(606412929767975612)
,p_plugin_type=>'AUTHORIZATION TYPE'
,p_name=>'APEX_LDAP_GROUP_AUTHORIZATION'
,p_display_name=>'LDAP_Group_Authorization_Plugin'
,p_supported_ui_types=>'DESKTOP'
,p_api_version=>2
,p_execution_function=>'#OWNER#.P_AUTH_LDAP.ldap_authorization'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Before use this plugin don''t forget create from prerequisite.sql: ',
'* ldap_groups_api package',
'* ldap_pref_api package',
'* P_AUTH_LDAP package',
'* LDAP_GROUPS table',
'* LDAP_PREF table',
'This is LDAP based autorization plugin. Create separate instance of plugin for each LDAP group.',
'This plugin don''t connect with LDAP server, but gets user groups information from LDAP_GROUPS table.'))
,p_version_identifier=>'1.0'
,p_about_url=>'https://github.com/gisprogrammer/APEX_LDAP_Plugin.git'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(606421016845995943)
,p_plugin_id=>wwv_flow_api.id(606412929767975612)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'ldap_group'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'Users'
,p_display_length=>50
,p_max_length=>50
,p_is_translatable=>false
,p_help_text=>'Enter LDAP Group'
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
