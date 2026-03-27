CREATE OR REPLACE FUNCTION search_employees(
    p_name       VARCHAR2 DEFAULT NULL,
    p_department VARCHAR2 DEFAULT NULL
) RETURN SYS_REFCURSOR AS
    l_cursor SYS_REFCURSOR;
BEGIN
    OPEN l_cursor FOR
        SELECT employee_id, first_name, last_name, department_id
        FROM employees
        WHERE (p_name IS NULL 
               OR UPPER(first_name || ' ' || last_name) 
               LIKE '%' || UPPER(p_name) || '%')
          AND (p_department IS NULL 
               OR department_id = p_department);
    RETURN l_cursor;
END search_employees;
/
