
CREATE TABLE IF NOT EXISTS core_challenger (
    id SERIAL PRIMARY KEY,
    first_name_persian VARCHAR(50),
    last_name_persian VARCHAR(50),
    phone_number VARCHAR(11),
    gender VARCHAR(1),
    status VARCHAR(1),
    is_confirmed BOOLEAN,
    shirt_size VARCHAR(4),
    user_id INTEGER REFERENCES auth_user(id)
);
