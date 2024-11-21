
CREATE TYPE character_type AS ENUM ('hero', 'villain', 'antihero');


CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL
);


CREATE TABLE comics (
    id SERIAL PRIMARY KEY,
    title VARCHAR NOT NULL,
    description VARCHAR,
    price NUMERIC NOT NULL,
    category INT REFERENCES categories(id)
);


CREATE TABLE characters (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    type character_type NOT NULL,
    defeats INT DEFAULT 0,
    groupId INT REFERENCES groups(id)
);


CREATE TABLE sidekicks (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    description VARCHAR
);


CREATE TABLE weapons (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    description VARCHAR,
    availability INT DEFAULT 0
);


CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    dob DATE NOT NULL,
    email VARCHAR UNIQUE NOT NULL
);


CREATE TABLE transactions (
    comicId INT REFERENCES comics(id),
    customerId INT REFERENCES customers(id),
    purchaseDate DATE NOT NULL,
    totalAmount NUMERIC NOT NULL,
    PRIMARY KEY (comicId, customerId)
);

CREATE TABLE groups (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL
);


CREATE TABLE characterxpower (
    characterId INT REFERENCES characters(id),
    powerId INT REFERENCES powers(id),
    PRIMARY KEY (characterId, powerId)
);


CREATE TABLE characterxweakness (
    characterId INT REFERENCES characters(id),
    weaknessId INT REFERENCES weaknesses(id),
    PRIMARY KEY (characterId, weaknessId)
);


CREATE TABLE powers (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL
);


CREATE TABLE weaknesses (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL
);

CREATE TABLE comicsxcharacter (
    characterId INT REFERENCES characters(id),
    comicId INT REFERENCES comics(id),
    PRIMARY KEY (characterId, comicId)
);


CREATE TABLE special_offers(
                              id SERIAL PRIMARY KEY,
                              usuario_id INT NOT NULL,
                              date TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION special_comic_offer() RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT title FROM comics WHERE id = NEW.comicId) = 'Superman en Calzoncillos con Batman Asustado' THEN
        INSERT INTO special_offers (usuario_id) VALUES (NEW.customerId);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER special_comic_offer_trigger
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION special_comic_offer();

INSERT INTO categories (name) VALUES
    ('Horror'),
    ('Drama'),
    ('Science Fiction'),
    ('Fantasy'),
    ('Romance'),
    ('Action');


INSERT INTO comics (title, description, price, category) VALUES
    ('Legends Reborn', 'The rebirth of legendary heroes in a modern world.', 11.25, 3),
    ('The Rise of Heroes', 'An epic story of good versus evil.', 9.99, 2),
    ('Battle of the Titans', 'The ultimate showdown between titanic forces.', 10.0, 4),
    ('Tales of the Mystic', 'Mystical tales filled with wonder and danger.', 8.5, 6),
    ('Enchanted Realms', 'A journey through magical realms and enchanted lands.', 7.99, 1),
    ('The Last Stand', 'The final stand of Earths greatest protectors.', 16.99, 3);


INSERT INTO groups (name) VALUES
    ('X-Men'),
    ('Legion of Super-Heroes'),
    ('Fantastic Four'),
    ('Guardians of the Galaxy'),
    ('Suicide Squad'),
    ('Justice League');

INSERT INTO characters (name, type, defeats, groupId) VALUES
    ('Superman', 'hero', 50, 6),
    ('Black Widow', 'hero', 45, 3),
    ('Joker', 'villain', 18, 5),
    ('Groot', 'hero', 19, 4),
    ('Thanos', 'villain', 48, 2),
    ('Wonder Woman', 'hero', 45, 1);

INSERT INTO powers (name) VALUES
    ('Enhanced Senses'),
    ('Regeneration'),
    ('Flight'),
    ('Time Manipulation'),
    ('Shape-shifting'),
    ('Mind Control');

INSERT INTO characterxpower (characterId, powerId) VALUES
    (1, 3),
    (6, 1),
    (2, 6),
    (3, 2),
    (4, 5),
    (5, 4);

INSERT INTO weaknesses (name) VALUES
    ('Electricity'),
    ('Fire'),
    ('Sound Waves'),
    ('Overconfidence'),
    ('Magic'),
    ('Lack of Oxygen');

INSERT INTO characterxweakness (characterId, weaknessId) VALUES
    (2, 2),
    (5, 6),
    (4, 3),
    (1, 4),
    (2, 1),
    (5, 3);

