<a href="https://github.com/Florents-Tselai/libllama2c/actions/workflows/build?branch=mainline"><img src="https://github.com/Florents-Tselai/libllama2c/actions/workflows/build.yml/badge.svg"></a>
<a href="https://opensource.org/licenses/MIT License"><img src="https://img.shields.io/badge/MIT License-blue.svg"></a>
<img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/Florents-Tselai/libllama2c">

## libllama2c

**libllama2c** is a fork of [`karpathy/llama2.c`](https://github.com/karpathy/llama2.c) with the following ~~improvements~~ .
Improvements on code written by Karpahahaha code 🤣.

* A modified CLI that plays nicely with environment variables.
* `llama2c.h` API to be used by other applications.
* `make install` targets install a shared library `libllama2c` and a `llama2c` CLI in standard directories.

## Usage

Start by cloning this repo and running `make` to build and run the tests.

```bash
git clone --recurse-submodules https://github.com/Florents-Tselai/libllama2c.git &&\
cd libllama2c &&\
make all test
```

### CLI

You can, of course run the `llama2c` executable as expected

You can either provide arguments:
```bash
./llama2c ./models/stories15M.bin -i "Hello world" -z ./models/tokenizer.bin -n 100 -t 0.9
```
You can also set environment variables or even mix the two.
```bash
export LLAMA2C_MODEL_PATH=./models/stories15M.bin
export LLAMA2C_TOKENIZER_PATH=./models/tokenizer.bin
./llama2c -i "Hello world"
```

#### CLI reference

```bash
Usage:   llama2c <model> [options]
Example: llama2c -f path/to/model.bin -n 256 -i "Once upon a time"
Options (and corresponding environment variables):
  -f <path>   Path to model file. Env: LLAMA2C_MODEL_PATH
  -t <float>  Temperature in [0,inf], default 1.0. Env: LLAMA2C_TEMPERATURE
  -p <float>  P value in top-p (nucleus) sampling in [0,1], default 0.9. Env: LLAMA2C_TOPP
  -s <int>    Random seed, default time(NULL). Env: LLAMA2C_RNG_SEED
  -n <int>    Number of steps to run for, default 256. 0 = max_seq_len. Env: LLAMA2C_STEPS
  -i <string> Input prompt. Env: LLAMA2C_PROMPT
  -z <path>   Path to custom tokenizer. Env: LLAMA2C_TOKENIZER_PATH
  -m <string> Mode: generate|chat, default: generate. Env: LLAMA2C_MODE
  -y <string> (Optional) System prompt in chat mode. Env: LLAMA2C_SYSTEM_PROMPT
```

### Library

```c
#include llama2c.h

int main(int argc, char *argv[]) {
    Llama2cConfig config;
    config.model_path = "models/stories15M.bin";
    config.tokenizer_path = "models/tokenizer.bin";
    config.temperature = 1.0f;
    config.topp = 0.9f;
    config.steps = 256;
    config.prompt = NULL;
    config.rng_seed = 0;
    config.mode = "generate";
    config.system_prompt = NULL;
    
    config.prompt = "Hello world!";
    config.steps = 10;
    
    /* Generate */
    char *generated = llama2c_generate(config);
    printf("Generated text: %s\n", config.prompt);

    /* Encode */
    int *prompt_tokens = NULL;
    int num_prompt_tokens = 0;
    llama2c_encode(simple_config(), &prompt_tokens, &num_prompt_tokens);
}
```

## Installation

You can install both the CLI and the library

```bash
PREFIX=/usr/local make all install
```

Although personally I prefer:

```bash
PREFIX=$HOME/.local make all install
```

To uninstall
```bash
PREFIX=$HOME/.local make uninstall
```

## Motivation

He just wanted a decent LLM library to import in his C application ...
Not too much to ask, was it? 
It was in 2024 when Florents stood on his keyboard looking for something good to read on his journey. 
His choice was limited to bloated overbloated .cpp packages and poor quality Python libraries leading to dependency hell.
Flo's disappointment and subsequent anger at the range of libraries available led him to fork a repository.
