
CREATE TABLE IF NOT EXISTS core_group (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    level VARCHAR(1),
    judge_password TEXT,
    judge_username TEXT
);
