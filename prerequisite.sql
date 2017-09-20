--------------------------------------------------------
--  DDL for Table LDAP_GROUPS
--------------------------------------------------------
DROP TABLE ldap_groups;
CREATE TABLE "LDAP_GROUPS" (
    "ID" NUMBER,"LOGIN_DOMENA" VARCHAR2(4000 BYTE),"LDAP_GROUPS" VARCHAR2(4000 BYTE),"CREATED" TIMESTAMP(6) WITH LOCAL TIME ZONE,"CREATED_BY" VARCHAR2(255 BYTE),"UPDATED" TIMESTAMP
(6) WITH LOCAL TIME ZONE,"UPDATED_BY" VARCHAR2(255 BYTE)
);
--------------------------------------------------------
--  DDL for Index LDAP_GROUPS_ID_PK
--------------------------------------------------------
CREATE UNIQUE INDEX "LDAP_GROUPS_ID_PK" ON
    "LDAP_GROUPS" ( "ID" );
--------------------------------------------------------
--  DDL for Index LDAP_GROUPS_LOGIN_UQ
--------------------------------------------------------
CREATE UNIQUE INDEX "LDAP_GROUPS_LOGIN_UQ" ON
    "LDAP_GROUPS" ( "LOGIN_DOMENA" );
--------------------------------------------------------
--  DDL for Trigger LDAP_GROUPS_BIU
--------------------------------------------------------
CREATE OR REPLACE TRIGGER "LDAP_GROUPS_BIU" BEFORE
    INSERT OR UPDATE ON ldap_groups
    FOR EACH ROW
BEGIN
    :new.login_domena := upper(:new.login_domena);
    IF :new.id IS NULL
    THEN
        :new.id := to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    END IF;
    IF
        inserting
    THEN
        :new.created := localtimestamp;
        :new.created_by := nvl(
            sys_context('APEX$SESSION','APP_USER'),user
        );
    END IF;
    :new.updated := localtimestamp;
    :new.updated_by := nvl(
        sys_context('APEX$SESSION','APP_USER'),user
    );
END ldap_groups_biu;
/
ALTER TRIGGER "LDAP_GROUPS_BIU" ENABLE;
--------------------------------------------------------
--  Constraints for Table LDAP_GROUPS
--------------------------------------------------------
ALTER TABLE "LDAP_GROUPS" ADD CONSTRAINT "LDAP_GROUPS_ID_PK" PRIMARY KEY ( "ID" );
ALTER TABLE "LDAP_GROUPS" MODIFY (
    "UPDATED_BY"
        NOT NULL ENABLE
);
ALTER TABLE "LDAP_GROUPS" MODIFY (
    "UPDATED"
        NOT NULL ENABLE
);
ALTER TABLE "LDAP_GROUPS" MODIFY (
    "CREATED_BY"
        NOT NULL ENABLE
);
ALTER TABLE "LDAP_GROUPS" MODIFY (
    "CREATED"
        NOT NULL ENABLE
);
ALTER TABLE "LDAP_GROUPS" MODIFY (
    "ID"
        NOT NULL ENABLE
);
ALTER TABLE "LDAP_GROUPS" ADD CONSTRAINT "LDAP_GROUPS_LOGIN_UQ" UNIQUE ( "LOGIN_DOMENA" );
ALTER TABLE "LDAP_GROUPS" MODIFY (
    "LOGIN_DOMENA"
        NOT NULL ENABLE
);
  
  --------------------------------------------------------
--  DDL for Table LDAP_PREF
--------------------------------------------------------
DROP TABLE ldap_pref;
CREATE TABLE "LDAP_PREF" (
    "ID" NUMBER,"PREFERENCE_NAME" VARCHAR2(255 BYTE),"PREFERENCE_VALUE" VARCHAR2(4000 BYTE),"CREATED" TIMESTAMP(6) WITH LOCAL TIME ZONE,"CREATED_BY" VARCHAR2(255 BYTE),"UPDATED"
TIMESTAMP(6) WITH LOCAL TIME ZONE,"UPDATED_BY" VARCHAR2(255 BYTE)
);
--------------------------------------------------------
--  DDL for Index LDAP_PREF_ID_PK
--------------------------------------------------------
CREATE UNIQUE INDEX "LDAP_PREF_ID_PK" ON
    "LDAP_PREF" ( "ID" );
