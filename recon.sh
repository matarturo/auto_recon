#!/bin/bash
# Script: recon.sh
# Autor: Arturo Mata <arturo.mata@gmail.com>
# Version: 1.0.0
# Repositorio: https://github.com/matarturo/
# Released under the GNU General Public License WITHOUT ANY WARRANTY.
# See LICENSE.TXT for details.

# Script para detectar hosts vulnerables a exploits, usando Nmap y Metasploit

if [ -z “$1” ]
then
                echo “Usar: ./recon.sh <IP>”
                exit 1
fi
printf  "\n-----NMAP-----\n" > resultados
echo “Arrancando Nmap…”
nmap $1 | tail -n +5 | head -n -3 >> resultados
while read line
do
                if [[ $line = *open* ]] && [[ $line = *http* ]]
                then
                        echo “Arrancando Gobuster…”
                        gobuster dir -u $1 -w /usr/share/wordlist/dirb/common.txt -qz > temp1
                echo “Arrancando WhatWeb…”
                whatweb $1 -v > temp2
                fi
done < resultados
if [ -e temp1 ]
then
                printf “\n-----DIRS-----\n” >> resultados
                cat temp1 >> resultados
                rm temp1
fi
if [ -e temp2 ]
then
                printf “\n------WEB-------\n” >> resultados
                cat temp2 >> resultados
                rm temp2
fi
cat resultados
