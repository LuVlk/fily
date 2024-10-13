package main

import "github.com/gin-gonic/gin"

func main() {
	r := gin.Default()
	r.Static("/", "../app/dist")
	r.Run(":8080")
}
