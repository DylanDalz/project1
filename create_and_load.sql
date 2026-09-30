-- =======================================================================================
-- CS336 Project 1
-- This script will create the Preliminary table to upload the data from the original .csv
-- =======================================================================================

-- If you want to run the script again, then let it delete the table if it already exists.
DROP TABLE IF EXISTS Preliminary;

-- Create the Preliminary table for storing HMDA data, and have everything as TEXT for now. Will cast into proper data types later.
CREATE TABLE Preliminary (
    as_of_year TEXT,
    respondent_id TEXT,
    agency_name TEXT,
    agency_abbr TEXT,
    agency_code TEXT,
    loan_type_name TEXT,
    loan_type TEXT,
    property_type_name TEXT,
    property_type TEXT,
    loan_purpose_name TEXT,
    loan_purpose TEXT,
    owner_occupancy_name TEXT,
    owner_occupancy TEXT,
    loan_amount_000s TEXT,
    preapproval_name TEXT,
    preapproval TEXT,
    action_taken_name TEXT,
    action_taken TEXT,
    msamd_name TEXT,
    msamd TEXT,
    state_name TEXT,
    state_abbr TEXT,
    state_code TEXT,
    county_name TEXT,
    county_code TEXT,
    census_tract_number TEXT,
    applicant_ethnicity_name TEXT,
    applicant_ethnicity TEXT,
    co_applicant_ethnicity_name TEXT,
    co_applicant_ethnicity TEXT,
    applicant_race_name_1 TEXT,
    applicant_race_1 TEXT,
    applicant_race_name_2 TEXT,
    applicant_race_2 TEXT,
    applicant_race_name_3 TEXT,
    applicant_race_3 TEXT,
    applicant_race_name_4 TEXT,
    applicant_race_4 TEXT,
    applicant_race_name_5 TEXT,
    applicant_race_5 TEXT,
    co_applicant_race_name_1 TEXT,
    co_applicant_race_1 TEXT,
    co_applicant_race_name_2 TEXT,
    co_applicant_race_2 TEXT,
    co_applicant_race_name_3 TEXT,
    co_applicant_race_3 TEXT,
    co_applicant_race_name_4 TEXT,
    co_applicant_race_4 TEXT,
    co_applicant_race_name_5 TEXT,
    co_applicant_race_5 TEXT,
    applicant_sex_name TEXT,
    applicant_sex TEXT,
    co_applicant_sex_name TEXT,
    co_applicant_sex TEXT,
    applicant_income_000s TEXT,
    purchaser_type_name TEXT,
    purchaser_type TEXT,
    denial_reason_name_1 TEXT,
    denial_reason_1 TEXT,
    denial_reason_name_2 TEXT,
    denial_reason_2 TEXT,
    denial_reason_name_3 TEXT,
    denial_reason_3 TEXT,
    rate_spread TEXT,
    hoepa_status_name TEXT,
    hoepa_status TEXT,
    lien_status_name TEXT,
    lien_status TEXT,
    edit_status_name TEXT,
    edit_status TEXT,
    sequence_number TEXT,
    "population" TEXT,
    minority_population TEXT,
    hud_median_family_income TEXT,
    tract_to_msamd_income TEXT,
    number_of_owner_occupied_units TEXT,
    number_of_1_to_4_family_units TEXT,
    application_date_indicator TEXT
);

-- Drop the list of numbers to start back at 1, so it does not ruin the row's order. 
DROP SEQUENCE IF EXISTS number_list;

-- Create a sequence where the number_list will start from 1 and increment by 1 for each new row.
CREATE SEQUENCE number_list START 1;

-- PostgreSQL Offical Documentation for 1.2 Columns: https://www.postgresql.org/docs/7.2/sql-syntax-columns.html
-- PostgreSQL Offical Documentation for 9.30 Event Trigger Functions: https://www.postgresql.org/docs/current/functions-event-triggers.html

-- set_sequence_number() function will assign a sequence number to each new row before it has been inserted into the Preliminary table.
CREATE OR REPLACE FUNCTION set_sequence_number() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    -- Overwrite the current row's sequence_number column's data, which is NULL, and assign it with the next number, casted as TEXT for now, from number_list. 
    NEW.sequence_number := NEXTVAL('number_list')::TEXT;
    RETURN NEW;
END; 
$$;

-- PostgreSQL Offical Documentation for 9.29 Trigger Functions: https://www.postgresql.org/docs/current/functions-trigger.html
-- Create a trigger for trigger function set_sequence_number(), and let it execute to number a row before the row is inserted into the Preliminary table.
CREATE TRIGGER set_sequence_number_trigger BEFORE INSERT ON Preliminary FOR EACH ROW EXECUTE FUNCTION set_sequence_number();

-- Copy the entire CSV's data into the Preliminary table.
\copy Preliminary FROM 'hmda_2017_nj_all-records_labels.csv' DELIMITER ',' CSV HEADER;

-- PostgreSQL Offical Documentation for DROP TRIGGER: https://www.postgresql.org/docs/18/sql-droptrigger.html
-- Delete the trigger to prevent from the function running again each time the table is modified to prevent re-ordering of the rows.
DROP TRIGGER set_sequence_number_trigger ON Preliminary;

