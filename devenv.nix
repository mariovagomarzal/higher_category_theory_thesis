{pkgs, ...}: {
  env = {
    GREET = "Thesis development environment";
  };

  languages.typst = {
    enable = true;
    fontPaths = ["${pkgs.lmodern}/share/fonts/opentype/public/lm"];
  };

  packages = with pkgs; [
    just
    git
  ];

  git-hooks = {
    hooks = {
      gitlint = {
        enable = true;
        description = "Run gitlint to check commit messages";
        stages = ["commit-msg"];
      };

      markdownlint = {
        enable = true;
        excludes = ["^website/"];
        description = "Run markdownlint to check Markdown files";
      };

      alejandra = {
        enable = true;
        description = "Run the Alejandra formatter on Nix files";
      };
    };
  };

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

  enterShell = ''
    echo $GREET
  '';
}
