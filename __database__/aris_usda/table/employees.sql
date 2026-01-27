CREATE TABLE employees (
    id          NUMBER PRIMARY KEY,
    name        VARCHAR2(100) NOT NULL,
    email       VARCHAR2(255),
    department  VARCHAR2(50),
    status      VARCHAR2(20) DEFAULT 'ACTIVE'
);
