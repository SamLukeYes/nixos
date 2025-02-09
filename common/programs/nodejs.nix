{ ... }:

{
  programs.npm = {
    enable = true;
    npmrc = ''
      prefix = ''${HOME}/.npm
      registry = https://repo.nju.edu.cn/repository/npm/
    '';
  };

  users.persistence.directories = [
    ".npm"
  ];
}