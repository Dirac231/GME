## What is this?
Git Made Easy is a collection of functions to make git more comfortable to use.

## Installation

1) Clone this repository and run ```bash setup.sh``` from the main folder
2) Follow the instructions on your terminal

You should be able of using the project by only installing ```git``` and ```curl```, as other tools should be native to most linux distros

## Commands
- ```newrepo``` - Asks you for a name and creates a new private repository with that name and a README.md file
- ```pushrepo``` - While inside a local project folder, "pushrepo" converts it to a private repository with the same name
- ```ignore``` - Adds a .gitignore file, asks you to input a comma-separated list (*.py, *.c, data/, ...)

-----

- ```br``` - Lists the branches in the repository you're navigating
- ```br [branch]``` - Creates/Moves to another branch

-----

- ```commit``` - Stages, commits and pushes every change you made to the repository, asks for a non-empty message.
- ```commit [file_or_dir]``` - Stages, commits and pushes only the specified directory or single file that you changed, asks for a non-empty message.
- ```undo``` - Reverts the last "commit" command, keeping all the changed files so that you can fix the error, and "commit" again

-----

- ```merge``` - Merges another branch with your current one. In case of conflicts, it doesn't merge and displays every conflict for fixing
- ```pull``` - Updates your main branch with the remote main branch, works automatically also in case of upstreams with forked repos
-----

- ```fork [repo_url]``` - Forks a repository by passing its github URL, creates a "dev" branch synced with the upstream
- ```pullreq``` - After a "commit", use this to do a pull request from a branch of your fork to the "main" of the original repo
