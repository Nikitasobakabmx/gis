CREATE EXTENSION postgis;

-- WATER AREA
-- WATER AREA --< STATION   ++
CREATE TABLE IF NOT EXISTS Water_area(
    id_water_area   SERIAL  PRIMARY KEY,
    NAME            VARCHAR(128)  
);

-- STATION
-- WATER AREA --< STATION ++
CREATE TABLE IF NOT EXISTS Station(
    id_Station      SERIAL  PRIMARY KEY,
    
    id_water_area   INTEGER NOT NULL,
    FOREIGN KEY (id_water_area) REFERENCES water_area(id_water_area),
    
    name            VARCHAR(84),
    serial_number   INTEGER
);

-- STATION COORDINATES
--   STATION COORDINATES >-- STATION ++
CREATE TABLE IF NOT EXISTS Station_coordinates(
    id_station_coord    SERIAL  PRIMARY KEY,

    id_station          INTEGER NOT NULL,
    FOREIGN KEY (id_station) REFERENCES Station(id_station),

    date                DATE,
    longitude_and_latitude  geography
);

-- SAMPLES
-- STATION --< SAMPLES ++
-- MICROFLORA SEDIMENT SAMPLES >-- SAMPLES  ++
-- PHYSICAL PROPERTIES >--SAMPLES   ++
-- HYDROCHEMICAL SAMPLES >-- SAMPLES    ++
-- ZOOBENTHOS SAMPLES >-- SAMPLES   ++
-- METEO SAMPLES >-- SAMPLES
-- ZOOPLANKTON SAMPLES >-- SAMPLES
-- PHYTOPLANKTON SAMPLES >-- SaMPLES
-- PHYTOSYNTHETIC PIGMENTS SAMPLES >-- SAMPLES
-- HORIZON LEVELS >-< SAMPLES   ++
CREATE TABLE IF NOT EXISTS Samples(
    id_sample       SERIAL PRIMARY KEY,

    id_station      INTEGER NOT NULL,
    FOREIGN KEY (id_station) REFERENCES Station(id_station),

    date            TIMESTAMP,
    comment         VARCHAR(128),
    serial_number   VARCHAR(32)
);

-- MICROFLORA SEDIMENT SAMPLES
-- SAMPLES --< MICROFLORA SEDIMENT SAMPLES  ++
-- MICROFLORA SEDIMENT SAMPLES >-< GROUND TYPE  ++
CREATE TABLE IF NOT EXISTS Microflora_sediment_samples(
    id_sediment_sample  SERIAL PRIMARY KEY,

    id_sample           INTEGER NOT NULL,
    FOREIGN KEY (id_sample) REFERENCES Samples(id_sample),
    
    total               INTEGER,
    biomass_wet_weight  FLOAT,
    heterotrophs_RPA    FLOAT,
    ration_of_total_to_biomass  FLOAT
);

-- GROUND TYPE
-- MICROFLORA SEDIMENT SAMPLES >-< GROUND TYPE  ++
-- GROUND TYPE >-< PHYSICAL PROPERTIES  ++
CREATE TABLE IF NOT EXISTS Ground_type(
    id_ground_type  SERIAL PRIMARY KEY,
    name    VARCHAR(128) NOT NULL
);

-- PHYSICAL PROPERTIES
-- GROUND TYPE >-< PHYSICAL PROPERTIES  ++
-- PHYSICAL PROPERTIES >-< HORIZON LEVELS   ++
-- PHYSICAL PROPERTIES >-- SaMPLES  ++
CREATE TABLE IF NOT EXISTS Physical_properties(
    id_physical_prop    SERIAL PRIMARY KEY,

    id_sample           INTEGER NOT NULL,
    FOREIGN KEY (id_sample) REFERENCES Samples(id_sample),

    max_depth           FLOAT,
    bansperency         FLOAT,
    comment             VARCHAR(128)
);

-- GROUND TYPE IN HYDROLOGY SAMPLE
-- GROUND TYPE >-< PHYSICAL PROPERTIES  ++
CREATE TABLE IF NOT EXISTS Ground_type_in_hydrology_sample(
    id_ground_type  INTEGER NOT NULL,
    FOREIGN KEY (id_ground_type) REFERENCES Ground_type(id_ground_type),

    id_physical_prop    INTEGER NOT NULL,
    FOREIGN KEY (id_physical_prop) REFERENCES Physical_properties(id_physical_prop)
);

