#!/bin/bash
entrada=$(</dev/stdin)
pokemon_csv=$(find -name pokemon.csv)
pokemon_abilities_csv=$(find -name pokemon_abilities.csv)
ability_names_csv=$(find -name ability_names.csv)


buscar_habilidades_y_sus_nombres(){
habilidades=()
habilidades_id=()
filas=$(cut -d "," -f1,2 $pokemon_abilities_csv | grep -w ^$1,*)
indice=0
for fila in $filas;
    do
    habilidades_id[indice]=$(echo $fila | cut -d "," -f2)
    indice=$(($indice + 1))
done

contador=0

for habilidad_id in ${habilidades_id[@]}; do
lines=$(cut -d "," -f1,2,3 $ability_names_csv | grep -w ^$habilidad_id,7,*)
    for line in $lines; do
        habilidades+=($(echo $line | cut -d "," -f1))
        
    done
done
echo "${habilidades[*]}"
}



for pokemon_entrada in $entrada; do
    if [[ "${pokemon_entrada}" =~ [^a-zA-Z] ]]; then
        echo "$pokemon_entrada no es un pokemon"
        continue
    fi
    pokemon_datos=$(cut -d "," -f1,2,4,5 $pokemon_csv | grep ,$pokemon_entrada, 2>/dev/null)
    if [[ $? != 0 ]]; then 
        echo "$pokemon_entrada no esta en la pokedex"
        continue
    else
        peso=$(($(echo $pokemon_datos | cut -d "," -f4) / 10 ))
        altura=$(($(echo $pokemon_datos | cut -d "," -f3) *10 ))
        nombres_habilidades=($(buscar_habilidades_y_sus_nombres $(echo $pokemon_datos | cut -d "," -f1)))
        echo "-----------------"
        echo "Pokemon: $pokemon_entrada"
        echo "Altura: $altura centimetros"
        echo "Peso: $peso kilos"
        echo
        echo "Habilidades:"
        for habilidad in "${nombres_habilidades[@]}"; do    
            echo "  * $habilidad"
        done
        echo "-----------------"
    fi
done