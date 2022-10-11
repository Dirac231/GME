revert(){
  gitdir=`git rev-parse --is-inside-work-tree 2>/dev/null`
  if [ -z $gitdir ]
  then
    echo "It seems like you are not inside a git working tree!"
    return 1
  fi
	
  cur_branch=`git status | head -n 1 | awk -F " " '{print $3}'`
  last_hash=`git reflog | head -n 1 | awk -F" " '{print $1}'`
  git revert --no-commit $last_hash; git commit -m "Reverted last commit"; git push -u origin $cur_branch >/dev/null
}

commit(){
	gitdir=`git rev-parse --is-inside-work-tree 2>/dev/null`
	if [ -z $gitdir ]
	then
		echo "It seems like you are not inside a git working tree!"
		return 1
	fi

	cur_branch=`git status | head -n 1 | awk -F " " '{print $3}'`

	if [ -z $1 ]
	then
		read com_mes\?"Your commit message: "
		git add -A; git commit -m "$com_mes"; git push -u origin $cur_branch >/dev/null

	elif [ -f $1 ]
	then
		read com_mes\?"Your commit message: "
		git add $1; git commit -m "$com_mes"; git push -u origin $cur_branch >/dev/null
	else
		echo -e "File or folder \"$1\" does not exist!"
	fi
}

br(){
  gitdir=`git rev-parse --is-inside-work-tree 2>/dev/null`
  if [ -z $gitdir ]
  then
    echo "It seems like you are not inside a git working tree!"
    return 1
  fi
	
	tmpb=`cat $(git rev-parse --show-toplevel)/.git/config | grep -E "\[branch" | sed -e 's/\"\(.*\)\"/\1/' | sed 's/[][]//g' | awk -F" " '{print $2}'`

	if [ -z "$1" ]
	then
   		echo -e "Branches:"; echo -e "--------------"; echo $tmpb; echo "---------------"
		return 1
	fi

	if [[ $tmpb == *"$1"* ]]
	then
		git checkout $1
	else
		git checkout -b $1; git add -A; git commit -m "Created \"$1\" branch"; git push -u origin $1 >/dev/null
	fi
}

undo(){
        gitdir=`git rev-parse --is-inside-work-tree 2>/dev/null`
        if [ -z $gitdir ]
        then
                echo "It seems like you are not inside a git working tree!"
                return 1
        fi

	      git reset --soft HEAD~1; git pull
}

pullreq(){
        gitdir=`git rev-parse --is-inside-work-tree 2>/dev/null`
        if [ -z $gitdir ]
        then
                echo "It seems like you are not inside a git working tree!"
                return 1
        fi

	mast=`br | grep -E ^m | head -n 1`
	cur_branch=`git status | head -n 1 | awk -F " " '{print $3}'`

	read title\?"Pull Request Title: "
	read body\?"Message Body: "

	upst=`git remote -v | grep upstream | awk -F " " '{print $2}' | head -n 1 | awk -F "@" '{print $2}'`
	owner=`echo $upst | awk -F "/" '{print $2}'`
	uprep=`echo $upst | awk -F "/" '{print $3}' | awk -F "." '{print $1}'`

	curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer `cat /home/$(whoami)/.git_tok`" https://api.github.com/repos/$owner/$uprep/pulls -d '{"title":"'$title'","body":"'$body'","head":"'$git_user':'$cur_branch'","base":"'$mast'"}' &>/dev/null
	echo -e "\nCreated pull request --> https://${upst}/pulls"
}

pull(){
        gitdir=`git rev-parse --is-inside-work-tree 2>/dev/null`
        if [ -z $gitdir ]
        then
                echo "It seems like you are not inside a git working tree!"
                return 1
        fi

	if [ -z $(git remote -v | grep upstream) ]
	then
		rem="origin"
	else
		rem="upstream"
	fi

	mast=`br | grep -E ^m | head -n 1`; git fetch $rem; br $mast

        echo $(git merge --no-commit --no-ff $rem/$mast) > .~tmp_mrg_chk
        if grep -q 'merge failed;' .~tmp_mrg_chk
        then
                echo -e "\nMerge with \"$sel_branch\" has failed due to these file conflicts:"
                echo "- - - - - - - - - - - - - - -"
                echo $(git diff --name-only --diff-filter=U) > .~tmp_mrg_fls
                while read p; do echo -e "In file: \"$p\"\n-------------" && cat $p | grep "=======" -C 4 -n && echo -e "-------------\n"; done < .~tmp_mrg_fls
                echo -e "Aborting the merge..."; git merge --abort; rm .~tmp_mrg_chk .~tmp_mrg_fls
        else
                rm .~tmp_mrg_chk; git add -A; git commit -m "Merged $rem/$mast in $mast"; git push -u origin $mast
        fi

}

