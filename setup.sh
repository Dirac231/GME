#!/bin/bash -i
homepath=/home/$(whoami)

echo -e "Welcome to the GME installer!\n\n"

read -p "Enter your GitHub username: " user
read -p "Enter your GitHub e-mail: " email; git config --global user.email "$email"
echo -e "\nHi $user!" 
echo -e "Go here: \"https://github.com/settings/tokens/new\" and create a token with \"repo\" and \"workflow\" scopes\n"
read -p "Please enter your token: " token; echo $token > $homepath/.git_tok

echo -e "\nSelect your version"
echo "1) Bash"
echo "2) ZSH"
read sel

if [ $sel = 1 ]
then
  echo -e "\n#----GME FUNCTIONS----" >> $homepath/.bashrc; echo -e "git_user=\"$user\"" >> $homepath/.bashrc
  cat bash_functions.sh >> $homepath/.bashrc
  echo -e "\nAll done! Try to create a new repository with the command \"newrepo\""
  exec bash
else
  echo -e "\n#----GME FUNCTIONS----" >> $homepath/.zshrc; echo -e "git_user=\"$user\"" >> $homepath/.zshrc
  cat zsh_functions.sh >> $homepath/.zshrc
  echo -e "\nAll done! Try to create a new repository with the command \"newrepo\""
  exec zsh
fi
