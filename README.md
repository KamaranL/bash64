```bash
    __               __    _____ __ __
   / /_  ____ ______/ /_  / ___// // /
  / __ \/ __ `/ ___/ __ \/ __ \/ // /_
 / /_/ / /_/ (__  ) / / / /_/ /__  __/
/_.___/\__,_/____/_/ /_/\____/  /_/
```

> encode (& decode) your shell scripts using base64

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
- grep
- head
- realpath
- sha256sum

### Install

1. Clone repository:

   ```bash
   git clone https://github.com/KamaranL/bash64.git
   ```

1. Navigate to the newly downloaded repo and mark the script as executable[^2]:

   ```bash
   chmod +x bash64
   ```

1. Add to PATH <u>or</u> create a symbolic link: *(recommended)*

   - Adding cloned repo to path:

     ```bash
     echo 'export PATH=$PATH:<absolute_path_to_cloned_repo>' >>~/.bash_profile
     ```

   - Creating a symbolic link:

     ```bash
     ln -s <absolute_path_to_cloned_repo>/bash64 /usr/local/bin/bash64
     ```

### Usage

```text
usage: bash64 [options]
options:
  -e <file>           encode the specified file
  -d <file>           decode the specified file
  --no-{sha,timestamp}
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
#!/bin/bash
# 2024-01-30 06:13:18
# e07db5c63556498c9147f618444619277ddf67d59bbb2dcbedd79329ffcf4315
MAIN='IyEvdXNyL2Jpbi9lbnYgYmFzaAplY2hvIEhlbGxvICIkezE6LVdvcmxkfSIKZXhpdCAkPwo='
__MAIN__="${0##*\/}" \
/usr/bin/env bash <(base64 -d <<<"$MAIN") "$@"
exit $?
```

*Line-by-line analysis:*

- the very first line contains the shebang `#!`.
- the next line is the date and time the encoding occurred of the source file.
- the next line is the SHA256 checksum of the *raw* source file.
- **MAIN** stores a base64 encoded string that contains the contents of the source file.
- **\_\_MAIN__** [^3] contains the name of the encoded script, and is defined immediately before executing the encoded string so that it can be passed to the context that the encoded string will run in.
- the next line is really just a continuation of the previous line- because of the `\`. Here you will see the path to the interpreter that was provided in the first line of the source file, which is then taking in the base64 encoded string and then decoding it upon execution, while passing along all positional parameters.
- the last line exits with the exit code of the previous line- where the base64 encoded string is being executed[^4]:.

<!-- footnotes -->

[^1]: Most, if not all, of the listed dependencies come pre-installed on MacOS and a good number of Linux distributions- provided for transparency.

[^2]: Everyone has doubts, see [my wiki page](https://github.com/KamaranL/KamaranL/wiki#validation) on validation if you're like everyone.

[^3]: This is implemented because after encoding the source file, the `$0` parameter in shell scripts do not decode correctly from standard input upon execution. For example, if we encoded the following source file:

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

[^4]: It's worth noting that *without* an exit code in the source file, the script *may* return false exit codes of 1 when executed.
