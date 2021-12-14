# developer-setup

This playbook installs and configures macOS or Ubuntu with development tools.

## Installation

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jakoberpf/developer-setup/HEAD/install.sh)"
```

**Note** If some Homebrew commands fail, you might need to agree to Xcode's license or fix some other Brew issue. Run `brew doctor` to see if this is the case.

## Overriding Defaults

Not everyone's development environment and preferred software configuration is the same.

You can override any of the defaults configured in `default.config.yaml` by creating a `config.yaml` file and setting the overrides in that file. For example, you can customize the installed packages and apps with something like:

    homebrew_installed_packages:
      - git

Any variable can be overridden in `config.yaml`; see the supporting roles' documentation for a complete list of available variables.

## Included Applications / Configuration (Default)

Applications (installed with Homebrew Cask):

- [Docker](https://www.docker.com/)
- [Google Chrome](https://www.google.com/chrome/)
- [LICEcap](http://www.cockos.com/licecap/)
- [Slack](https://slack.com/)
- [Atom](https://atom.io/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Intellij Idea](https://www.jetbrains.com/idea/)
- 

Packages (installed with Homebrew):

- ccache
- bash-completion
- gpg
- mcrypt
- openssl
- readline
- sqlite3
- xz
- zlib
- mas
- wget
- gifsicle
- git
- nmap
- ssh-copy-id
- pyenv
- tfenv

## TODOs

- Make visual documentation like <https://sourabhbajaj.com/mac-setup/> as github pages
- Setup git precommit hook for cleaning script with ``sed -i -e 's/\r$//' <scriptname>.sh``
