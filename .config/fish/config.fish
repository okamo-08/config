# --- Homebrew PATH (Apple Silicon) ---
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
end

# --- Rancher Desktop ---
if test -d $HOME/.rd/bin
    fish_add_path $HOME/.rd/bin
end

# --- 環境の静音化（不要なメッセージ抑制）---
set -gx HOMEBREW_NO_ENV_HINTS 1

# --- direnv (プロジェクト毎の .envrc を有効化) ---
if type -q direnv
    direnv hook fish | source
end

# --- zoxide (cd の賢い代替: `z`, `zi`) ---
if type -q zoxide
    zoxide init fish | source
end

# --- atuin (履歴の拡張。↑で検索、Ctrl-rの代替も可) ---
if type -q atuin
    atuin init fish | source
end

# --- eza があれば ls を置き換え（abbr = 入力展開。学習コスト低）---
if type -q eza
    abbr -a ls eza
    abbr -a ll 'eza -l'
    abbr -a la 'eza -la'
    abbr -a tree 'eza --tree'
end

# --- Git よく使うコマンド（abbr はタイプ中に展開）---
abbr -a g git
abbr -a gst 'git status'
abbr -a gco 'git checkout'
abbr -a gci 'git commit'
abbr -a gbr 'git branch'
abbr -a glg 'git log --oneline --graph --all'
abbr -a gl1 'git log -1 HEAD'
abbr -a gfix 'git commit --fixup'
abbr -a gri 'git rebase -i'

# --- エディタ等（必要に応じて）---
set -gx EDITOR nvim # neovim を避けるなら必要に応じて
set -gx VISUAL "$EDITOR"

if test -d $HOME/.amp/bin
    fish_add_path $HOME/.amp/bin
end
