{ config, ... }:
{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      side-by-side = true;
    };
  };

  programs.git = {
    enable = true;
    ignores = [ ".DS_Store" ];

    signing = {
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      signByDefault = true;
    };

    settings = {
      user = {
        name = "Clayton Ferris";
        email = "cferris@gmail.com";
      };

      alias = {
        co = "checkout";
        b = "branch";
        fixup = "!sh -c 'git commit -m \"fixup! $(git log -1 --format='\\''%s'\\'' $@)\"' -";
        fi = "!sh -c 'git commit -m \"fixup! $(git log -1 --format='\\''%s'\\'' $@)\"' -";
        squash = "!sh -c 'git commit -m \"squash! $(git log -1 --format='\\''%s'\\'' $@)\"' -";
        ri = "rebase --interactive --autosquash";
        prp = "!git pull --rebase && git push";
        ciam = "commit --am -C HEAD";
        praise = "blame";
        st = "status -sb";
        s = "status -s";
        suri = "submodule update --init --recursive";
        sui = "submodule update --init";
        su = "submodule update";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)%Creset' --abbrev-commit";
        ci = "commit";
        ready = "rebase -i @{u}";
        standup = "!git log --since yesterday --author `git config user.email` --pretty=short";
        purr = "pull --rebase";
        aliases = "config --get-regexp ^alias\\.";
      };

      init.defaultBranch = "main";
      pull.ff = "only";
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      branch.autosetupmerge = true;
      merge.conflictstyle = "diff3";
      apply.whitespace = "warn";
      tag.forceSignAnnotated = true;
      diff.colorMoved = "default";
      color = {
        status = "auto";
        branch = "auto";
        diff = "auto";
      };
      gui = {
        matchtrackingbranch = true;
        pruneduringfetch = true;
      };
    };
  };
}
