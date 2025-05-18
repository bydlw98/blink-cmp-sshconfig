UV=uv

.PHONY: gen_completion_items
gen_completion_items:
	$(UV) run gen_completion_items.py

