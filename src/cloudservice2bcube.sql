CREATE OR REPLACE TEMPORARY FUNCTION eeaCellCode AS 'org.gbif.occurrence.hive.udf.EeaCellCodeUDF';
CREATE OR REPLACE TEMPORARY FUNCTION eqdgcCode AS 'org.gbif.occurrence.hive.udf.ExtendedQuarterDegreeGridCellCodeUDF';
CREATE OR REPLACE TEMPORARY FUNCTION mgrsCode AS 'org.gbif.occurrence.hive.udf.MilitaryGridReferenceSystemCellCodeUDF';

SELECT
  -- Dimensions:
  CONCAT_WS('-', year, month) AS yearMonth,
  eqdgcCode(
    2,
    decimalLatitude,
    decimalLongitude,
    COALESCE(coordinateUncertaintyInMeters, 1000)
  ) AS eqdgcCode,
  speciesKey,
  species,
  -- Measurements
  COUNT(*) AS n,
  MIN(COALESCE(coordinateUncertaintyInMeters, 1000)) AS minCoordinateUncertaintyInMeters
FROM
  gbif.occurrence
WHERE occurrenceStatus = 'PRESENT'
  AND decimalLatitude IS NOT NULL
  AND speciesKey = 5824863
  AND NOT ARRAY_CONTAINS(issue.array_element, 'COUNTRY_COORDINATE_MISMATCH')
  AND month IS NOT NULL
GROUP BY
  yearMonth,
  eqdgcCode,
  speciesKey,
  species
ORDER BY
  yearMonth DESC,
  eqdgcCode ASC,
  speciesKey ASC;
