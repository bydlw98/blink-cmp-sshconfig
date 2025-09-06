# blink-cmp-sshconfig

[blink.cmp](https://github.com/Saghen/blink.cmp) source for ssh_config(5) files.

Keywords and their meanings are taken from [OpenBSD ssh_config(5)](https://man.openbsd.org/ssh_config).

## Installation

### `lazy.nvim`

```lua
{
    "saghen/blink.cmp",
    dependencies = {
        "bydlw98/blink-cmp-sshconfig",
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
}
```

## Generating completion_items.lua

You can generate the keywords and their meanings in `completion_items.lua` with the following command:

```sh
uv run gen_completion_items.py
```

A Makefile is also provided as a wrapper.

```sh
make
```
