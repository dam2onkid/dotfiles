# dotfiles

Cấu hình shell và AI coding agents tập trung một chỗ, quản lý qua symlink.

## Yêu cầu trước

- macOS + zsh (shell mặc định)
- [Oh My Zsh](https://ohmyz.sh): `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- [mise](https://mise.jdx.dev): cài vào `~/.local/bin/mise`

## Setup

```bash
chmod +x ~/dotfiles/install.sh
chmod +x ~/dotfiles/scripts/*.sh
~/dotfiles/install.sh
```

Script `install.sh` gọi `scripts/link.sh`, tạo symlink từ `$HOME` về file
trong repo. Nếu đã có file cũ ở `$HOME`, nó tự backup với timestamp (an toàn
chạy lại nhiều lần - idempotent).

Sau khi xong, mở tab terminal mới hoặc chạy `rezshrc` để nạp config mới.

## Cấu trúc

```
dotfiles/
├── install.sh              # entry point - gọi scripts/link.sh
├── scripts/
│   └── link.sh             # symlink mọi thứ vào $HOME (idempotent + backup)
├── zsh/                    # config shell, chia module nhỏ
│   ├── .zshrc              # entry point - source 4 module bên dưới
│   ├── .plugins            # Oh My Zsh (ZSH, ZSH_THEME, plugins)
│   ├── .exports            # environment variables, PATH, mise
│   ├── .aliases            # tất cả alias
│   └── .functions          # hàm (fport, kport, ...)
└── agents/
    └── AGENTS.md           # hướng dẫn chung cho mọi AI coding agent
```

### Symlink được tạo trong `$HOME`

| File ở `$HOME` | Trỏ về |
|---|---|
| `~/.zshrc`     | `dotfiles/zsh/.zshrc` |
| `~/.plugins`   | `dotfiles/zsh/.plugins` |
| `~/.exports`   | `dotfiles/zsh/.exports` |
| `~/.aliases`   | `dotfiles/zsh/.aliases` |
| `~/.functions` | `dotfiles/zsh/.functions` |
| `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, `~/.agents/AGENTS.md`, `~/.config/devin/AGENTS.md` | `dotfiles/agents/AGENTS.md` |

## Cách sửa

Sửa file trong repo (qua symlink ở `$HOME` cũng được, vì cùng một file):

```bash
n ~/.aliases      # sửa alias
n ~/.exports      # sửa env / PATH
n ~/.functions    # sửa hàm
n ~/.plugins      # sửa Oh My Zsh
n ~/.zshrc        # sửa entry point
```

Reload sau khi sửa:

```bash
rezshrc
```

## Máy mới

```bash
git clone git@github.com:dam2onkid/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```
