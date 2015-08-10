# Dotfiles Neue by Clayton Ferris

## Setup

### OSX

Install XCode Tools

```bash
xcode-select --install
```

Install [Homebrew](http://brew.sh)

```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Install Ansible

```bash
brew install ansible
```

Clone this repo

```bash
git clone https://github.com/theshortcut/dotfiles-neue.git ~/src/dotfiles-neue
```

Run the Ansible playbook

```bash
cd ~/src/dotfiles-neue
./launch
```
