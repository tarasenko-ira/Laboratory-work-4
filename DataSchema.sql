DROP TABLE IF EXISTS t_publication CASCADE;
DROP TABLE IF EXISTS t_literary_work CASCADE;
DROP TABLE IF EXISTS t_interactive_tools CASCADE;
DROP TABLE IF EXISTS t_user CASCADE;

CREATE TABLE t_user (
    user_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    status VARCHAR(10) CHECK (status IN ('active', 'guest'))
);

CREATE TABLE t_literary_work (
    work_id INT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    creation_date DATE CHECK (creation_date >= DATE '1900-01-01'),
    status VARCHAR(10) CHECK (status IN ('draft', 'published')),
    user_id INT,
    tool_id INT,
    FOREIGN KEY (user_id) REFERENCES t_user (user_id) ON DELETE SET NULL,
    FOREIGN KEY (tool_id) REFERENCES t_interactive_tools (tool_id)
    ON DELETE SET NULL
);

CREATE TABLE t_interactive_tools (
    tool_id INT PRIMARY KEY,
    tool_type VARCHAR(30) CHECK (tool_type IN ('редактор', 'форматування')),
    real_time_availability BOOLEAN
);

CREATE TABLE t_publication (
    publication_id INT PRIMARY KEY,
    publication_date DATE CHECK (publication_date >= DATE '1900-01-01'),
    platform VARCHAR(50) CHECK
    (platform IN ('соціальні мережі', 'внутрішня система')),
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES t_user (user_id) ON DELETE SET NULL
);

/* Обмеження цілісності для текстових
атрибутів з використанням регулярних виразів */
ALTER TABLE t_user
ADD CONSTRAINT user_name_pattern
CHECK (REGEXP_LIKE(name, '^[A-Za-zА-Яа-я ]+$'));

ALTER TABLE t_literary_work
ADD CONSTRAINT work_title_pattern
CHECK (REGEXP_LIKE(title, '^[A-Za-zА-Яа-я0-9 ,.!?]+$'));