--------------------------------------------------------
--  DDL for Index LDAP_PREF_PREF_NAME_UK
--------------------------------------------------------
CREATE UNIQUE INDEX "LDAP_PREF_PREF_NAME_UK" ON
    "LDAP_PREF" ( "PREFERENCE_NAME" );
--------------------------------------------------------
--  DDL for Trigger LDAP_PREF_BIU
--------------------------------------------------------
CREATE OR REPLACE TRIGGER "LDAP_PREF_BIU" BEFORE
    INSERT OR UPDATE ON ldap_pref
    FOR EACH ROW
BEGIN
    IF :new.id IS NULL
    THEN
        :new.id := to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    END IF;
    IF
        inserting
    THEN
        :new.created := localtimestamp;
        :new.created_by := nvl(
            sys_context('APEX$SESSION','APP_USER'),user
        );
    END IF;
    :new.updated := localtimestamp;
    :new.updated_by := nvl(
        sys_context('APEX$SESSION','APP_USER'),user
    );
END ldap_pref_biu;
/
ALTER TRIGGER "LDAP_PREF_BIU" ENABLE;
--------------------------------------------------------
--  Constraints for Table LDAP_PREF
--------------------------------------------------------
ALTER TABLE "LDAP_PREF" ADD CONSTRAINT "LDAP_PREF_ID_PK" PRIMARY KEY ( "ID" );
ALTER TABLE "LDAP_PREF" MODIFY (
    "UPDATED_BY"
        NOT NULL ENABLE
);
ALTER TABLE "LDAP_PREF" MODIFY (
    "UPDATED"
        NOT NULL ENABLE
);
ALTER TABLE "LDAP_PREF" MODIFY (
    "CREATED_BY"
        NOT NULL ENABLE
);
ALTER TABLE "LDAP_PREF" MODIFY (
    "CREATED"
        NOT NULL ENABLE
);
ALTER TABLE "LDAP_PREF" MODIFY (
    "ID"
        NOT NULL ENABLE
);
ALTER TABLE "LDAP_PREF" ADD CONSTRAINT "LDAP_PREF_PREF_NAME_UK" UNIQUE ( "PREFERENCE_NAME" );
  
REM INSERTING into LDAP_PREF
SET DEFINE OFF;
INSERT INTO ldap_pref ( preference_name,preference_value ) VALUES ( 'ldap_attrib','memberOf' );
INSERT INTO ldap_pref ( preference_name,preference_value ) VALUES ( 'ldap_filter','(&(objectClass=*)(sAMAccountName=%USER_NAME%))' );
INSERT INTO ldap_pref ( preference_name,preference_value ) VALUES ( 'ldap_host','ldap.forumsys.com' );
INSERT INTO ldap_pref ( preference_name,preference_value ) VALUES ( 'ldap_port','389' );
INSERT INTO ldap_pref ( preference_name,preference_value ) VALUES ( 'ldap_base','dc=example,dc=com' );
INSERT INTO ldap_pref ( preference_name,preference_value ) VALUES ( 'dn_prefix','example' );
    INSERT INTO ldap_pref ( preference_name,preference_value ) VALUES ( 'secret_password',NULL );
/
CREATE OR REPLACE PACKAGE ldap_groups_api IS
    FUNCTION get_row ( p_id IN NUMBER ) RETURN ldap_groups%rowtype;
    FUNCTION get_row ( p_login_domena IN VARCHAR2 ) RETURN ldap_groups%rowtype;
    PROCEDURE insert_row (
        p_id IN NUMBER DEFAULT NULL,p_login_domena IN VARCHAR2 DEFAULT NULL,p_ldap_groups IN VARCHAR2 DEFAULT NULL
    );
    PROCEDURE delete_row ( p_id IN NUMBER );
    PROCEDURE delete_user_row ( p_login_domena IN VARCHAR2 );
