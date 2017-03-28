package main

import (
	"github.com/op/go-logging"
)

func main() {
	logger := logging.MustGetLogger("Hello")
	logger.Info(hello())
}

func hello() string {
	return "Hello World"
}
