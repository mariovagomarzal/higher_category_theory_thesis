{pkgs, ...}: {
  env = {
    GREET = "Thesis development environment";
  };

  # Typst support.
  languages.typst = {
    enable = true;
    fontPaths = [
      "${pkgs.eb-garamond}"
      "${pkgs.texlivePackages.garamond-math}"
      "${pkgs.fira-sans}"
      "${pkgs.julia-mono}"
    ];
  };

  # Typst-related environment variables.
  env = {
    TYPST_ROOT = "thesis";
    TYPST_IGNORE_SYSTEM_FONTS = "true";
  };

  # Python support.
  languages.python.enable = true;

  # Core development tools.
  packages = with pkgs; [
    just
    git
  ];

  # Git hooks.
  git-hooks = {
    hooks = {
      gitlint = {
        enable = true;
        description = "Run gitlint to check commit messages";
        stages = ["commit-msg"];
      };

      markdownlint = {
        enable = true;
        description = "Run markdownlint to check Markdown files";
      };

      alejandra = {
        enable = true;
        description = "Run the Alejandra formatter on Nix files";
      };
    };
  };

  # Extra configuration files to symlink.
  files = {
    ".gitlint".ini = {
      general = {
        contrib = "contrib-title-conventional-commits";
        ignore = "body-is-missing";
      };

      title-max-length.line-length = 120;
      body-max-line-length.line-length = 120;
    };
  };

  # Enter shell task.
  enterShell = ''
    echo $GREET
  '';
}