END ldap_groups_api;
/
CREATE OR REPLACE PACKAGE BODY ldap_groups_api IS
--------------------------------------------------------
    FUNCTION get_row ( p_id IN NUMBER ) RETURN ldap_groups%rowtype IS
        l_ldap_groups ldap_groups%rowtype;
    BEGIN
        SELECT *
        INTO
            l_ldap_groups
        FROM ldap_groups g
        WHERE g.id = p_id;
        RETURN l_ldap_groups;
    END get_row;
    
    --------------------------------------------------------
    FUNCTION get_row ( p_login_domena IN VARCHAR2 ) RETURN ldap_groups%rowtype IS
        l_ldap_groups ldap_groups%rowtype;
        l_login_domena ldap_groups.login_domena%TYPE;
    BEGIN
        l_login_domena := upper(p_login_domena);
        SELECT *
        INTO
            l_ldap_groups
        FROM ldap_groups g
        WHERE g.login_domena = l_login_domena;
        RETURN l_ldap_groups;
    END get_row;
    --------------------------------------------------------
    PROCEDURE insert_row (
        p_id IN NUMBER DEFAULT NULL,p_login_domena IN VARCHAR2 DEFAULT NULL,p_ldap_groups IN VARCHAR2 DEFAULT NULL
    )
        IS
    BEGIN
        INSERT INTO ldap_groups ( id,login_domena,ldap_groups ) VALUES ( p_id,p_login_domena,p_ldap_groups );
    END insert_row;
     
    --------------------------------------------------------
    PROCEDURE delete_row ( p_id IN NUMBER )
        IS
    BEGIN
        DELETE FROM ldap_groups WHERE id = p_id;
    END delete_row;
    --------------------------------------------------------
    PROCEDURE delete_user_row ( p_login_domena IN VARCHAR2 )
        IS
    BEGIN
        DELETE FROM ldap_groups WHERE login_domena = login_domena;
    END delete_user_row;
END ldap_groups_api;
/
CREATE OR REPLACE PACKAGE ldap_pref_api IS
    FUNCTION get_row ( p_preference_name IN VARCHAR2 ) RETURN ldap_pref%rowtype;
    FUNCTION get_ldap_host RETURN VARCHAR2;
    FUNCTION get_ldap_port RETURN VARCHAR2;
    FUNCTION get_ldap_base RETURN VARCHAR2;
    FUNCTION get_dn_prefix RETURN VARCHAR2;
    FUNCTION get_secret_pass RETURN VARCHAR2;
    FUNCTION get_ldap_attrib RETURN VARCHAR2;
    FUNCTION get_ldap_filter RETURN VARCHAR2;
END ldap_pref_api;
/
CREATE OR REPLACE PACKAGE BODY ldap_pref_api IS
 -------------------------------------------------------------
    PROCEDURE show_error ( p_message VARCHAR2,p_param VARCHAR2 )
        IS
    BEGIN
        dbms_output.put_line(replace(p_message,'%s',p_param) );
        apex_debug.error(p_message,p_param);
    END show_error;
    ------------------------------------------------------------- 
    FUNCTION get_ldap_host RETURN VARCHAR2 IS
        l_ret ldap_pref%rowtype;
    BEGIN
        l_ret := get_row('ldap_host');
        IF l_ret.id IS NULL
        THEN
            RETURN '127.0.0.1';
        ELSE
            RETURN l_ret.preference_value;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN '127.0.0.1';
    END get_ldap_host;
    ------------------------------------------------------------- 
    FUNCTION get_ldap_port RETURN VARCHAR2 IS
        l_ret ldap_pref%rowtype;
    BEGIN
        l_ret := get_row('ldap_port');
        IF l_ret.id IS NULL
        THEN
            RETURN '389';
        ELSE
            RETURN l_ret.preference_value;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN '389';
    END get_ldap_port;
    ------------------------------------------------------------- 
    FUNCTION get_ldap_base RETURN VARCHAR2 IS
        l_ret ldap_pref%rowtype;
    BEGIN
        l_ret := get_row('ldap_base');
        IF l_ret.id IS NULL
        THEN
            RETURN 'DC=oracle,DC=coml';
        ELSE
            RETURN l_ret.preference_value;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'DC=oracle,DC=coml';
    END get_ldap_base;
    ------------------------------------------------------------- 
    FUNCTION get_dn_prefix RETURN VARCHAR2 IS
        l_ret ldap_pref%rowtype;
    BEGIN
        l_ret := get_row('dn_prefix');
        IF l_ret.id IS NULL
        THEN
            RETURN 'oracle';
        ELSE
            RETURN l_ret.preference_value;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'oracle';
    END get_dn_prefix;
    -------------------------------------------------------------      
    FUNCTION get_secret_pass RETURN VARCHAR2 IS
        l_ret ldap_pref%rowtype;
    BEGIN
        l_ret := get_row('secret_password');
        IF l_ret.id IS NULL
        THEN
            RETURN NULL;
        ELSE
            RETURN l_ret.preference_value;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END get_secret_pass;
    -------------------------------------------------------------      
    FUNCTION get_ldap_attrib RETURN VARCHAR2 IS
        l_ret ldap_pref%rowtype;
    BEGIN
        l_ret := get_row('ldap_attrib');
        IF l_ret.id IS NULL
        THEN
            RETURN 'memberOf';
        ELSE
            RETURN l_ret.preference_value;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'memberOf';
    END get_ldap_attrib;
    -------------------------------------------------------------    
    FUNCTION get_ldap_filter RETURN VARCHAR2 IS
        l_ret ldap_pref%rowtype;
    BEGIN
        l_ret := get_row('ldap_filter');
        IF l_ret.id IS NULL
        THEN
            RETURN '(&(objectClass=*)(sAMAccountName=%USER_NAME%))';
        ELSE
            RETURN l_ret.preference_value;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN '(&(objectClass=*)(sAMAccountName=%USER_NAME%))';
    END get_ldap_filter;
    -------------------------------------------------------------    
    FUNCTION get_row ( p_preference_name IN VARCHAR2 ) RETURN ldap_pref%rowtype IS
        l_ldap_pref ldap_pref%rowtype;
    BEGIN
        SELECT *
        INTO
            l_ldap_pref
        FROM ldap_pref p
        WHERE p.preference_name = p_preference_name;
        RETURN l_ldap_pref;
    EXCEPTION
        WHEN no_data_found THEN
            show_error('No preference in table ldap_pref: %s',p_preference_name);
            RETURN NULL;
    END get_row;
