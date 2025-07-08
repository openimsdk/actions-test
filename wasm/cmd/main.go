//
//go:build js && wasm
// +build js,wasm

package main

import (
	"fmt"
	"syscall/js"
)

func main() {
	defer func() {
		if r := recover(); r != nil {
			fmt.Println("panic:", r)
		}
	}()

	// Register a simple hello function
	js.Global().Set("hello", js.FuncOf(hello))

	fmt.Println("WASM module loaded")
	<-make(chan bool)
}

func hello(this js.Value, args []js.Value) any {
	return "Hello from WASM!"
}
