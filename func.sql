CREATE OR REPLACE PROCEDURE Station_coordinates(
    IN _id_station  INTEGER,
    IN _date    DATE,
    IN _longitude   FLOAT,
    IN _latitude    FLOAT,
    IN _longitude_str   VARCHAR(16),
    IN _latitude_str    VARCHAR(16)
)LANGUAGE plpgsql
AS $$
DECLARE
BEGIN
    INSERT INTO Station_coordinates(
        id_station,
        date,
        longitude_and_latitude
    )
    VALUES(
        _id_station,
        _date,
        CONCAT(
            CONCAT(
                CONCAT(
                    CONCAT(
                        'SRID=4326;POINT(', 
                        _longitude_str
                        ),
                    ' '
                    ),
                _latitude_str
            ),
            ')'
        )
    );
    RAISE EXCEPTION 'Well Done';
END;
$$;


create index on Station_coordinates using gist (longitude_and_latitude);