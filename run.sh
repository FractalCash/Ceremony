#!/bin/sh

## Environment
cd phase2
set -e

## Config
circuits=("wrap" "unwrap" "init-transfer" "complete-transfer")
maxRequiredRadix=15
verify=true
participant=5

## Style
underline=`tput smul`
nounderline=`tput rmul`
bold=`tput bold`
reset=`tput sgr0`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 136`

## Checks
if [ ! -d "./results" ]; then
    mkdir results
fi

if [ ! -f "./phase1radix2m$maxRequiredRadix" ]; then
    echo "Required radix files not found."
    exit 1
fi

for element in "${circuits[@]}"
do
    if [ ! -f "./$element.json" ]; then
        echo "Required circuit file for $element not found."
        exit 1
    fi

    if [ ! -f "./circuit_${element}_$((participant-1)).params" ]; then
        echo "File circuit_${element}_$((participant-1)).params not found."
        exit 1
    fi
done

## Intro
echo "${bold}${green}[ WELCOME TO FRACTAL CASH CEREMONY ]${reset}"
echo "Thank you so much for participating in this ceremony and"
echo "helping the community to ensure the safety of Fractal Cash.\n" 

echo "The process is mostly automatic, we will only need you to introduce entropy during the"
echo "process, such random values, a bunch of characters or a sentence from your favorite book.\n"

## Contribution process
for element in "${circuits[@]}"
do
    echo "Please, enter entropy for $element: " 
    echo "${yellow}(Remember, any text string, the longer the better)${reset}" 
    read entropy

    {
        echo "\nRunning contribution...\n"
        cargo run --release --bin contribute "circuit_${element}_$((participant-1)).params" "circuit_${element}_$((participant)).params" "$entropy"
        
        if ($verify)
        then
            echo "\nVerifying contribution...\n"
            cargo run --release --bin verify_contribution "$element.json" "circuit_${element}_$((participant-1)).params" "circuit_${element}_$((participant)).params"
        fi

        cp circuit_${element}_$((participant)).params results/
    }
done

## Result ZIP
{
    echo "\nGenerating result file...\n"
    zip -r fractal_participation.zip results/
    mv fractal_participation.zip ../
}

## Clean
# rm -rf results/

## Thanks
echo "\n${bold}${red}WELL DONE!${reset} Finally, send fractal_participation.zip file to the Fractal Cash team."
