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
	AgentMode     any    `json:"AGENT_MODE"`
	AgentToken    string `json:"AGENT_TOKEN"`
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

	// Handle AGENT_MODE as either a JSON boolean or string.
	agentMode := "false"

	switch value := options.AgentMode.(type) {
	case nil:
		// Default to false.
	case bool:
		if value {
			agentMode = "true"
		}
	case string:
		if value != "" {
			mode := strings.ToLower(strings.TrimSpace(value))
			if mode != "true" && mode != "false" {
				fatal("AGENT_MODE must be true or false")
			}
			agentMode = mode
		}
	default:
		fatal("Invalid AGENT_MODE type")
	}

	// Export configuration to Arcane.
	if err := os.Setenv("ENCRYPTION_KEY", options.EncryptionKey); err != nil {
		fatal("Cannot set ENCRYPTION_KEY: %v", err)
	}

	if err := os.Setenv("AGENT_MODE", agentMode); err != nil {
		fatal("Cannot set AGENT_MODE: %v", err)
	}

	if err := os.Setenv("AGENT_TOKEN", options.AgentToken); err != nil {
		fatal("Cannot set AGENT_TOKEN: %v", err)
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
