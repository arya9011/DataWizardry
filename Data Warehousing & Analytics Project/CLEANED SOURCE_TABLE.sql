--Finding duplicate values
SELECT 
  ID1,
  ID,
  "@id",
  "samplesamplingPoint",
  "samplesamplingPointnotation",
  "samplesamplingPointlabel",
  "samplesampleDateTime",
  "determinandlabel",
  "determinanddefinition",
  "determinandnotation",
  "resultQualifiernotation",
  "result",
  "codedResultInterpretationinterpretation",
  "determinandunitlabel",
  "samplesampledMaterialTypelabel",
  "sampleisComplianceSample",
  "samplepurposelabel",
  "samplesamplingPointeasting",
  "samplesamplingPointnorthing",
  COUNT(*) AS duplicate_count
FROM SOURCE_TABLE
GROUP BY
  ID1,
  ID,
  "@id",
  "samplesamplingPoint",
  "samplesamplingPointnotation",
  "samplesamplingPointlabel",
  "samplesampleDateTime",
  "determinandlabel",
  "determinanddefinition",
  "determinandnotation",
  "resultQualifiernotation",
  "result",
  "codedResultInterpretationinterpretation",
  "determinandunitlabel",
  "samplesampledMaterialTypelabel",
  "sampleisComplianceSample",
  "samplepurposelabel",
  "samplesamplingPointeasting",
  "samplesamplingPointnorthing"
HAVING COUNT(*) > 1;

--Dropping Columns from the Table
ALTER TABLE SOURCE_TABLE DROP ("ID1","ID","samplesamplingPoint","determinandlabel","resultQualifiernotation","codedResultInterpretationinterpretation","sampleisComplianceSample");


--Renaming Attributes
ALTER TABLE SOURCE_TABLE
RENAME COLUMN "@id" TO ID;

ALTER TABLE SOURCE_TABLE
RENAME COLUMN "samplesamplingPointnotation" TO SAMPLING_POINT_NOTATION;

ALTER TABLE SOURCE_TABLE
RENAME COLUMN "samplesamplingPointlabel" TO SAMPLING_POINT_LABEL;

ALTER TABLE SOURCE_TABLE
RENAME COLUMN "samplesampleDateTime" TO SAMPLE_DATE_TIME;

ALTER TABLE SOURCE_TABLE
RENAME COLUMN "determinanddefinition" TO DETERMINAND_DEFINITION;

ALTER TABLE SOURCE_TABLE
RENAME COLUMN "determinandnotation" TO DETERMINAND_NOTATION;

ALTER TABLE SOURCE_TABLE
RENAME COLUMN "determinandunitlabel" TO DETERMINAND_UNIT_LABEL;

ALTER TABLE SOURCE_TABLE
RENAME COLUMN "samplepurposelabel" TO SAMPLE_PURPOSE_LABEL;

ALTER TABLE SOURCE_TABLE
RENAME COLUMN "samplesampledMaterialTypelabel" TO SAMPLED_MATERIAL_TYPE;

ALTER TABLE SOURCE_TABLE
RENAME COLUMN "samplesamplingPointeasting" TO SAMPLING_POINT_EASTING;

ALTER TABLE SOURCE_TABLE
RENAME COLUMN "samplesamplingPointnorthing" TO SAMPLING_POINT_NORTHING;


--Finding Missing Values
SELECT
    COUNT(CASE WHEN "ID" IS NULL THEN 1 END) AS "ID_missing_count",
    COUNT(CASE WHEN "SAMPLING_POINT_NOTATION" IS NULL THEN 1 END) AS "SAMPLING_POINT_NOTATION_missing_count",
    COUNT(CASE WHEN "SAMPLING_POINT_LABEL" IS NULL THEN 1 END) AS "SAMPLING_POINT_LABEL_missing_count",
    COUNT(CASE WHEN "SAMPLE_DATE_TIME" IS NULL THEN 1 END) AS "SAMPLE_DATE_TIME_missing_count",
    COUNT(CASE WHEN "DETERMINAND_DEFINITION" IS NULL THEN 1 END) AS "DETERMINAND_DEFINITION_missing_count",
    COUNT(CASE WHEN "DETERMINAND_NOTATION" IS NULL THEN 1 END) AS "DETERMINAND_NOTATION_missing_count",
    COUNT(CASE WHEN "result" IS NULL THEN 1 END) AS "result_missing_count",
    COUNT(CASE WHEN "DETERMINAND_UNIT_LABEL" IS NULL THEN 1 END) AS "DETERMINAND_UNIT_LABEL_missing_count",
    COUNT(CASE WHEN "SAMPLED_MATERIAL_TYPE" IS NULL THEN 1 END) AS "SAMPLED_MATERIAL_TYPE_missing_count",
    COUNT(CASE WHEN "SAMPLE_PURPOSE_LABEL" IS NULL THEN 1 END) AS "SAMPLE_PURPOSE_LABEL_missing_count",
    COUNT(CASE WHEN "SAMPLING_POINT_EASTING" IS NULL THEN 1 END) AS "SAMPLING_POINT_EASTING_missing_count",
    COUNT(CASE WHEN "SAMPLING_POINT_NORTHING" IS NULL THEN 1 END) AS "SAMPLING_POINT_NORTHING_missing_count"
FROM SOURCE_TABLE;

--Removing unnecessary URL from ID Column
UPDATE SOURCE_TABLE
SET "ID" = REPLACE("ID", 'http://environment.data.gov.uk/water-quality/data/measurement/', '');

--Splitting SOURCE_DATE_TIME into SOURCE_DATE and SOURCE_TIME
ALTER TABLE SOURCE_TABLE ADD (SAMPLE_DATE DATE, SAMPLE_TIME VARCHAR2(8));

--Adding datas to column
UPDATE SOURCE_TABLE
    SET 
        SAMPLE_DATE = TO_DATE(SAMPLE_DATE_TIME, 'YYYY-MM-DD"T"HH24:MI:SS'),
        SAMPLE_TIME = TO_CHAR(TO_DATE(SAMPLE_DATE_TIME, 'YYYY-MM-DD"T"HH24:MI:SS'), 'HH24:MI:SS');
 
 --Deleting SAMPLE_DATE_TIME Column from the table
ALTER TABLE SOURCE_TABLE
DROP COLUMN SAMPLE_DATE_TIME;

SELECT * FROM SOURCE_TABLE;

        



