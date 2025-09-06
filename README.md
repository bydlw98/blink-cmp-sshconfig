<div align="center">

# blink-cmp-sshconfig

[blink.cmp](https://github.com/Saghen/blink.cmp) source for sshconfig files.

Keywords and their meanings are taken from [OpenBSD ssh_config(5)](https://man.openbsd.org/ssh_config).

</div>

---

## Requirements

- neovim >= 0.11.0
- `python`
- `uv`
- `GNU make`

---

## Installation

### [`lazy.nvim`](https://github.com/folke/lazy.nvim)

```lua
require("lazy").setup({
  spec = {
    {
      "saghen/blink.cmp",
      dependencies = {
        {
          "bydlw98/blink-cmp-sshconfig",
          build = 'make',
        },
      },
      opts = {
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "sshconfig" },
          providers = {
            sshconfig = {
              name = "SshConfig",
              module = "blink-cmp-sshconfig",
            }
          }
        }
      }
    },
  },
})
```

### [`vim-plug`](https://github.com/junegunn/vim-plug)

```vim
call plug#begin()

Plug 'Saghen/blink.cmp'
Plug 'bydlw98/blink-cmp-sshconfig', { 'do': 'make' }

lua << EOF
require("blink.cmp").setup({
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "sshconfig" },
    providers = {
      sshconfig = {
        name = "SshConfig",
        module = "blink-cmp-sshconfig",
      }
    }
  }
})
EOF

call plug#end()
```

---

## Generating completion_items.lua

You can generate the keywords and their meanings in `lua/blink-cmp-sshconfig/completion_items.lua` with the following command:

```sh
make
```