-- HORIZON LEVEL
-- PHYSICAL PROPERTIES >-< HORIZON LEVEL    ++
-- PHOTOSYNTHETIC PIGMENTS SAMPLES >-< HORIZON LEVEL
-- PHYTOPLANKTON SAMPLES >-- HORIZON LEVEL
-- ZOOPLANKTON SAMPLES >-- HORIZON LEVEL
-- SAMPLES >-< HORIZON LEVEL    ++
CREATE TABLE IF NOT EXISTS Horizon_levels(
    id_horizon  SERIAL PRIMARY KEY,
    name        VARCHAR(16),
    upper_horizon_level FLOAT,
    lower_horizon_level FLOAT
);

-- HORIZONS IN SAMPLES
-- HORIZON LEVELS >-< SAMPLES   ++
CREATE TABLE IF NOT EXISTS Horizons_in_sample(
    id_sample   INTEGER,
    FOREIGN KEY (id_sample) REFERENCES Samples(id_sample),

    id_horizon  INTEGER,
    FOREIGN KEY (id_horizon) REFERENCES Horizon_levels(id_horizon)
);

-- PHYSICAL PROPS AT HRIZON
-- PHYSICAL PROPERTIES >-< HORIZON LEVEL    ++
CREATE TABLE IF NOT EXISTS Physical_props_at_horizon(
    id_physical_prop INTEGER,   
    FOREIGN KEY (id_physical_prop) REFERENCES Physical_properties(id_physical_prop),

    id_sample   INTEGER,
    FOREIGN KEY (id_sample) REFERENCES Samples(id_sample),

    upper_temperature   FLOAT,
    upper_salinity  FLOAT,
    lower_temperature   FLOAT,
    lower_selinity  FLOAT
);

-- GROUND IN MICROFLORA SEDIMENT
-- MICROFLORA SEDIMENT SAMPLES >-< GROUND TYPE
CREATE TABLE IF NOT EXISTS Ground_in_microflora_sediment(
    id_sediment_sample  INTEGER NOT NULL,
    FOREIGN KEY (id_sediment_sample) 
        REFERENCES Microflora_sediment_samples(id_sediment_sample),

    id_ground_type      INTEGER NOT NULL,
    FOREIGN KEY (id_ground_type) 
        REFERENCES Ground_type(id_ground_type)
);

-- HYDROCHEMICAL SAMPLES
-- ONE(SAMPLES) to many(HYDROCHEMICAL SAMPLES)
CREATE TABLE IF NOT EXISTS Hydrochemical_samples(
    id_hydrochemical_samples    SERIAL  PRIMARY KEY,

    id_sample                   INTEGER NOT NULL,
    FOREIGN KEY (id_sample) REFERENCES Samples(id_sample),
    
    chlorinity  FLOAT,
    density     FLOAT,
    volume      FLOAT,
    o2_ml_l     FLOAT,
    o2_mg_l     FLOAT,
    bod5        FLOAT,
    ph          FLOAT,
    alk         FLOAT,
    no2         FLOAT,
    no3         FLOAT,
    total_n     FLOAT,
    po4         FLOAT,
    total_p     FLOAT,
    si          FLOAT,
    oil         FLOAT,
    oil_film    FLOAT,
    phenols     FLOAT,
    synthetic_surfactancts  FLOAT,
    pd          FLOAT, 
    cu          FLOAT,
    hg          FLOAT,
    cd          FLOAT,
    mn          FLOAT,
    ddt         FLOAT,
    dde         FLOAT,
    ddd         FLOAT,
    gamma_hch   FLOAT,
    alpha_hch   FLOAT,
    o2_percentage   FLOAT,
    nh4         FLOAT,
    chromaticity    FLOAT,
    detergents  FLOAT,
    comments    FLOAT
);

-- CLASS OF WATER PURITY
-- BACTRIOPLANKTON SAMPLES >-- CLASS OF WATER PURITY    ++
-- ZOOBENTHOS SaMPLES >-- CLASS OF WATER PURITY     ++
-- ZOOPLANKTTON SAMPLES >-- CLASS OF WATER PURITY
-- PHYTOPLANKTON SAMPLES >-- CLASS OF WATER PURITY
CREATE TABLE IF NOT EXISTS Class_of_water_purity(
    id_class_of_purity  SERIAL PRIMARY KEY,
    name    VARCHAR(64)
);

