CREATE OR REPLACE PACKAGE pkg_utils AS
    FUNCTION get_current_user RETURN VARCHAR2;
    PROCEDURE log_activity(p_action VARCHAR2, p_details VARCHAR2);
END pkg_utils;
/
