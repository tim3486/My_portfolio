-- Создаем таблицу с типами
CREATE TABLE species_type ( 
    type_id       INTEGER PRIMARY KEY,
    type_name     VARCHAR NOT NULL
);

-- Создаем таблицу с видами
CREATE TABLE species( 
    species_id       INTEGER PRIMARY KEY,
    type_id          INTEGER,
    species_name     VARCHAR NOT NULL,
    species_amount   INTEGER,
    date_start       DATE,
	  species_status varchar(100) NOT NULL DEFAULT 'active'::character varying,
    CONSTRAINT species_status_check CHECK (((species_status)::text = ANY (ARRAY[('active'::character varying)::text, ('absent'::character varying)::text, ('fairy'::character varying)::text])))
);

-- Создаем таблицу с местами 
CREATE TABLE places ( 
    place_id       INTEGER PRIMARY KEY,
    place_name     VARCHAR NOT NULL,
    place_size     NUMERIC(10,2),
    place_date_start  TIMESTAMP NOT NULL DEFAULT CURRENT_DATE
);

-- Создаем таблицу с распределением видов по местам
CREATE TABLE species_in_places ( 
    place_id      INTEGER,
    species_id     INTEGER,
    PRIMARY KEY (place_id, species_id)
);

commit;

-- Создаем связи между таблицами

ALTER TABLE species ADD CONSTRAINT type_id_fkey FOREIGN KEY (type_id) REFERENCES species_type(type_id);
ALTER TABLE species_in_places ADD CONSTRAINT place_id_fkey FOREIGN KEY (place_id) REFERENCES places(place_id);
ALTER TABLE species_in_places ADD CONSTRAINT species_id_fkey FOREIGN KEY (species_id) REFERENCES species(species_id);