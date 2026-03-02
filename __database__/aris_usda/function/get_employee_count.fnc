CREATE OR REPLACE FUNCTION get_employee_count(
    p_department IN VARCHAR2 DEFAULT NULL
) RETURN NUMBER AS
    l_count1 NUMBER;
BEGIN
    SELECT COUNT(*) INTO l_count1 FROM employees
    WHERE (p_department IS NULL OR department = p_department);
    RETURN l_count;
END get_employee_count;
/
