## What is this?
Git Made Easy is a set of functions to make git more comfortable and faster to use for newcomers, originally inspired by how accurate this picture is:\
![git](https://github.com/user-attachments/assets/00004763-3ef8-4425-b86f-68862313fbd1)
\
\
It supports both bash and ZSH environments.

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
