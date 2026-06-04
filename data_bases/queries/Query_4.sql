-- 1. Удаляем старые таблицы (ОСТОРОЖНО: все данные будут стерты)
DROP TABLE IF EXISTS attachments;
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS categories;

-- 2. Таблица категорий
CREATE TABLE categories (
                            id UUID PRIMARY KEY,
                            name TEXT NOT NULL UNIQUE,
                            color VARCHAR(16) NOT NULL,
                            is_default BOOLEAN NOT NULL DEFAULT FALSE,
                            created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                            updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. Таблица задач
CREATE TABLE tasks (
                       id UUID PRIMARY KEY,
                       parent_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
                       title TEXT NOT NULL,
                       priority VARCHAR(20) DEFAULT 'medium',
                       category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
                       is_completed BOOLEAN NOT NULL DEFAULT FALSE,
                       is_pinned BOOLEAN NOT NULL DEFAULT FALSE,
                       is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
                       deadline TIMESTAMPTZ,
                       created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                       updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. Таблица файлов
CREATE TABLE attachments (
                             id UUID PRIMARY KEY,
                             task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
                             file_name TEXT NOT NULL,
                             file_path TEXT NOT NULL,
                             file_size BIGINT NOT NULL,
                             uploaded_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 5. Индексы
CREATE INDEX idx_tasks_parent_id ON tasks(parent_id);
CREATE INDEX idx_tasks_is_deleted ON tasks(is_deleted);
CREATE INDEX idx_tasks_is_pinned ON tasks(is_pinned);
CREATE INDEX idx_tasks_deadline ON tasks(deadline);

-- 6. Дефолтная категория (ID должен совпадать с Flutter)
INSERT INTO categories (id, name, color, is_default)
VALUES ('00000000-0000-0000-0000-000000000000', 'Общие', '#9E9E9E', TRUE);