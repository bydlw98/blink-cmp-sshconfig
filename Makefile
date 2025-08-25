UV = uv
STYLUA = stylua

gen_completion_items: gen_completion_items.py
	$(UV) run gen_completion_items.py

format_completion_items: lua/blink-cmp-sshconfig/completion_items.lua
	$(STYLUA) lua/blink-cmp-sshconfig/completion_items.lua

clean:
	rm -f lua/blink-cmp-sshconfig/completion_items.lua

all: gen_completion_items

.PHONY: \
	all \
	clean \
	format_completion_items \
	gen_completion_items
