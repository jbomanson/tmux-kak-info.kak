# tmux-kak-info.kak

[![License](https://img.shields.io/github/license/jbomanson/tmux-kak-info.kak)](https://opensource.org/licenses/Apache-2.0)

**tmux-kak-info.kak** is a tiny
[Kakoune](https://github.com/mawww/kakoune) plugin that helps write scripts
that integrate Kakoune with the terminal multiplexer
[tmux](https://github.com/tmux/tmux).
Specifically, the plugin ensures that in every tmux session the tmux option
`@kak_info_sessions` contains a list of the identifiers of all Kakoune sessions
started within that tmux session.

![screenshot](docs/screenshot.png)

## Installation

### With plug.kak

You can install **tmux-kak-info.kak** using the
[plug.kak](https://github.com/andreyorst/plug.kak) plugin manager by extending
your `kakrc` with:

```kak
plug "jbomanson/tmux-kak-info.kak"
```

Then restart Kakoune, run `:plug-install`, and restart Kakoune again.

### Manually

In your `kakrc`, include:

```sh
source "/path/to/tmux-kak-info.kak/rc/tmux-kak-info.kak"
```

## Usage

### Listing kakoune sessions within the current tmux session

Suppose you are in a tmux session where you have started two Kakoune sessions
that have identifiers 11111 and 22222.
Then, you may write the following in a shell within that tmux session:

```sh
tmux show-option -v @kak_info_sessions
```

The result will be:
```sh
11111
22222
```

To give an idea of how this can be useful, the following is how you may print
"Hello world!" to the debug buffer within the first of those Kakoune sessions:

```sh
echo "echo -debug Hello world!" | kak -p "$(tmux show-option -v @kak_info_sessions | head -n1)"
```

### Listing kakoune sessions within the current tmux window

```sh
tmux show-option -vw @kak_info_sessions
```
