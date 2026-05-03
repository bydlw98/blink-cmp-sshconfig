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
        { "bydlw98/blink-cmp-sshconfig" },
      },
      opts = {
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "sshconfig" },
          providers = {
            sshconfig = {
              name = "SshConfig",
              module = "blink-cmp-sshconfig",
              --- @module 'blink-cmp-sshconfig'
              --- @type blink-cmp-sshconfig.Options
              opts = {
                prefer_pre_generated = true,
              },
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
Plug 'bydlw98/blink-cmp-sshconfig'

lua << EOF
require("blink.cmp").setup({
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "sshconfig" },
    providers = {
      sshconfig = {
        name = "SshConfig",
        module = "blink-cmp-sshconfig",
        --- @module 'blink-cmp-sshconfig'
        --- @type blink-cmp-sshconfig.Options
        opts = {
          prefer_pre_generated = true,
        },
      }
    }
  }
})
EOF

call plug#end()
```

## Options

### prefer_pre_generated (type: boolean)

_Default:_ `true`

Specify whether to use pre-generated `completion_items.lua` instead of generating `completion_items.lua`.

---

## Building completion_items.lua

`lua/blink-cmp-sshconfig/completion_items.lua` contains the sshconfig keywords and their meanings.
`blink-cmp-sshconfig` will automatically build `completion_items.lua` if `completion_items.lua` is not found.

You can also manually build `completion_items.lua` with the following methods:

Using pre-generated `completion_items.lua`

```lua
require("blink-cmp-sshconfig").build(true)
```

Generate `completion_items.lua`

```lua
require("blink-cmp-sshconfig").build(false)
```

Generate `completion_items.lua` from the command line

```sh
make
```