-- PostgreSQL Offical Documentation for ALTER TABLE: https://www.postgresql.org/docs/18/sql-altertable.html
-- Cast each attrribute in the table to its correct data type. While checking if the column is empty, use NULLIF to convert empty strings to NULL.
ALTER TABLE Preliminary ALTER COLUMN as_of_year TYPE INTEGER USING NULLIF(as_of_year, '')::INTEGER;

-- This attribute will be TEXT, because of the dashes present in some rows.
ALTER TABLE Preliminary ALTER COLUMN respondent_id TYPE TEXT USING NULLIF(respondent_id, '')::TEXT;

-- Cast the attributes to their correct data types. Attributes that stay as text are not included.
ALTER TABLE Preliminary ALTER COLUMN agency_code TYPE INTEGER USING NULLIF(agency_code, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN loan_type TYPE INTEGER USING NULLIF(loan_type, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN property_type TYPE INTEGER USING NULLIF(property_type, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN loan_purpose TYPE INTEGER USING NULLIF(loan_purpose, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN owner_occupancy TYPE INTEGER USING NULLIF(owner_occupancy, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN loan_amount_000s TYPE INTEGER USING NULLIF(loan_amount_000s, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN preapproval TYPE INTEGER USING NULLIF(preapproval, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN action_taken TYPE INTEGER USING NULLIF(action_taken, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN msamd TYPE INTEGER USING NULLIF(msamd, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN state_code TYPE INTEGER USING NULLIF(state_code, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN county_code TYPE INTEGER USING NULLIF(county_code, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN census_tract_number TYPE NUMERIC USING NULLIF(census_tract_number, '')::NUMERIC;
ALTER TABLE Preliminary ALTER COLUMN applicant_ethnicity TYPE INTEGER USING NULLIF(applicant_ethnicity, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN co_applicant_ethnicity TYPE INTEGER USING NULLIF(co_applicant_ethnicity, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN applicant_race_1 TYPE INTEGER USING NULLIF(applicant_race_1, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN applicant_race_2 TYPE INTEGER USING NULLIF(applicant_race_2, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN applicant_race_3 TYPE INTEGER USING NULLIF(applicant_race_3, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN applicant_race_4 TYPE INTEGER USING NULLIF(applicant_race_4, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN applicant_race_5 TYPE INTEGER USING NULLIF(applicant_race_5, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN co_applicant_race_1 TYPE INTEGER USING NULLIF(co_applicant_race_1, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN co_applicant_race_2 TYPE INTEGER USING NULLIF(co_applicant_race_2, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN co_applicant_race_3 TYPE INTEGER USING NULLIF(co_applicant_race_3, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN co_applicant_race_4 TYPE INTEGER USING NULLIF(co_applicant_race_4, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN co_applicant_race_5 TYPE INTEGER USING NULLIF(co_applicant_race_5, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN applicant_sex TYPE INTEGER USING NULLIF(applicant_sex, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN co_applicant_sex TYPE INTEGER USING NULLIF(co_applicant_sex, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN applicant_income_000s TYPE INTEGER USING NULLIF(applicant_income_000s, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN purchaser_type TYPE INTEGER USING NULLIF(purchaser_type, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN denial_reason_1 TYPE INTEGER USING NULLIF(denial_reason_1, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN denial_reason_2 TYPE INTEGER USING NULLIF(denial_reason_2, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN denial_reason_3 TYPE INTEGER USING NULLIF(denial_reason_3, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN rate_spread TYPE NUMERIC USING NULLIF(rate_spread, '')::NUMERIC;
ALTER TABLE Preliminary ALTER COLUMN hoepa_status TYPE INTEGER USING NULLIF(hoepa_status, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN lien_status TYPE INTEGER USING NULLIF(lien_status, '')::INTEGER;

-- No data present in this column, keep it as text due to it being name.
ALTER TABLE Preliminary ALTER COLUMN edit_status_name TYPE TEXT USING NULLIF(edit_status_name, '')::TEXT;

-- No data present in this column, keep it as integer. It likely follows the same fashion like lien_status_name & lien_status.
ALTER TABLE Preliminary ALTER COLUMN edit_status TYPE INTEGER USING NULLIF(edit_status, '')::INTEGER;

-- Cast sequence_number to integer.
ALTER TABLE Preliminary ALTER COLUMN sequence_number TYPE INTEGER USING NULLIF(sequence_number, '')::INTEGER;

ALTER TABLE Preliminary ALTER COLUMN population TYPE INTEGER USING NULLIF(population, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN minority_population TYPE NUMERIC USING NULLIF(minority_population, '')::NUMERIC;
ALTER TABLE Preliminary ALTER COLUMN hud_median_family_income TYPE INTEGER USING NULLIF(hud_median_family_income, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN tract_to_msamd_income TYPE NUMERIC USING NULLIF(tract_to_msamd_income, '')::NUMERIC;
ALTER TABLE Preliminary ALTER COLUMN number_of_owner_occupied_units TYPE INTEGER USING NULLIF(number_of_owner_occupied_units, '')::INTEGER;
ALTER TABLE Preliminary ALTER COLUMN number_of_1_to_4_family_units TYPE INTEGER USING NULLIF(number_of_1_to_4_family_units, '')::INTEGER;

-- No data present in this column, keep it as text
ALTER TABLE Preliminary ALTER COLUMN application_date_indicator TYPE TEXT USING NULLIF(application_date_indicator, '')::TEXT;

ALTER TABLE Preliminary ADD PRIMARY KEY (sequence_number);
