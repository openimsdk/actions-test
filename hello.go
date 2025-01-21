package main

import "fmt"

func main() {
	fmt.Println("hello")
	ex, err := fmt.Println("hello")
	fmt.Println(ex, err)
	fmt.Println("123")
	fmt.Println("123")
}
