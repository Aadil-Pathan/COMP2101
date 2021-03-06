#!/bin/bash
#
# This script is for the bash lab on variables, dynamic data, and user input
# Download the script, do the tasks described in the comments
# Test your script, run it on the production server, screenshot that
# Send your script to your github repo, and submit the URL with screenshot on Blackboard

# Get the current hostname using the hostname command and save it in a variable
hostname=$(hostname)


# Tell the user what the current hostname is in a human friendly way
echo "Your Current Hostname is : $hostname"


# Ask for the user's student number using the read command
echo "Please enter your Student number : "
read studentNumber


# Use that to save the desired hostname of pcNNNNNNNNNN in a variable, where NNNNNNNNN is the student number entered by the user
var=ps$studentNumber


# If that hostname is not already in the /etc/hosts file, change the old hostname in that file to the new name using sed or something similar and
#     tell the user you did that
#e.g. sed -i "s/$oldname/$newname/" /etc/hosts
sudo sed -i "s/$hostname/$var/" /etc/hosts && echo "You have successfully changed your hostname to $var"


# If that hostname is not the current hostname, change it using the hostnamectl command and
#     tell the user you changed the current hostname and they should reboot to make sure the new name takes full effect
#e.g. hostnamectl set-hostname $newname
[[ $hostname != $var ]] && (hostnamectl set-hostname $var && echo "You have successfully added the $var hostname and should reboot your system to apply changes")
