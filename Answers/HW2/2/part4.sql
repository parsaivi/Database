
CREATE TABLE IF NOT EXISTS core_membership (
    id SERIAL PRIMARY KEY,
    role VARCHAR(1),
    status VARCHAR(1),
    challenger_id BIGINT REFERENCES core_challenger(id),
    group_id BIGINT REFERENCES core_group(id)
);
