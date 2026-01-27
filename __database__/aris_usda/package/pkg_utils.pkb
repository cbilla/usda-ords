CREATE OR REPLACE PACKAGE BODY pkg_utils AS
    FUNCTION get_current_user RETURN VARCHAR2 IS
    BEGIN
        RETURN NVL(V('APP_USER'), USER);
    END get_current_user;
    
    PROCEDURE log_activity(p_action VARCHAR2, p_details VARCHAR2) IS
    BEGIN
        INSERT INTO activity_log (action, details, created_by, created_on)
        VALUES (p_action, p_details, get_current_user, SYSTIMESTAMP);
    END log_activity;
END pkg_utils;
/
