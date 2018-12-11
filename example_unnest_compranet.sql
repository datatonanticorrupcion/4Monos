-- Obtener el número de participantes por concurso

SELECT
  ocid, count(*) 
FROM
  `Compranet.database_name`, UNNEST(tenderers) bidders
GROUP by bidders
ORDER BY bidders_count desc;


-- Crear un campo REPEATED con el nombre de cada uno los participantes

CREATE TEMP FUNCTION EXTRACT_NAMES(row STRING)
  RETURNS ARRAY<STRING>
  LANGUAGE js AS """
function extract(row) {
  var vals = [];
  if(!row){
    return vals;
  }
  if(row[0] == '"'){
    row = row.replace (/(^")|("$)/g, '')
    }
  row = row.replace(/""/g, '"');
  try{
    var obj = JSON.parse(row);
  }catch (e){
    return null;
  }

  for(element of obj){
      vals.push(element['name']);
  }
  return vals;
}

return extract(row);
""";

SELECT * except( compiledRelease__tender__tenderers),
  EXTRACT_NAMES( compiledRelease__tender__tenderers ) tenderers
FROM   `Compranet.ContractsV2`; -- Reemplazar ContractsV2 por el nombre de tu tabla