-- BACTERIOPLANKTON SAMPLES
-- BACTERIOPLANKTON SAMPLES >-- CLASS OF WATER PURITY ++
-- BACTERIOPLANKTON SAMPLES >-- SAMPLES ++
CREATE TABLE IF NOT EXISTS Bacterioplankton_samples(
    id_bacterioplankton_sample  SERIAL PRIMARY KEY,

    id_sample   INTEGER,
    FOREIGN KEY (id_sample) REFERENCES Samples(id_sample),

    id_class_of_purity  INTEGER,
    FOREIGN KEY (id_class_of_purity) 
        REFERENCES Class_of_water_purity(id_class_of_purity),
    
    amount_of_filtered_water    FLOAT,
    total   FLOAT,
    biomass_wet_weight  FLOAT,
    heterotrophs_RPA    FLOAT,
    ration_of_total_to_biomass  FLOAT,
    population_doubling_time    INTEGER
);


-- SAPROBITY
-- ZOOBENTHOS SAMPLES >-- SAPROBITY
-- ZOOPLANKTON SAMPLES >-- SAPROBITY
-- SPECIES IN ZOOBENTHOS SAMPLES >-- SAPROBITY
-- PHYTOPLANKTON SAMPLES >-- SAPROBITY
-- SPECIES IN PHYTOPLANKTON SAMPLE >--SAPROBITY 
CREATE TABLE IF NOT EXISTS Saprobity(
    id_saprobity    SERIAL PRIMARY KEY,
    name    VARCHAR(8)
);


-- ZOOBENTHOS SAMPLES
-- ZOOBENTHOS SAMPLES >-- SAMPLES
-- CLASS OF WATER PURITY --< ZOOBENTHOS SAMPLES 
-- ZOOBENTHOS SAMPLES >-- SAPROBITY
CREATE TABLE IF NOT EXISTS Zoobenthos_samples(
    id_zoobenthos_sample    SERIAL  PRIMARY KEY,

    id_sample  INTEGER,
    FOREIGN KEY (id_sample) REFERENCES Samples(id_sample),

    id_class_of_purity  INTEGER,
    FOREIGN KEY (id_class_of_purity) 
        REFERENCES Class_of_water_purity(id_class_of_purity),

    id_saprobity    INTEGER,
    FOREIGN KEY (id_saprobity) 
        REFERENCES Saprobity(id_saprobity),
    
    number_of_samples   INTEGER,
    total               FLOAT,
    total_biomass       FLOAT,
    number_of_species_in_sample INTEGER,
    biomass_in_sample   FLOAT,
    fishing_gear        VARCHAR(256),
    number_fishing_gear INTEGER,
    total_without_unionidae FLOAT,
    total_biomass_without_unionidae FLOAT
);

-- GROUPS OF ZOOBENTHOS
-- GROUPS OF ZOOBENTHOS >-< ZOOBENTHOS SAMPLES
-- SPECIES OF ZOOBENTHOS >-- GROUP OF ZOOBENTHOS
CREATE TABLE IF NOT EXISTS Group_of_zoobenthos(
    id_group    SERIAL PRIMARY KEY,
    name        VARCHAR(128)
);

-- GROUPS IN ZOOBENTHOS SAMPLE
-- GROUPS OF ZOOBENTHOS >-< ZOOBENTHOS SAMPLES
CREATE TABLE IF NOT EXISTS Group_in_zoobenthos_sample(
    id_zoobenthos_sample    INTEGER,
    FOREIGN KEY (id_zoobenthos_sample) 
        REFERENCES Zoobenthos_samples(id_zoobenthos_sample),

    id_group    INTEGER,
    FOREIGN KEY (id_group) REFERENCES Group_of_zoobenthos(id_group),

    number_of_species   INTEGER,
    number              FLOAT,
    biomass             FLOAT,
    biomassm2           FLOAT,
    percentage_of_total FLOAT,
    percentage_of_the_total_biomass FLOAT
);

