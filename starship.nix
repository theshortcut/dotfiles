let
  # Powerline glyphs generated via fromJSON (Nix has no \u escape), so the
  # source stays free of raw private-use characters.
  lc = builtins.fromJSON ''"\ue0b6"''; # left rounded cap
  rc = builtins.fromJSON ''"\ue0b4"''; # right rounded cap
  rw = builtins.fromJSON ''"\ue0b0"''; # right wedge
  lw = builtins.fromJSON ''"\ue0b2"''; # left wedge
  gitSym = builtins.fromJSON ''"\ue0a0"''; # git branch icon

  col = {
    dir = "#A277FF";
    git = "#FF6767";
    jj = "#FFB454";
    lang = "#61FFCA";
    pkg = "#82E2FF";
    time = "#6D6D6D";
    fg = "#15141B";
  };
in
{
  programs.starship = {
    enable = true;
    settings = {
      # Angled powerline chain. The VCS segment is one of three mutually
      # exclusive custom modules — git (red) / jj (amber) / novcs (no-op) —
      # each carrying its own incoming (dir→vcs) and outgoing (vcs→lang)
      # wedges so the chain stays connected and correctly colored in all cases.
      format = builtins.concatStringsSep "" [
        "[${lc}](${col.dir})$directory" # directory (purple)
        "\${custom.git}\${custom.jj}\${custom.novcs}" # VCS wedge: git / jj / none
        "$nodejs$rust$terraform[${rw}](fg:${col.lang} bg:${col.pkg})$package[${rw}](fg:${col.pkg})" # languages (green) + package (blue)
        "$fill[${lw}](${col.time})$time[${rc}](${col.time})" # clock (gray, right-aligned)
        "$line_break$jobs$status$shell$character" # input line
      ];
      command_timeout = 1000;

      directory = {
        style = "bg:#A277FF fg:#15141B";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = " ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      # jj segment — shown only in jj repos (jj root walks up from subdirs).
      custom.jj = {
        when = "jj root --ignore-working-copy";
        shell = [ "sh" ];
        command = ''
          jj log --ignore-working-copy --no-graph --color never -r @ -T '
            separate(" ",
              change_id.shortest(8),
              bookmarks.join(" "),
              if(empty, "(empty)"),
              if(conflict, "×conflict"),
              if(divergent, "÷divergent"),
            )'
        '';
        symbol = "jj ";
        format = "[${rw}](fg:${col.dir} bg:${col.jj})[ $symbol$output ](bg:${col.jj} fg:${col.fg})[${rw}](fg:${col.jj} bg:${col.lang})";
      };

      # git segment — shown only in git repos that are NOT jj repos.
      # Simpler than native git_status: branch + dirty dot + ahead/behind.
      custom.git = {
        when = "git rev-parse --is-inside-work-tree >/dev/null 2>&1 && ! jj root --ignore-working-copy >/dev/null 2>&1";
        shell = [ "sh" ];
        command = ''
          b=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
          d=""; [ -n "$(git status --porcelain 2>/dev/null)" ] && d=" ●"
          a=$(git rev-list --count '@{u}'..HEAD 2>/dev/null); h=$(git rev-list --count HEAD..'@{u}' 2>/dev/null)
          ab=""; [ "''${a:-0}" -gt 0 ] && ab="$ab ⇡$a"; [ "''${h:-0}" -gt 0 ] && ab="$ab ⇣$h"
          printf '%s%s%s' "$b" "$d" "$ab"
        '';
        symbol = "${gitSym} ";
        format = "[${rw}](fg:${col.dir} bg:${col.git})[ $symbol$output ](bg:${col.git} fg:${col.fg})[${rw}](fg:${col.git} bg:${col.lang})";
      };

      # Fallback when in neither a git nor jj repo: just the dir→lang wedge,
      # so the angled chain stays connected. `true` emits no output but the
      # module still renders its format (the wedge) when `when` passes.
      custom.novcs = {
        when = "! { git rev-parse --is-inside-work-tree >/dev/null 2>&1 || jj root --ignore-working-copy >/dev/null 2>&1; }";
        shell = [ "sh" ];
        command = "true";
        format = "[${rw}](fg:${col.dir} bg:${col.lang})";
      };
      nodejs = {
        style = "bg:#61FFCA fg:#15141B";
        format = "[ $symbol ($version) ]($style)";
      };
      rust = {
        style = "bg:#61FFCA fg:#15141B";
        format = "[ $symbol ($version) ]($style)";
      };
      terraform = {
        style = "bg:#61FFCA fg:#15141B";
        format = "[ $symbol$workspace ]($style)";
      };
      package = {
        format = "[ $symbol ($version) ]($style)";
        style = "bg:#82E2FF fg:#15141B";
      };
      gcloud = {
        disabled = true;
      };
      fill = {
        symbol = " ";
      };
      character = {
        format = " $symbol ";
        error_symbol = "[](bold red)";
      };
      time = {
        disabled = false;
        format = "[$time]($style)";
        time_format = "%-I:%M:%S %p";
        style = "bg:#6D6D6D fg:#14141B";
      };
    };
  };
}
