# dotfiles
My config files for setting up my system

## zsh

This is a git subtree of [zsh-quickstart-kit](https://github.com/unixorn/zsh-quickstart-kit). To update, follow the git subtree update strategy [outlined by Atlassian blog](https://www.atlassian.com/git/tutorials/git-subtree):

```bash
git fetch zsh-quickstart-kit master
git subtree pull --prefix zsh zsh-quickstart-kit master --squash
```

### Adding zsh completions

Here is how you can add new zsh completions, like adding Google Cloud SDK completions as indicated in `brew` caveats

```bash
mkdir -p ~/.zsh-completions
ln -s /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc ~/.zsh-completions/path.zsh.inc
ln -s /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc ~/.zsh-completions/completion.zsh.inc
```