-- SPECIES OF ZOOBENTHOS
-- SPECIES OF ZOOBENTHOS >-- GROUPS OF ZOOBENTHOS
-- SPECIES IN ZOOBENTHOS SAMPLE >-- SPECIES OF ZOOBENTHOS
CREATE TABLE IF NOT EXISTS Species_of_zoobenthos(
    id_species  SERIAL  PRIMARY KEY,
    
    id_group    INTEGER,
    FOREIGN KEY (id_group) REFERENCES Group_of_zoobenthos(id_group),

    name        VARCHAR(128)
); 

-- SPECIES IN ZOOBENTHOS SAMPLE
-- 
CREATE TABLE IF NOT EXISTS Species_in_zoobenthos_sample(
    id_species  INTEGER,
    FOREIGN KEY (id_species) 
        REFERENCES Species_of_zoobenthos(id_species),
    
    id_zoobenthos_sample    INTEGER,
    FOREIGN KEY (id_zoobenthos_sample)
        REFERENCES Zoobenthos_samples(id_zoobenthos_sample),
    
    id_saprobity    INTEGER,
    FOREIGN KEY (id_saprobity)
        REFERENCES Saprobity(id_saprobity),
    
    number_of_species   INTEGER,
    number              FLOAT,
    biomass             FLOAT,
    biomassm2           FLOAT,
    percentage_of_total FLOAT,
    percentage_of_the_total_biomass FLOAT
);


-- TROPHIC CHARACTERIZATION OF WATER
-- 
CREATE TABLE IF NOT EXISTS Trophic_characterization_of_water(
    id_trophic_characterization SERIAL  PRIMARY KEY,
    name    VARCHAR(32)
);

-- PHOTOSYNTHETIC PIGMENTS SAMPLES
-- 
CREATE TABLE IF NOT EXISTS Photosynthetic_pigments_samples(
    id_photosynthetic_pigments_sample   SERIAL PRIMARY KEY,
    
    id_trophic_characterization INTEGER,
    FOREIGN KEY (id_trophic_characterization) 
        REFERENCES Trophic_characterization_of_water(id_trophic_characterization),

    id_sample  INTEGER,
    FOREIGN KEY (id_sample) REFERENCES Samples(id_sample),

    id_horizon  INTEGER,
    FOREIGN KEY (id_horizon)
        REFERENCES Horizon_levels(id_horizon),
    
    volume_of_filtered_water    FLOAT,
    chlorophyll_a_concentration FLOAT,
    chlorophyll_b_concentration FLOAT,
    chlorophyll_c_concentration FLOAT,
    "A(665K)"                   FLOAT,
    pigment_index               FLOAT,
    pheopigments                FLOAT,
    ratio_of_chi_a_to_chi_c     FLOAT,
    comment                     FLOAT,
    serial_nimber               INTEGER
);

-- PHYTOPLANKTON SAMPLES
-- 
CREATE TABLE IF NOT EXISTS Phytoplankton_samples(
    id_photo_sample SERIAL  PRIMARY KEY,
    
    id_class_of_purity  INTEGER,
    FOREIGN KEY (id_class_of_purity)
        REFERENCES Class_of_water_purity(id_class_of_purity),
    
    id_sample   INTEGER,
    FOREIGN KEY (id_sample) REFERENCES Samples(id_sample),

    id_horizon  INTEGER,
    FOREIGN KEY (id_horizon) REFERENCES Horizon_levels(id_horizon),

    id_saprobity    INTEGER,
    FOREIGN KEY (id_saprobity) REFERENCES Saprobity(id_saprobity),

    upholding_sample_time   INTEGER,
    concentrated_sample_volume  INTEGER,
    cameras_viewed_number   INTEGER,
    total               FLOAT,
    total_species   INTEGER,
    total_biomass   FLOAT,
    total_percent   FLOAT,
    biomass_percent FLOAT
);


-- GROUP OF PHYTOPLANKTON
-- 
CREATE TABLE IF NOT EXISTS Group_of_phytoplankton(
    id_group    SERIAL PRIMARY KEY,
    name    VARCHAR(128),
    name_alt    VARCHAR(128),
    name_rus    VARCHAR(128)
);


