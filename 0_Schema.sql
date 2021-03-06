DROP DATABASE IF EXISTS isuumo;
CREATE DATABASE isuumo DEFAULT CHARACTER SET utf8mb4;

DROP TABLE IF EXISTS isuumo.estate;
DROP TABLE IF EXISTS isuumo.chair;

CREATE TABLE isuumo.estate
(
    id          INTEGER             NOT NULL PRIMARY KEY,
    name        VARCHAR(64)         NOT NULL,
    description VARCHAR(4096)       NOT NULL,
    thumbnail   VARCHAR(128)        NOT NULL,
    address     VARCHAR(128)        NOT NULL,
    latitude    DOUBLE PRECISION    NOT NULL,
    longitude   DOUBLE PRECISION    NOT NULL,
    rent        INTEGER             NOT NULL,
    door_height INTEGER             NOT NULL,
    door_width  INTEGER             NOT NULL,
    features    VARCHAR(64)         NOT NULL,
    popularity  INTEGER             NOT NULL
);

CREATE TABLE isuumo.chair
(
    id          INTEGER         NOT NULL PRIMARY KEY,
    name        VARCHAR(64)     NOT NULL,
    description VARCHAR(4096)   NOT NULL,
    thumbnail   VARCHAR(128)    NOT NULL,
    price       INTEGER         NOT NULL,
    height      INTEGER         NOT NULL,
    width       INTEGER         NOT NULL,
    depth       INTEGER         NOT NULL,
    color       VARCHAR(64)     NOT NULL,
    features    VARCHAR(64)     NOT NULL,
    kind        VARCHAR(64)     NOT NULL,
    popularity  INTEGER         NOT NULL,
    stock       INTEGER         NOT NULL
);

use isuumo;
CREATE INDEX char_price_id ON chair (price, id);
create index estate_rent_id on estate (rent, id);
create index estate_rect on estate (rent);
create index estate_popularity_desc on estate (popularity desc);
CREATE INDEX estate_latitude on estate (latitude);
CREATE INDEX estate_longitude on estate (longitude);
CREATE INDEX estate_height on estate (door_height);
CREATE INDEX estate_width on estate (door_width);
create index estate_popularity_desc_id on estate (popularity desc, id);
create index chair_popularity_desc_id on chair (popularity desc, id);
