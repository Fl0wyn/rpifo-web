package main

import (
	"log"
	"net/http"
)

func main() {
	fs := http.FileServer(http.Dir("src"))
	log.Fatal(http.ListenAndServe(":9696", fs))
}