-- SPECIES OF PHYTOPLANKTON
-- 
CREATE TABLE IF NOT EXISTS Species_of_phytoplankton(
    id_species  SERIAL  PRIMARY KEY,
    
    id_group    INTEGER,
    FOREIGN KEY (id_group)  REFERENCES Group_of_phytoplankton(id_group),

    name    VARCHAR(128)
);

-- GROUPS IN PHYTOPLANKTON SAMPLE
-- 
CREATE TABLE IF NOT EXISTS Group_in_phytoplankton_sample(
    id_group    INTEGER,
    FOREIGN KEY (id_group) REFERENCES Group_of_phytoplankton(id_group),
 
    id_photo_sample INTEGER,
    FOREIGN KEY (id_photo_sample) REFERENCES Phytoplankton_samples(id_photo_sample),

    number  FLOAT,
    biomass FLOAT,
    total_species_in_group  INTEGER,
    total_percent   FLOAT,
    biomass_percent FLOAT
);

-- SPECIES IN PHYTOPLANKTON SAMPLE
-- 
CREATE TABLE IF NOT EXISTS Species_in_phytoplankton_sample(
    id_photo_sample INTEGER,
    FOREIGN KEY (id_photo_sample) REFERENCES Phytoplankton_samples(id_photo_sample),

    id_species  INTEGER,
    FOREIGN KEY (id_species) REFERENCES Species_of_phytoplankton(id_species),

    id_saprobity    INTEGER,
    FOREIGN KEY (id_saprobity) REFERENCES Saprobity(id_saprobity),

    percentage_of_total FLOAT,
    percentage_of_the_total_biomass FLOAT,
    number  FLOAT,
    biomass FLOAT
);

-- Zooplankton samples
-- 
CREATE TABLE IF NOT EXISTS Zooplankton_samples(
    id_zoo_sample   SERIAL PRIMARY KEY,
    
    id_class_of_purity INTEGER,
    FOREIGN KEY (id_class_of_purity) REFERENCES Class_of_water_purity(id_class_of_purity),

    id_sample   INTEGER,
    FOREIGN KEY (id_sample) REFERENCES Samples(id_sample),

    id_horizon INTEGER,
    FOREIGN KEY (id_horizon) REFERENCES Horizon_levels(id_horizon),

    id_saprobity    INTEGER,
    FOREIGN KEY (id_saprobity) REFERENCES Saprobity(id_saprobity),

    total   FLOAT,
    total_species   FLOAT,
    total_biomass   FLOAT,
    fishing_gear    VARCHAR(256),
    assessment_of_zooplankton   FLOAT
);

CREATE TABLE IF NOT EXISTS Group_of_zooplankton(
    id_group    SERIAL  PRIMARY KEY,
    name        VARCHAR(128)
);

CREATE TABLE IF NOT EXISTS Groups_in_zoobenthos_sample(
    id_group    SERIAL PRIMARY KEY,
    FOREIGN KEY (id_group) REFERENCES Group_of_zooplankton(id_group),

    id_zoo_sample   INTEGER,
    FOREIGN KEY (id_zoo_sample) REFERENCES Zooplankton_samples(id_zoo_sample),

    number  FLOAT,
    biomass FLOAT,
    total_species_in_group  INTEGER
);


CREATE TABLE IF NOT EXISTS Species_of_zooplankton(
    id_species  SERIAL PRIMARY KEY,
    
    id_group    INTEGER,
    FOREIGN KEY (id_group)
        REFERENCES Groups_in_zoobenthos_sample(id_group),

    name    VARCHAR(128)
);


-- 
CREATE TABLE IF NOT EXISTS Species_in_zooplankton_sample(
    id_zoo_sample   INTEGER,
    FOREIGN KEY (id_zoo_sample) REFERENCES Zooplankton_samples(id_zoo_sample),

    id_species  INTEGER,
    FOREIGN KEY (id_species) REFERENCES Species_of_zooplankton(id_species),

    percentage_of_total FLOAT,
    percentage_of_the_total_biomass FLOAT,
    subsamples_number   INTEGER,
    number_of_copies    FLOAT
);


CREATE TABLE IF NOT EXISTS Visibility(
    id_visibility   SERIAL PRIMARY KEY,
    code    INTEGER,
    distance_min    FLOAT,
    distance_max    FLOAT,
    comment     VARCHAR(256)
);

