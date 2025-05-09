
CREATE TABLE IF NOT EXISTS auth_user (
    id SERIAL PRIMARY KEY,
    username VARCHAR(150),
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    email VARCHAR(254),
    date_joined TIMESTAMP
);
