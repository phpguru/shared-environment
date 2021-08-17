# Shared Environment (shenv)

## Overview

The shared environment consists of 

- Bash shortcuts - aliases and custom functions
- Docker shortcuts - aliases and custom functions
- Git completion - to make common git commands faster in terminal
- Git prompt - to make git branch name tab completion and bash prompt better

## Usage

1. Clone the repository to ~/.shenv, 
1. Add the following code to your ~/.bashrc (Linux) or ~/.bash_profile (Mac)
1. Reload your terminal or `source ~/.bashrc`

```
for file in ~/.shenv/*.sh;
do
    source $file
done
```
