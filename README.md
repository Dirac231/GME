## What is this?
Git Made Easy is a set of functions to make git more comfortable and faster to use.\
\
It supports both bash and ZSH environments

## Yes, but why?

1 - If you mess up a commit, you need to remember long commands, maybe open a cheat sheet or two, and then fix the problem. With GME you just do "undo" and fix the mistake, or "revert" if you really messed up.
2 - You don't have to worry about your local and remote being async ever again, "pull" will sync your local main, and the common push workflow is done with only the "commit" command
3 - Merge conflicts? Nah, GME will display the conflicts for you while gracefully terminating the merge before a disaster happens, you can merge with no worries!
4 - Have to push your local project to github? Just do "pushrepo" while in the folder and it's done.
3 - You can move, create, switch and rename branches on the fly synchronously with a simple "br" command
4 - Pull requests, forks, upstreams are boring to deal with. In GME you just do "pullreq" after a "commit", and "fork" works by taking the URL. To sync your main with the upstram just do "pull"!

## Installation

1) Clone this repository and run ```bash setup.sh``` from the main folder
2) Follow the instructions on your terminal, after finishing you can remove the cloned repository safely

You should be able of using the project by only installing ```git``` and ```curl```, as other tools should be native to most linux distros

## Commands
- ```newrepo``` - Creates a new private repository asking for a name
- ```pushrepo``` - Converts a local project folder in a private repository, also supports unlinked local repos and empty folders

-----

- ```br``` - Lists the branches in the current repository 
- ```br [branch]``` - Moves to another branch, if the branch doesn't exist it creates it
- ```rename [old] [new]``` - Renames the "old" branch to the "new" branch

-----

- ```commit``` - Updates the repository by including all the changes
- ```commit [file_or_dir]``` - Updates the repository by including only the changes of a file or directory
- ```undo``` - Undoes the last "commit" command, keeping all the changed files so that you can fix the error, and "commit" again
- ```revert``` - Fully reverts the repository before the last commit, useful for accident deleting or when commits go wrong

-----

- ```merge``` - Merges a chosen branch with your current one. Handles conflicts by showing them and aborting the merge
- ```pull``` - Updates your main branch with the remote main branch, works automatically also in case of upstreams with forked repos
-----

- ```fork [repo_url]``` - Forks a repository by passing its github URL, creates a "dev" branch
- ```pullreq``` - After a "commit", use this to do a pull request from a branch of your fork to the "main" of the original repo