CREATE TABLE IF NOT EXISTS Water_color(
    id_water_color  SERIAL  PRIMARY KEY,
    water_color     INTEGER,
    description     VARCHAR(64)
);

CREATE TABLE IF NOT EXISTS Cloud_cover(
    id_cloud_cover  SERIAL  PRIMARY KEY,
    amount  INTEGER,
    description VARCHAR(512)
);

-- PostGis
CREATE TABLE IF NOT EXISTS Direction(
    id_direction    SERIAL  PRIMARY KEY,
    thumbs          VARCHAR(8),
    degrees         FLOAT
);

CREATE TABLE IF NOT EXISTS Wave_height(
    id_wave_height  SERIAL PRIMARY KEY,
    wave_height     FLOAT
);

CREATE TABLE IF NOT EXISTS Wave_type(
    id_wave_type    SERIAL  PRIMARY KEY,
    code            INTEGER,
    description     VARCHAR(84)
);

CREATE TABLE IF NOT EXISTS Waves(
    id_waves    SERIAL PRIMARY KEY,

    id_wave_type    INTEGER NOT NULL,
    FOREIGN KEY (id_wave_type) REFERENCES Wave_type(id_wave_type), 

    id_predominant_direction    INTEGER,
    FOREIGN KEY (id_predominant_direction) 
        REFERENCES Direction(id_direction),


    id_secondary_direction    INTEGER,
    FOREIGN KEY (id_secondary_direction) 
        REFERENCES Direction(id_direction),
    
    id_wave_height  INTEGER,
    FOREIGN KEY (id_wave_height)
        REFERENCES Wave_height(id_wave_height),
    
    sea_state   INTEGER,
    wave_code   INTEGER
);

CREATE TABLE IF NOT EXISTS Wind(
    id_wind     SERIAL  PRIMARY KEY,
    
    id_direction    INTEGER,
    FOREIGN KEY (id_direction)
        REFERENCES Direction(id_direction),
    
    wind_direction_degress  FLOAT,
    wind_speed      FLOAT
);

CREATE TABLE IF NOT EXISTS Cloud_shape(
    id_cloud_shape  SERIAL PRIMARY KEY,
    name            VARCHAR(10),
    description     VARCHAR(512)
);


-- PostGIS
CREATE TABLE IF NOT EXISTS Meteo_samples(
    id_meteo    SERIAL  PRIMARY KEY,
    
    id_sample   INTEGER,
    FOREIGN KEY (id_sample)
        REFERENCES Samples(id_sample),
    
    id_wind     INTEGER,
    FOREIGN KEY (id_wind)
        REFERENCES Wind(id_wind),
    
    id_waves    INTEGER,
    FOREIGN KEY (id_waves)
        REFERENCES Waves(id_waves),
    
    id_visibility INTEGER,
    FOREIGN KEY (id_visibility)
        REFERENCES Visibility(id_visibility),
    
    id_water_color  INTEGER,
    FOREIGN KEY (id_water_color)
        REFERENCES Water_color(id_water_color),
    
    id_cloud_cover_total    INTEGER,
    FOREIGN KEY (id_cloud_cover_total)
        REFERENCES Cloud_cover(id_cloud_cover),

    id_cloud_cover_lower    INTEGER,
    FOREIGN KEY (id_cloud_cover_lower)
        REFERENCES Cloud_cover(id_cloud_cover),

    air_temperature FLOAT,
    atmospheric_pressure    FLOAT,
    humidity_absolute   FLOAT,
    humidity_relative   FLOAT,
    water_vapour_presure    FLOAT,
    transparency        FLOAT,
    sea_level   FLOAT,
    oil_film    FLOAT,
    surface_stream_volocity FLOAT,
    surface_stream_direction FLOAT,
    bottom_stream_volocity  FLOAT,
    bottom_stream_direction FLOAT
);

CREATE TABLE IF NOT EXISTS Clouds_in_meteo_sample(
    id_meteo_sample     INTEGER,
    FOREIGN KEY(id_meteo_sample)
        REFERENCES Meteo_samples(id_meteo),

    id_cloud_shape  INTEGER,
    FOREIGN KEY (id_cloud_shape)
        REFERENCES Cloud_shape(id_cloud_shape)
);





