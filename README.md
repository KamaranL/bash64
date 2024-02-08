```bash
    __               __    _____ __ __
   / /_  ____ ______/ /_  / ___// // /
  / __ \/ __ `/ ___/ __ \/ __ \/ // /_
 / /_/ / /_/ (__  ) / / / /_/ /__  __/
/_.___/\__,_/____/_/ /_/\____/  /_/
```

> encode (& decode) your shell scripts using base64

[![latest release](https://badgen.net/github/release/KamaranL/bash64?icon=github)](https://github.com/KamaranL/bash64/releases/latest)

- [Installation and Usage](#installation-and-usage)
  - [Dependencies](#dependencies)
  - [Install](#install)
  - [Usage](#usage)
- [Examples](#examples)

## Installation and Usage

### Dependencies

[^1]

- base64
- bash `>=3`
- cat
- date
- perl `>=5`
- realpath
- sha256sum

### Install

Copy + paste the following in your terminal to download, unpack, and link the [latest release](https://github.com/KamaranL/bash64/releases/latest):

   ```bash
   VER="$(curl -sL 'https://raw.githubusercontent.com/KamaranL/bash64/HEAD/VERSION.txt')" && {
       DIR=/usr/local/etc/bash64.d
       [ ! -d "$DIR" ] && mkdir -p "$DIR"
       curl -L "https://github.com/KamaranL/bash64/releases/download/v$VER/bash64-v$VER.tgz" | tar -xz -C "$DIR"
       chmod +x "$DIR/bash64"
       ln -s "$DIR/bash64" /usr/local/bin/bash64
       bash64 -v && bash64 -h
   }
   ```

### Usage

```text
usage: bash64 [options]
options:
  -e <file>           encode the specified file
  -d <file>           decode the specified file
  --no-{sha,timestamp,credit,format}
                      omits the specified option when encoding
  -h,--help           print this help message
  -v,--version        print version
```

## Examples

We have the following executable script:

<sub>***hello.sh***</sub>

```bash
#!/usr/bin/env bash
echo Hello "${1:-World}"
exit $?
```

How the script is typically executed:

```bash
$ ./hello.sh
# Hello World

$ ./hello.sh John
# Hello John
```

Using bash64, we encode the script and redirect the output:

```bash
bash64 -e hello.sh >/usr/local/bin/hello
```

Make the script executable:

```bash
chmod +x /usr/local/bin/hello
```

Test the newly encoded script:

<sub>- since */usr/local/bin* is in our **PATH** we can just call `hello`</sub>

```bash
$ hello
# Hello World

$ hello Mary
# Hello Mary
```

If we check the contents of the encoded script created by bash64, we see:

<sub>***/usr/local/bin/hello***</sub>

```bash
#!/bin/bash                                                                       1
# e07db5c63556498c9147f618444619277ddf67d59bbb2dcbedd79329ffcf4315                2
# 2024-01-30 06:13:18                                                             3
# encoded with bash64 - https://github.com/KamaranL/bash64                        4
MAIN='IyEvdXNyL2Jpbi9lbnYgYmFzaAplY2hvIEhlbGxvICIkezE6LVdvcmxkfSIKZXhpdCAkPwo=' # 5
__MAIN__="${0##*\/}" \  #                                                         6
    /usr/bin/env bash <(base64 -d <<<"$MAIN") "$@" #                              7
exit $? #                                                                         8
```

*Line-by-line analysis:*

1. the shebang `#!`.
1. the SHA256 checksum of the *raw* source file contents.
1. the date and time the encoding occurred of the source file.
1. the credit line that contains the name of the encoding script and its GitHub repository.
1. **MAIN** stores a base64 encoded string that contains the contents of the source file.
1. **\_\_MAIN__** [^3] contains the name of the encoded script, and is defined immediately before executing the encoded string so that it can be passed to the context that the encoded string will run in.
1. a continuation of the previous line, because of the `\`. Here you will see the path to the interpreter that was provided in the first line of the source file, which is then taking in the base64 encoded string and then decoding it upon execution, while passing along all positional parameters.
1. exits with the exit code of the previous line (where the base64 encoded string is being executed[^4]):.

[^1]: Most, if not all, of the listed dependencies come pre-installed on MacOS and a good number of Linux distributions- provided for transparency.

[^2]: Everyone has doubts, see [my wiki page](https://github.com/KamaranL/KamaranL/wiki#validation) on validation if you're like everyone.

[^3]: This is implemented because after encoding the source file, the `$0` parameter, as well as the `$BASH_SOURCE` variable, in shell scripts do not decode correctly from standard input upon execution. For example, if we encoded the following source file:

    ```bash
    #!/bin/bash
    echo The name of this script is "$__MAIN__"
    exit 0
    ```

    and the name of the encoded script was ***whatami***, we would expect the following:

    ```bash
    $ whatami
    # The name of this script is whatami
    ```

    Automatic formatting is already in place to substitute `$0` and `$BASH_SOURCE` for `$__MAIN__`, but if you would prefer to change these variables yourself, you can use the `--no-format` option and bash64 will print the lines that need remediation prior to encoding.

[^4]: It's worth noting that *without* an exit code in the source file, the script *may* return false exit codes of 1 when executed.
