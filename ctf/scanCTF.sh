#!/bin/bash

# ./scanCTF.sh -t interfaz

# output: La ip de tu maquina ctf es -> 10.10.1.1

#colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c(){

	clear;
	sudo arp-scan -I $network_card_ --localnet --plain --ignoredups > /tmp/encendida 2>&1

	for ip in $(awk '{print $1}' /tmp/encendida); do
    	if ! grep -qw "$ip" /tmp/apagada; then
        	echo -e "\n${purpleColour}[+]${endColour}${blueColour} La IP de tu máquina CTF es -> ${endColour}${grayColour}$ip${endColour}\n"
			rm /tmp/encendida; rm /tmp/apagada
        	tput cnorm; exit 0

		fi
	done


}

function helpPanel(){

        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso: ./scanCTF.sh${endColour}\n"
        echo -e "\t${purpleColour}t)${endColour}${blueColour} Especifica el nombre de tu tarjeta de red${endColour}\n"
   	    echo -e "\t${grayColour} Ejemplo: ./portsClean.sh -t nombre${endColour}"
		echo -e "\n${redColour}[!]${endColour}${purpleColour} Tienes que ejecutar este script como root${endColour}\n"
        tput cnorm
}


function main(){
	network_card_=$(echo $network_card | xargs)
	echo -e "\n${purpleColour}[+]${endColour}${blueColour} Comprobando si tienes instalado arp-scan...${endColour}\n"
	sleep 2
	if [ -f /usr/sbin/arp-scan ];then

		echo -e "\n${purpleColour}[V]${endColour}${blueColour} arp-scan ${endColour}${greenColour}instalado${endColour}\n";sleep 2
		echo -e "\n${purpleColour}[+]${endColour}${blueColour} Comprobando que existe tu tarjeta de red...${endColour}\n"

		if [[ "$(ip a | grep -w "$network_card_" | awk '{print $2}' | head -n 1 | tr ':' ' ' | xargs)" == "$network_card_" ]]; then

			sudo arp-scan -I $network_card_ --localnet --plain --ignoredups > /tmp/apagada 2>&1;
			echo -e "\n${purpleColour}[+]${endColour} ${blueColour}Ahora que se ha realizado el escaneo de la red, enciende tu CTF${endColour}\n"; sleep 1
			echo -e "\n${purpleColour}[+]${endColour} ${blueColour}Una vez que esté encendida, presiona ${endColour}${greenColour}ctrl + c${endColour}\n"
			sleep 10000000000
		else
			echo -e "\n${purpleColour}[!]${endColour}${blueColour} La interfaz de red que has especificado ${endColour}${redColour}no existe${endColour}\n"
			tput cnorm;exit 0
		fi

	else

		echo -e "\n${purpleColour}[!]${endColour}${redColour} No tienes instalada la herramienta arp-scan${endColour}\n"
		echo -e "\n${purpleColour}[+]${endColour}${blueColour} Instalando...${endColour}\n"

		sudo apt install arp-scan >/dev/null 2>&1

		if [ $(echo $?) == 0 ];then
			main
		else
			echo -e "\n${purpleColour}[!]${endColour} No se ha podido instalar la herramienta, prueba a instalarla a mano${endColour}\n"
			tput cnorm;exit 0
		fi

	fi
}



tput civis
declare -i parameter_counter=0
if [ $(id -u) == 0 ];then

	while getopts ":t:h:" arg;do

		case $arg in
			t) network_card=$OPTARG; let parameter_counter+=1;;
			h) helpPanel;;
		esac
	done

		if [ $parameter_counter == 0 ];then

			helpPanel
			tput cnorm; exit 0

		else

			main

		fi
else

	helpPanel
	tput cnorm;exit 0
fi