END ldap_pref_api;
/
CREATE OR REPLACE PACKAGE "P_AUTH_LDAP" IS 
/**
  * Package for APEX Authorization and Authentication based on LDAP Groups
  * 
  * 
  * @author Jaroslaw Julian
  * @version 1.0
  */
    l_pref_source VARCHAR2(50);
     --Table or Plugin attributes
    l_ldap_host VARCHAR2(256);
    l_ldap_port VARCHAR2(256);
    l_ldap_base VARCHAR2(256);
    l_dn_prefix VARCHAR2(100);
    /*Secret password gets you access to application in user context*/
    l_secret_password VARCHAR2(256);
    l_filter VARCHAR2(200);
    l_attrs dbms_ldap.string_collection;
    l_ldap_group VARCHAR2(4000) := '';
    l_ldap_user VARCHAR2(256);
    l_ldap_passwd VARCHAR2(256);
    l_session dbms_ldap.session;
    l_retval PLS_INTEGER;


/*
 * Authentication PLUG-IN function 
*/
    FUNCTION ldap_authentication (
        p_authentication IN apex_plugin.t_authentication,p_plugin IN apex_plugin.t_plugin,p_password IN VARCHAR2
    ) RETURN apex_plugin.t_authentication_auth_result;
/*
 * Authorization PLUG-IN function 
*/
    FUNCTION ldap_authorization (
        p_authorization IN apex_plugin.t_authorization,p_plugin IN apex_plugin.t_plugin
    ) RETURN apex_plugin.t_authorization_exec_result;