fork(){
	OWNER=`echo $1 | awk -F "/" '{print $4}'`
	REPO=`echo $1 | awk -F "/" '{print $5}'`

	echo -e "Forking repository and updating...\n"

	curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: Bearer `cat /home/$(whoami)/.git_tok`" https://api.github.com/repos/$OWNER/$REPO/forks &>/dev/null
	git clone https://github.com/$git_user/$REPO &>/dev/null && cd $REPO

	git remote set-url origin https://`cat /home/$(whoami)/.git_tok`@github.com/$git_user/$REPO
	git remote add upstream https://`cat /home/$(whoami)/.git_tok`@github.com/$OWNER/$REPO

	br dev; sync
}

ignore(){
        gitdir=`git rev-parse --is-inside-work-tree 2>/dev/null`
        if [ -z $gitdir ]
        then
                echo "It seems like you are not inside a git working tree!"
                return 1
        fi

	read ign\?"Input extensions to ignore (as comma-separated list): "
	touch .gitignore; echo $ign | tr ',' '\n' >> .gitignore
}

newrepo(){
	cur=`pwd`
	tok=`cat /home/$(whoami)/.git_tok`
	read repo\?"Enter repo name: "

	echo -e "\nCreating private repo \"$repo\"...\n"
	curl -H "Authorization: token $tok" --data '{"name":"'$repo'","private":true}' https://api.github.com/user/repos &>/dev/null
	mkdir -p .$repo && cd "$_"

	echo "## First readme" > README.md; git init; git checkout -b main &>/dev/null; git add README.md &>/dev/null
	git commit -m "First commit" &>/dev/null; git remote add origin https://$tok@github.com/$git_user/$repo.git &>/dev/null
	git push -u origin main &>/dev/null

	echo -e "Repository \"$repo\" created at: \"$(pwd)\""
}

pushrepo(){
  tok=`cat /home/$(whoami)/.git_tok`
  gitdir=`git rev-parse --is-inside-work-tree 2>/dev/null`
  if [ ! -z $gitdir ]; then
                echo "Warning! You are already inside a local repo!"
                read resp\?"Would you like to remove \".git\" and push the project to a new repo? (Y/N)"
                if [[ $resp =~ ^[Yy]$ ]]; then
                              cd $(git rev-parse --show-toplevel); rm -rf .git
                              echo "Done, try to pushrepo now"
                              exec zsh
                else
                        echo "Exiting..."
                        exec zsh
                fi
  fi
  
  if [ -z "$(ls -A $(pwd))" ]; then

        echo "## Readme" > README.md;
        echo "Folder is empty! Added README.md"
        echo "Try to pushrepo again"; exec zsh

  fi
  
  read repo\?"Enter the repo name: "; b_cur=$(basename $(pwd)); cd ..; mv $b_cur $repo; cd $repo
  
  echo -e "\nCreating private repo \"$repo\"...\n"
  curl -H "Authorization: token $tok" --data '{"name":"'$repo'","private":true}' https://api.github.com/user/repos &>/dev/null
  
  git init; git checkout -b main; git add -A; git commit -m "Pushing local repo"; git remote add origin https://$tok@github.com/Dirac231/$repo.git; git push -u origin main
  echo -e "\nDONE\n"
}

merge(){
        gitdir=`git rev-parse --is-inside-work-tree 2>/dev/null`
        if [ -z $gitdir ]
        then
                echo "It seems like you are not inside a git working tree!"
                return 1
        fi

	cur_branch=`git status | head -n 1 | awk -F " " '{print $3}'`

	cat $(git rev-parse --show-toplevel)/.git/config | grep -E "\[branch" | grep -oP '"\K[^"\047]+(?=["\047])' --color=none | grep -v "$cur_branch" > tmp

	echo -e "\nSELECT A BRANCH TO MERGE IN \"$cur_branch\":\n"; cat --number tmp; read num
	sel_branch=`sed "${num}q;d" tmp`; rm tmp

	echo $(git merge --no-commit --no-ff $sel_branch) > .~tmp_mrg_chk
	if grep -q 'merge failed;' .~tmp_mrg_chk
	then
		echo -e "\nMerge with \"$sel_branch\" has failed due to these file conflicts:"
		echo "- - - - - - - - - - - - - - -"
		echo $(git diff --name-only --diff-filter=U) > .~tmp_mrg_fls
		while read p; do echo -e "In file: \"$p\"\n-------------" && cat $p | grep "=======" -C 4 -n && echo -e "-------------\n"; done < .~tmp_mrg_fls
		echo -e "Aborting the merge..."; git merge --abort; rm .~tmp_mrg_chk .~tmp_mrg_fls
	else
		rm .~tmp_mrg_chk; git add -A; git commit -m "Merged $sel_branch in $cur_branch"; git push -u origin main
	fi
}
