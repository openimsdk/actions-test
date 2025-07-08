# ==============================================================================
# Simple Makefile for Android and iOS builds only
#

SHELL := /bin/bash
GO=go

.DEFAULT_GOAL := help

# BIN_DIR: The directory where the build output is stored.
BIN_DIR := ./_output/bin
$(shell mkdir -p $(BIN_DIR))

## ios: Build the iOS framework
.PHONY: ios
ios:
	go get golang.org/x/mobile
	rm -rf build/ open_im_sdk/t_friend_sdk.go open_im_sdk/t_group_sdk.go  open_im_sdk/ws_wrapper/
	GOARCH=arm64 gomobile bind -v -trimpath -ldflags "-s -w" -o build/OpenIMCore.xcframework -target=ios ./open_im_sdk/ ./open_im_sdk_callback/

## android: Build the Android library
# Note: to build an AAR on Windows, gomobile, Android Studio, and the NDK must be installed.
# The NDK version tested by the OpenIM team was r20b.
# To build an AAR on Mac, gomobile, Android Studio, and the NDK version 20.0.5594570 must be installed.
.PHONY: android
android:
	go get golang.org/x/mobile/bind
	GOARCH=amd64 gomobile bind -v -trimpath -ldflags="-s -w" -o ./open_im_sdk.aar -target=android ./open_im_sdk/ ./open_im_sdk_callback/

## install.gomobile: Install gomobile
.PHONY: install.gomobile
install.gomobile:
	@$(GO) install golang.org/x/mobile/cmd/gomobile@latest

## install.gobind: Install gobind
.PHONY: install.gobind
install.gobind:
	@$(GO) install golang.org/x/mobile/cmd/gobind@latest

## clean: Clean all builds.
.PHONY: clean
clean:
	@echo "===========> Cleaning all builds BIN_DIR($(BIN_DIR))"
	@-rm -vrf $(BIN_DIR) build/ open_im_sdk.aar
	@echo "===========> End clean..."

## help: Show this help info.
.PHONY: help
help: Makefile
	@printf "\n\033[1mUsage: make <TARGETS> ...\033[0m\n\n\\033[1mTargets:\\033[0m\n\n"
	@sed -n 's/^##//p' $< | awk -F':' '{printf "\033[36m%-28s\033[0m %s\n", $$1, $$2}' | sed -e 's/^/ /'