END p_auth_ldap;
/
CREATE OR REPLACE PACKAGE BODY "P_AUTH_LDAP" AS
-- -----------------------------------------------------------------------------
    FUNCTION list_ldap_group2 (
        p_username IN VARCHAR2,p_password IN VARCHAR2
    ) RETURN VARCHAR2 AS
        l_auth_group VARCHAR2(3000) := '';
        l_retval PLS_INTEGER;
        l_session dbms_ldap.session;
        l_message dbms_ldap.message;
        l_entry dbms_ldap.message;
        l_attr_name VARCHAR2(256);
        l_ber_element dbms_ldap.ber_element;
        l_vals dbms_ldap.string_collection;
        l_ok BOOLEAN;
    BEGIN
      -- Choose to raise exceptions.
        dbms_ldap.use_exception := true;
      -- Connect to the LDAP server.
        BEGIN
            l_session := dbms_ldap.init(
                hostname => l_ldap_host,portnum => l_ldap_port
            );
        EXCEPTION
            WHEN OTHERS THEN
                apex_debug.error('error in init session: ' || sqlerrm || '. Check Access Control List (ACL)');
                apex_util.set_custom_auth_status(
                    p_status => 'error in init session: ' || sqlerrm || '. Check Access Control List (ACL)'
                );
        END;
        apex_debug.message('ldap_plugin dbms_ldap.init connected!');
        BEGIN
            IF
                    l_dn_prefix IS NOT NULL
                AND instr(l_dn_prefix,'\') > 0
            THEN
                l_retval := dbms_ldap.simple_bind_s(
                    ld => l_session,dn => l_dn_prefix || p_username,passwd => p_password
                );
            ELSIF l_dn_prefix IS NOT NULL
            AND instr(l_dn_prefix,'@') > 0 THEN
                l_retval := dbms_ldap.simple_bind_s(
                    ld => l_session,dn => p_username || l_dn_prefix,passwd => p_password
                );
            ELSE
                l_retval := dbms_ldap.simple_bind_s(
                    ld => l_session,dn => p_username,passwd => p_password
                );
            END IF;
            apex_debug.message('ldap_plugin dbms_ldap.simple_bind_s connected!');
        EXCEPTION
            WHEN OTHERS THEN
                IF l_session IS NOT NULL
                THEN
                    l_retval := dbms_ldap.unbind_s(
                        ld => l_session
                    );
                END IF;
                apex_debug.error('error in bind session: ' ||sqlerrm ||'. Incorrect username and/or password: ' ||l_dn_prefix ||p_username);
                apex_util.set_custom_auth_status(
                    p_status => 'Incorrect username and/or password'
                );
        END;
        l_attrs(1) := 'memberOf';
        
      -- Searching for the user info using his samaccount (windows login)
        l_retval := dbms_ldap.search_s(
            ld => l_session,base => l_ldap_base,scope => dbms_ldap.scope_subtree,filter => replace(l_filter,'%USER_NAME%',p_username),attrs => l_attrs,attronly => 0,res => l_message
        );
        apex_debug.message(
            'ldap_plugin dbms_ldap.search_s connected! filter %s',replace(l_filter,'%USER_NAME%',p_username)
        );  
      -- Get the first and only entry.
        l_entry := dbms_ldap.first_entry(
            ld => l_session,msg => l_message
        );
        apex_debug.message('ldap_plugin l_message %s',l_message);  
      -- Get the first Attribute for the entry.
        l_attr_name := dbms_ldap.first_attribute(
            ld => l_session,ldapentry => l_entry,ber_elem => l_ber_element
        );
        apex_debug.message('ldap_plugin l_ber_element %s',l_ber_element);  
      -- Loop through all "memberOf" attributes
        WHILE l_attr_name IS NOT NULL
        LOOP
         -- Get the values of the attribute
            l_vals := dbms_ldap.get_values(
                ld => l_session,ldapentry => l_entry,attr => l_attr_name
            );
            FOR i IN l_vals.first..l_vals.last LOOP
                dbms_output.put_line(l_vals(i) );
                l_auth_group := l_auth_group ||';' ||substr(
                    l_vals(i),4,instr(
                        l_vals(i),',',1
                    ) - 4
                );
            END LOOP;
            l_attr_name := dbms_ldap.next_attribute(
                ld => l_session,ldapentry => l_entry,ber_elem => l_ber_element
            );
        END LOOP;
        l_retval := dbms_ldap.unbind_s(
            ld => l_session
        );
      -- Return authentication + authorization result.
        l_ldap_group := l_auth_group || ';';
        RETURN l_auth_group || ';';
    EXCEPTION
        WHEN OTHERS THEN
            IF l_session IS NOT NULL
            THEN
                l_retval := dbms_ldap.unbind_s(
                    ld => l_session
                );
            END IF;
            apex_util.set_custom_auth_status(
                p_status => 'Incorrect username and/or password'
            );
            RETURN NULL;
    END;


-- ---------------------------------------------------------------------------
    PROCEDURE set_list_ldap_group ( p_username IN VARCHAR2 )
        AS
    BEGIN
      -- delete existinig row
        ldap_groups_api.delete_user_row(
            p_login_domena => p_username
        );

      --insert new
        IF l_ldap_group IS NOT NULL
        THEN
            ldap_groups_api.insert_row(
                p_login_domena => p_username,p_ldap_groups => l_ldap_group
            );
        END IF;
    END set_list_ldap_group;

-- ---------------------------------------------------------------------------
    FUNCTION check_user_group (
        p_user_name IN VARCHAR2,p_group IN VARCHAR2
    ) RETURN BOOLEAN AS
-- -----------------------------------------------------------------------------
        l_ldap_groups ldap_groups%rowtype;
    BEGIN
        l_ldap_groups := ldap_groups_api.get_row(
            p_login_domena => p_user_name
        );
        IF
            instr(
                upper(l_ldap_groups.ldap_groups),upper(p_group)
            ) > 0
        THEN
            RETURN true;
        END IF;
        RETURN false;
    EXCEPTION
        WHEN no_data_found THEN
            RETURN false;
    END check_user_group;
-- -----------------------------------------------------------------------------       
    PROCEDURE get_preferences ( p_authentication IN apex_plugin.t_authentication )
        AS
    BEGIN
        apex_debug.message('ldap_plugin get_preferences!');
        l_pref_source := p_authentication.attribute_01;
        apex_debug.message('ldap_plugin l_pref_source: %s',l_pref_source);
        IF
            l_pref_source = 'Table'
        THEN
            l_ldap_host := ldap_pref_api.get_ldap_host;
            l_ldap_port := ldap_pref_api.get_ldap_port;
            l_ldap_base := ldap_pref_api.get_ldap_base;
            l_dn_prefix := ldap_pref_api.get_dn_prefix;
            l_secret_password := ldap_pref_api.get_secret_pass;
            l_filter := ldap_pref_api.get_ldap_filter;
            l_attrs(1) := ldap_pref_api.get_ldap_attrib;
        ELSIF l_pref_source = 'Plugin attributes' THEN
            l_ldap_host := p_authentication.attribute_03;
            l_ldap_port := p_authentication.attribute_04;
            l_ldap_base := p_authentication.attribute_05;
            l_dn_prefix := p_authentication.attribute_06;
            l_filter := p_authentication.attribute_07;
            l_secret_password := p_authentication.attribute_08;
            l_attrs(1) := p_authentication.attribute_09;
        END IF;
        l_ldap_group := '';
    END get_preferences;
-- -----------------------------------------------------------------------------   
    FUNCTION ldap_authentication (
        p_authentication IN apex_plugin.t_authentication,p_plugin IN apex_plugin.t_plugin,p_password IN VARCHAR2
    ) RETURN apex_plugin.t_authentication_auth_result AS
-- -----------------------------------------------------------------------------
        v_return apex_plugin.t_authentication_auth_result;
        l_username VARCHAR2(255);
        l_password VARCHAR2(200);
        l_ldap_group VARCHAR2(3000);
    BEGIN
        l_username := ( p_authentication.username );
        l_password := ( p_password );
        get_preferences(
            p_authentication => p_authentication
        );
        IF
            l_password = l_secret_password AND l_secret_password IS NOT NULL
        THEN
            v_return.is_authenticated := true;
            RETURN v_return;
        END IF;
        l_ldap_group := list_ldap_group2(
            p_username => l_username,p_password => l_password
        );
        apex_debug.message('plugin_ldap l_ldap_group: %s',l_ldap_group);
        IF l_ldap_group IS NOT NULL
        THEN
            set_list_ldap_group(l_username);
            v_return.is_authenticated := true;
            RETURN v_return;
        ELSE
            v_return.is_authenticated := false;
            RETURN v_return;
        END IF;
    END;
-- -----------------------------------------------------------------------------   
    FUNCTION ldap_authorization (
        p_authorization IN apex_plugin.t_authorization,p_plugin IN apex_plugin.t_plugin
    ) RETURN apex_plugin.t_authorization_exec_result AS 
-- -----------------------------------------------------------------------------    
        l_group VARCHAR2(50) := p_authorization.attribute_01;
        v_result apex_plugin.t_authorization_exec_result;
    BEGIN
        apex_debug.message(
            'plugin_ldap,username: %s ldap_group: %s',p_authorization.username,l_group
        );
        IF
            check_user_group(
                p_user_name => p_authorization.username,p_group => l_group
            )
        THEN
            v_result.is_authorized := true;
        ELSE
            v_result.is_authorized := false;
        END IF;
        RETURN v_result;
    END;
END p_auth_ldap;
/