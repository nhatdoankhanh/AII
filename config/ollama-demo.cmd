@echo off
set "OLLAMA_CONTEXT_LENGTH=4096"
set "OLLAMA_NUM_PARALLEL=1"
set "OLLAMA_MAX_LOADED_MODELS=1"
set "OLLAMA_FLASH_ATTENTION=1"
set "OLLAMA_KV_CACHE_TYPE=q8_0"
rem Maximum host RAM (MiB) for saved prompts in the bundled llama.cpp runner.
set "LLAMA_ARG_CACHE_RAM=128"
