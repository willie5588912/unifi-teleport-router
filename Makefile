PACKAGE_NAME = teleport-route-checker
VERSION = 1.0.0
ARCH = all
DEB_FILE = $(PACKAGE_NAME)_$(VERSION)_$(ARCH).deb

.PHONY: all build clean install test help

all: build

help:
	@echo "Available targets:"
	@echo "  build    - Build the deb package"
	@echo "  clean    - Clean build artifacts"
	@echo "  install  - Install the package locally (requires sudo)"
	@echo "  test     - Test the script (dry run)"
	@echo "  help     - Show this help"

build: clean
	@echo "Building $(DEB_FILE)..."
	@# Ensure correct permissions
	@chmod 755 debian/usr/bin/teleport-route-checker
	@chmod 755 debian/DEBIAN/postinst debian/DEBIAN/prerm
	@chmod 644 debian/etc/systemd/system/*.service debian/etc/systemd/system/*.timer
	@chmod 644 debian/DEBIAN/control
	@# Build the package
	@dpkg-deb --build -Zgzip debian $(DEB_FILE)
	@echo "Package built: $(DEB_FILE)"
	@ls -la $(DEB_FILE)

clean:
	@echo "Cleaning build artifacts..."
	@rm -f *.deb
	@echo "Clean complete"

install: build
	@echo "Installing $(DEB_FILE)..."
	@if [ "$$(id -u)" != "0" ]; then \
		echo "Installation requires root privileges. Use: sudo make install"; \
		exit 1; \
	fi
	@dpkg -i $(DEB_FILE)
	@echo "Installation complete"

test:
	@echo "Testing teleport-route-checker script (dry run)..."
	@DRY_RUN=true debian/usr/bin/teleport-route-checker
	@echo "Test complete"

uninstall:
	@echo "Uninstalling $(PACKAGE_NAME)..."
	@if [ "$$(id -u)" != "0" ]; then \
		echo "Uninstallation requires root privileges. Use: sudo make uninstall"; \
		exit 1; \
	fi
	@dpkg -r $(PACKAGE_NAME) || true
	@echo "Uninstallation complete"

status:
	@echo "Checking service status..."
	@systemctl status teleport-route-checker.timer || true
	@echo ""
	@systemctl status teleport-route-checker.service || true

logs:
	@echo "Showing recent logs..."
	@journalctl -u teleport-route-checker.service -n 20 --no-pager