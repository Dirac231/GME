#!/bin/bash
homepath=/home/$(whoami)

echo -e "Welcome to the GME installer!\n\n"

read -p "Enter your GitHub username: " user
read -p "Enter your GitHub e-mail: " email; git config --global user.email "$email"
echo -e "\nHi $user! Go here: --> \"https://github.com/settings/tokens/new\" and create a token with \"repo\" scope\n"
read -p "Please enter your token: " token; echo $token > $homepath/.git_tok

echo -e "\n#----GME FUNCTIONS----" >> $homepath/.bashrc; echo -e "git_user=\"$user\"" >> $homepath/.bashrc
cat functions.sh >> $homepath/.bashrc; source $homepath/.bashrc

echo -e "\nAll done! Try to create a new repository with the command \"newrepo\""
