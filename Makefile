# Installation prefix (can override with: make PREFIX=/custom/path install)
PREFIX ?= ~/.local
BINDIR := $(PREFIX)/bin

# Find all executable scripts in bin/
SCRIPTS := $(wildcard bin/*.sh)
BASENAMES := $(basename $(notdir $(SCRIPTS)))

install:
	@echo "Installing scripts to $(BINDIR)..."
	install -d $(BINDIR)
	@for script in $(SCRIPTS); do \
		base=$$(basename $$script .sh); \
		install -m 755 $$script $(BINDIR)/$$base; \
		echo "  -> Installed $$script as $$base"; \
	done

uninstall:
	@echo "Uninstalling scripts from $(BINDIR)..."
	@for base in $(BASENAMES); do \
		rm -f $(BINDIR)/$$base; \
		echo "  -> Removed $(BINDIR)/$$base"; \
	done
