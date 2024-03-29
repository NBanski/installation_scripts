#!/bin/bash
while getopts ":u:sf:h" opt; do
        case ${opt} in
        u )
                USERNAME=$OPTARG
                adduser --gecos "" $USERNAME
                usermod -aG sudo $USERNAME
                ;;
        s )
                mkdir /home/$USERNAME/.ssh
                cp $HOME/.ssh/authorized_keys /home/$USERNAME/.ssh/authorized_keys
                chown --recursive $USERNAME:$USERNAME /home/$USERNAME/.ssh
                echo "SSH keys copied!"
                ;;
        f )
                PORT=$OPTARG
                sudo ufw enable 
                sudo ufw allow $PORT
                FILEPATH="/etc/ssh/sshd_config"
                PORT_OLD="#Port 22"
                PORT_NEW="Port $PORT"
                sudo sed -i "s/$PORT_OLD/$PORT_NEW/" $FILEPATH
                sudo sed -i "s/#PermitRootLogin /PermitRootLogin no/" $FILEPATH
                sudo sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" $FILEPATH
                echo "SSH port changed to $PORT."
                ;;
        h )
                echo "ServerHandyMan v1.0"
                echo "Simple tool designed to speed up the server preparation process."
                echo "-u username       adds a new user with elevated privileges"
                echo "-s        copies the root SSH keys to the new user"
                echo "-f port_number    changes the SSH port to a random port number, enables UFW, disables the root account and SSH password login"
                echo "-h        displays this prompt"
                ;;
        \? )
                echo "Invalid prompt. Use [-h] for help."
                break
                ;;
        esac
done
shift $((OPTIND -1))
