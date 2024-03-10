When using Nix-manager Unstable, please place the script into /bin under your home folder for the intended experience.

Issues will occur! (if not obvious already) Make sure to report issues, as well as any fixes/optimizations, I'm new to shell scripts, help me out, you help everyone out.

Make sure git is added to your config file or the editor will not be able to receive the the NixOS-Editor extras, this can be bypassed by placing the folders in /home/relo/Nix-manager/tools/, but git is recommended.

Known Issues:
Nix-manager is supposed to warn the user if 'git' was not found in the user's configuration.nix, if the user has any package, or comment with the word git in it, Nix-manager will not warn the user, the git clone will fail.
The test command prompts the user to enter a package name, Nix-manager tells the user to type that package anyway, Nix-shell will fail but this is still an issue.




