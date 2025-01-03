# System helper scripts

Due to the fact that some shells don't respect my enviroment variables, the variable $HOME/.config/scripts is used.
This unfortionally breaks $XDG_CONFIG_HOME if set to something other than default, and you will have to change the paths manually.

For the scripts to function like intended the following should be appended to visudo, and replace USER with your username 
```
ALL ALL=(ALL) NOPASSWD: /home/USER/.config/scripts/*
```

## Security
This in of itself is a big security voulnerability due to the fact that anyone could modify the content of the files and run them as sudo.
For this reason, it should be mandatory to change the ownership of the folder to root `sudo chown -R root:root ~/.config/scripts`. And that you change the permissions to make it readonly and executable for normal users`sudo chmod -R 755 ~/.config/scripts`.

As a minor side effect you will now have to modify the scripts with `sudo $EDITOR` or `sudoedit`.
