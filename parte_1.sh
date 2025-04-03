#!/bin/bash

re='^[0-9]+$'
if ! [[ $1 =~ $re ]] ; then
   echo "error $1 no es un padron valido" >&2; exit 1
fi

padron=$1
directorio=$2

find $directorio/resultado.txt >/dev/null 2>/dev/null
if [[ $? != 0 ]]; then 
   mkdir $directorio 2>/dev/null
else
   rm $directorio/resultado.txt
fi

tipo_pokemon_parametro=$(($padron % 18 + 1))
estadistica_parametro=$(($padron % 100 + 350))
pokemon_csv=$(find -name pokemon.csv)
pokemon_stats_csv=$(find -name pokemon_stats.csv)
pokemon_types_csv=$(find -name pokemon_types.csv)

calcular_estadistica(){
   estadistica_total=0
   estadisticas_pokemon_padron=$(cut -d "," -f1,3 $pokemon_stats_csv | grep -w ^$1,*)
   for linea in $estadisticas_pokemon_padron;
   do
      estadistica_total=$(($estadistica_total + $(echo $linea | cut -d "," -f2)))
   done
   echo $estadistica_total
}

verificar_tipo(){
   busqueda_tipo=$(cut -d "," -f1,2,3 $pokemon_types_csv | grep -w ^$1,*)
   for line in $busqueda_tipo;
   do
      if [[ $(echo $line | cut -d "," -f3) -eq 1 ]]; then 
         tipo_1_pokemon=$(echo $line | cut -d "," -f2)
      elif [[ $(echo $line | cut -d "," -f3) -eq 2 ]]; then
         tipo_2_pokemon=$(echo $line | cut -d "," -f2)
      fi
   done
   echo $tipo_1_pokemon,$tipo_2_pokemon
}

for fila in $(cat $pokemon_csv); 
do
   stat=$(calcular_estadistica $(echo $fila | cut -d "," -f1))
   type=$(verificar_tipo $(echo $fila | cut -d "," -f1))
      if [[ $(echo $type | cut -d "," -f1) == $tipo_pokemon_parametro || $(echo $type | cut -d "," -f2) == $tipo_pokemon_parametro ]]; then
         if [[ $stat -ge $estadistica_parametro ]]; then
            pokemon=$(echo $fila | cut -d "," -f2)
            echo $pokemon >> $directorio/resultado.txt
         fi
      fi
done

exit 0