INSERT INTO comicsxcharacter (comicId, characterId) VALUES
    (6, 1),
    (3, 4),
    (6, 3),
    (3, 1),
    (5, 5),
    (5, 6);

INSERT INTO customers (name, dob, email) VALUES
    ('John Doe', '1994-06-01', 'john.doe@example.com'),
    ('Jane Smith', '1979-05-13', 'jane.smith@example.com'),
    ('Emily Davis', '1984-03-06', 'emily.davis@example.com'),
    ('Michael Wilson', '1979-08-12', 'michael.wilson@example.com'),
    ('Robert Brown', '1975-12-18', 'robert.brown@example.com'),
    ('Alice Johnson', '1995-06-06', 'alice.johnson@example.com');

INSERT INTO sidekicks (name, description) VALUES
    ('Jubilee', 'A mutant with unique and dazzling powers.'),
    ('Robin', 'The loyal partner of a hero.'),
    ('Falcon', 'A skilled fighter with high-tech gear.'),
    ('Hit-Girl', 'A young and fearless vigilante.'),
    ('Wasp', 'A small but powerful ally with a big heart.'),
    ('Harley Quinn', 'A former villain turned sidekick.');

INSERT INTO transactions (comicId, customerId, purchaseDate, totalAmount) VALUES
    (2, 4, '2024-11-01', 17.6),
    (4, 3, '2024-11-13', 5.3),
    (4, 2, '2024-11-18', 11.52),
    (6, 6, '2024-11-16', 16.88),
    (2, 5, '2024-11-20', 13.69),
    (3, 5, '2024-11-20', 7.33);

INSERT INTO weapons (name, description, availability) VALUES
    ('Infinity Gauntlet', 'A gauntlet with infinite power stones.', 57),
    ('Plasma Cannon', 'A heavy weapon capable of devastating blasts.', 67),
    ('Lasso of Truth', 'A magical lasso that compels truth-telling.', 54),
    ('Photon Blasters', 'Blasters emitting high-energy photon beams.', 29),
    ('Energy Sword', 'A futuristic sword powered by energy.', 63),
    ('Shield of Justice', 'A shield that symbolizes justice and protection.', 32);



--POSTGRES
SELECT title, price, category
FROM comics WHERE price < 10 ORDER BY title;

SELECT characters.name AS hero_name, powers.name AS power_name
FROM characters
JOIN characterxpower cp ON characters.id = cp.characterId
JOIN powers ON cp.powerId = powers.id
WHERE powers.name ILIKE 'flight'
ORDER BY characters.name;


SELECT name AS villain_name, defeats
FROM characters
WHERE type = 'villain' AND defeats > 3
ORDER BY defeats DESC;

--more than 1 comic
SELECT
    c.name AS customName,
    COUNT(transactions.comicId) AS number,
    SUM(transactions.totalAmount) AS total
FROM
    transactions
JOIN customers c on transactions.customerId = c.id
GROUP BY c.id, c.name
HAVING COUNT(transactions.comicId) > 1
ORDER BY
    total DESC;


SELECT
    categories.name AS category_name,
    COUNT(transactions.comicId) AS purchase_count
FROM
    transactions
JOIN
    comics ON transactions.comicId = comics.id
JOIN
    categories ON comics.category = categories.id
GROUP BY
    categories.id, categories.name
ORDER BY
    purchase_count DESC
LIMIT 2;





SELECT comics.title
FROM comics
JOIN categories ON comics.category = categories.id
JOIN comicsxcharacter ON comics.id = comicsxcharacter.comicId
JOIN characters ON comicsxcharacter.characterId = characters.id
JOIN weapons ON characters.id = weapons.characterId
WHERE categories.name = 'Epic hero-villain battles'
  AND weapons.name = 'Energy Sword';



CREATE OR REPLACE VIEW Popular_Comics AS
SELECT
    c.id AS comic_id,
    c.title AS comic_title,
    COUNT(t.comicId) AS total_purchases
FROM comics c
JOIN transactions t ON c.id = t.comicId
GROUP BY c.id, c.title
HAVING COUNT(t.comicId) > 1;

CREATE MATERIALIZED VIEW Top_Customers AS
SELECT
    c.id AS customer_id,
    c.name AS customer_name,
    COUNT(t.comicId) AS total_purchases,
    SUM(t.totalAmount) AS total_spent
FROM customers c
JOIN transactions t ON c.id = t.customerId
GROUP BY c.id, c.name
HAVING COUNT(t.comicId) > 1;











