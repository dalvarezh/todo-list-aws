#!/bin/bash

source todo-list-aws/bin/activate
set -x

## Imprime los ficheros con menos de clasificación C y contamos las lineas. Si hay 0 lineas es que todo está por encima de C
## Test for Cyclomatic Complexity
RAD_ERRORS=$(radon cc src -nc | wc -l)

if [[ $RAD_ERRORS -ne 0 ]]
then
    echo 'Ha fallado el análisis estático de RADON - CC'
    exit 1
fi
## Testo for Maintainability Index
RAD_ERRORS=$(radon mi src -nc | wc -l)
if [[ $RAD_ERRORS -ne 0 ]]
then
    echo 'Ha fallado el análisis estático de RADON - MI'
    exit 1
fi

flake8 src/*.py
if [[ $? -ne 0 ]]
then
    exit 1
fi
bandit src/*.py
if [[ $? -ne 0 ]]
then
    exit 1
fi