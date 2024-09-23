#!/bin/bash
entrada=$(</dev/stdin)
pokemon_csv=$(find -name pokemon.csv)
pokemon_abilities_csv=$(find -name pokemon_abilities.csv)
ability_names_csv=$(find -name ability_names.csv)


buscar_ids_habilidades(){
    habilidades_id=()
    filas=$(cut -d "," -f1,2 $pokemon_abilities_csv | grep -w ^$1,*)
    indice=0
    for fila in $filas;
        do
        habilidades_id[indice]=$(echo $fila | cut -d "," -f2)
        indice=$(($indice + 1))
    done
    echo ${habilidades_id[@]}
}

buscar_nombres_habilidades(){
    lines=$(cut -d "," -f1,2,3 $ability_names_csv | grep -w ^$1,7,*)
    for line in $lines; do
        nombre_habilidad+="$(echo $line | cut -d "," -f3) "
    done
    echo $nombre_habilidad
}



for pokemon_entrada in $entrada; do
    if [[ "${pokemon_entrada}" =~ [^a-zA-Z]"-" ]];then
        echo "$pokemon_entrada no es un pokemon"    
    fi
    pokemon_datos=$(cut -d "," -f1,2,4,5 $pokemon_csv | grep ,$pokemon_entrada, 2>/dev/null)
    if [[ $? != 0 ]]; then 
        echo "$pokemon_entrada no esta en la pokedex"
        continue
    else
        altura=$(($(echo $pokemon_datos | cut -d "," -f3) *10 ))
        peso=$(echo $pokemon_datos | cut -d "," -f4)
        ids_habilidades=($(buscar_ids_habilidades $(echo $pokemon_datos | cut -d "," -f1)))
        echo "-----------------"
        echo "Pokemon: $pokemon_entrada"
        echo "Altura: $altura centimetros"
        if [[ $peso -ge 10 ]]; then 
            echo "Peso: $(($peso / 10)) kilos"
        else
            echo "Peso: 0.$peso kilos"
        fi
        echo
        echo "Habilidades:"
        for id_habilidad in ${ids_habilidades[@]}; do
        habilidad=$(buscar_nombres_habilidades $id_habilidad)
            echo "  * $habilidad"
        done
        echo "-----------------"
    fi
done
exit 0