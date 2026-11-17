package main

import (
	"encoding/json"
	"fmt"
	"os"
	"strings"
	"syscall"
)

type Options struct {
	EncryptionKey string `json:"ENCRYPTION_KEY"`
	APIUrl        string `json:"ARCANE_MANAGER_API_URL"`
	AgentToken    string `json:"ARCANE_AGENT_TOKEN"`
}

func main() {
	const optionsFile = "/app/data/options.json"

	data, err := os.ReadFile(optionsFile)
	if err != nil {
		fatal("Cannot read Home Assistant options: %v", err)
	}

	var options Options
	if err := json.Unmarshal(data, &options); err != nil {
		fatal("Cannot parse Home Assistant options: %v", err)
	}

	if strings.TrimSpace(options.EncryptionKey) == "" {
		fatal("ENCRYPTION_KEY is missing or empty")
	}
	
	// Export configuration to Arcane.
	if err := os.Setenv("ENCRYPTION_KEY", options.EncryptionKey); err != nil {
		fatal("Cannot set ENCRYPTION_KEY: %v", err)
	}

	if err := os.Setenv("ARCANE_AGENT", "true"); err != nil {
		fatal("Cannot set ARCANE_AGENT: %v", err)
	}
	
	if err := os.Setenv("ARCANE_MANAGER_API_URL", options.APIUrl); err != nil {
		fatal("Cannot set ARCANE_MANAGER_API_URL: %v", err)
	}

	if err := os.Setenv("ARCANE_AGENT_TOKEN", options.AgentToken); err != nil {
		fatal("Cannot set ARCANE_AGENT_TOKEN: %v", err)
	}

	if err := os.Setenv("DOCKER_HOST", "unix:///run/docker.sock"); err != nil {
    	fatal("Cannot set DOCKER_HOST: %v", err)
	}

	fmt.Println("Home Assistant configuration loaded successfully.")

	// Preserve the original Docker CMD.
	args := os.Args[1:]

	if len(args) == 0 {
		args = []string{"/app/arcane"}
	}

	// Replace this process with Arcane.
	if err := syscall.Exec(args[0], args, os.Environ()); err != nil {
		fatal("Cannot start Arcane: %v", err)
	}
}

func fatal(format string, args ...any) {
	fmt.Fprintf(os.Stderr, "ERROR: "+format+"\n", args...)
	os.Exit(1)
}
