# copy-to-clipboard

A zsh function that pipes any command's output to the clipboard — with **dual output** (human-readable in the terminal, AI-structured on the clipboard) and **automatic backend detection** for X11 and Wayland.

```zsh
docker logs app | copy-to-clipboard
```

Paste that into an LLM chat and it lands pre-formatted with command, timestamp, and size metadata — no manual cleanup.

## Features

- **Auto-detects the display server** — uses `wl-copy` under Wayland, `xclip` under X11, no flags needed
- **Dual-format output** — humanized in the terminal (for you), IA-optimized on the clipboard (for LLMs), independently toggleable
- **Layered fallback** — native backend → OSC 52 (works over plain SSH, no X11/Wayland forwarding required) → local file
- **Zero subshell surprises** — captures the *exact* command line via a `preexec` hook instead of `fc`, so multi-pipe commands are recorded correctly
- **Silent mode** for scripts, **export mode** for archiving output to disk

## How it works

### Backend detection

```zsh
if [[ -n "$WAYLAND_DISPLAY" ]]; then
    clipboard_backend="wayland"; clipboard_bin="wl-copy"
elif [[ -n "$DISPLAY" ]]; then
    clipboard_backend="x11"; clipboard_bin="xclip"
fi
```

`WAYLAND_DISPLAY` is exported by the compositor itself the moment it starts, and is inherited by every child process — it's the most reliable signal available. `DISPLAY` is only checked as a fallback, so an XWayland app leaking `DISPLAY` into your environment doesn't cause a false read inside a native Wayland session.

Both `xclip` and `wl-copy` fork into the background on their own to hold clipboard ownership after being fed stdin, so the call returns immediately either way — no `&` or wait logic required. The call is also wrapped in `setsid`, giving the clipboard-holder process its own session up front so it's never affected by job-control signals tied to the invoking shell.

### Output modes: IA vs. Human

| Value | Meaning |
|---|---|
| `0` | **IA-optimized** — structured block with `[COPY_STATUS]`, `[COPY_METHOD]`, `[CONTENT_SIZE]`, `[TIMESTAMP]`, `[COMMAND]`, then the raw content between `---` markers |
| `1` | **Humanized** — plain content with visual separators, meant for reading, not parsing |

By default: **terminal = humanized**, **clipboard = IA-optimized**. `--human` flips both to humanized. `--export` forces the terminal to IA-format as well (so the exported file and what you see match).

### Explicit MIME type on Wayland

`wl-copy` behaves differently depending on how content reaches it:

- **Argument** (`wl-copy "text"`) → defaults straight to `text/plain`
- **stdin** (`echo -n "text" | wl-copy`) → tries to auto-detect the MIME type instead

Since this function always feeds content through stdin, that auto-detection could produce a type paste targets don't recognize — the clipboard *looked* populated (it even showed up in cliphist's history), but `Ctrl+V` failed silently in every app, with "Paste" simply greyed out and no error anywhere. The fix is forcing the type explicitly:

```zsh
echo -n "$clipboard_content" | setsid wl-copy --type text/plain
```

If you ever strip this function down, keep the `--type text/plain` — it looks redundant until you hit this exact failure mode again.

### Fallback chain

1. Native backend (`wl-copy` / `xclip`)
2. **OSC 52** escape sequence — if the native backend fails but a terminal is present (covers SSH sessions without X11/Wayland forwarding, as long as the terminal emulator supports OSC 52)
3. **File export** to `~/clipboard_<timestamp>.txt` — final fallback, or explicit via `--export`

## Requirements

- `zsh`
- One clipboard backend, matching your display server:
  - **Wayland**: `wl-copy` (from `wl-clipboard`)
  - **X11**: `xclip`

On Gentoo:

```sh
# Wayland
sudo emerge -av gui-apps/wl-clipboard

# X11
sudo emerge -av x11-misc/xclip
```

On other distros, install `wl-clipboard` and/or `xclip` from your package manager — the function only needs one of the two, matching whatever `$WAYLAND_DISPLAY` / `$DISPLAY` says you're running.

## Installation

Part of [TheseusMachine-dotfiles](https://github.com/jKy0n/TheseusMachine-dotfiles/blob/main/.config/zsh/zshrc.d/functions/copy-to-clipboard/copy-to-clipboard.zsh) — not a standalone repo yet (a dedicated zsh-functions repo is planned, but for now this lives inside the dotfiles).

Local path:

```
~/.config/zsh/zshrc.d/functions/copy-to-clipboard/copy-to-clipboard.zsh
```

Sourced from `.zshrc` (or a loader that walks `zshrc.d/functions/**`):

```zsh
source ~/.config/zsh/zshrc.d/functions/copy-to-clipboard/copy-to-clipboard.zsh
```

Reload your shell (`exec zsh`) and the `copy-to-clipboard` function is available.

**Cloning it elsewhere?** Grab just this function from the dotfiles repo and adjust the `source` path in your own `.zshrc` to match wherever you put it.

## Usage

```
copy-to-clipboard [OPTIONS] [COMMAND]
command | copy-to-clipboard [OPTIONS]
```

| Flag | Description |
|---|---|
| `-h`, `--help` | Show help |
| `-v`, `--version` | Show version + detected backend |
| `-H`, `--human` | Humanized output everywhere (terminal + clipboard) |
| `-s`, `--silent` | No terminal output, just a one-line confirmation |
| `-e`, `--export` | Save to `~/clipboard_<timestamp>.txt` + IA-format in terminal |

Flags can be combined, e.g. `--silent --export`.

## Examples

```zsh
# Copy for an LLM to debug (default — IA-format on clipboard)
docker logs app | copy-to-clipboard

# Humanized everywhere, for your own reading
docker logs app | copy-to-clipboard --human

# Silent, for use inside other scripts
docker logs app | copy-to-clipboard --silent

# Archive to file + IA-format
docker logs app | copy-to-clipboard --export

# Direct command instead of a pipe
copy-to-clipboard "systemctl status sshd"
```

## Environment variables

| Variable | Effect |
|---|---|
| `WAYLAND_DISPLAY` | If set → selects the `wl-copy` backend |
| `DISPLAY` | Checked if `WAYLAND_DISPLAY` is unset → selects the `xclip` backend |
| `TERM` / `SSH_TTY` | Used to decide whether OSC 52 is attempted as a fallback |

## Troubleshooting

- **`Erro: nenhum display gráfico detectado`** — neither `WAYLAND_DISPLAY` nor `DISPLAY` is set in the current shell. Check you're not running from a bare TTY or a stripped-down non-interactive session.
- **`Erro: wl-copy/xclip não está instalado`** — the backend matching your display server isn't installed; the error prints the exact install command for your case.
- **Clipboard silently falls back to a file over SSH** — your terminal emulator likely doesn't support OSC 52. Enable it (Alacritty, kitty, and WezTerm support it out of the box) or rely on `--export` + manual copy.
- **Content shows up in `cliphist` history but `Ctrl+V` does nothing anywhere, "Paste" is greyed out** — this was a real bug hit on niri: `wl-copy` fed via stdin without an explicit `--type` can offer a MIME type paste targets don't recognize. Already fixed in this function (`--type text/plain` forced explicitly). If you're diffing against an older copy, that's the line to check.
- **Clipboard content disappears right after the source shell/job finishes** — the background process holding the clipboard needs to survive independently of the invoking shell's session; this function wraps the call in `setsid` for exactly that reason. If you strip it out and see this symptom come back, that's why.
- **Copy works from the terminal but not from a GUI app after switching focus (niri specifically)** — known upstream niri clipboard-protocol edge cases exist (see niri issues around selection re-offering on focus change). If the MIME-type and `setsid` fixes above don't resolve it, [`wl-clip-persist`](https://github.com/Linus789/wl-clip-persist) run as a background service is a reasonable mitigation, though it targets a different failure mode (source app closing, not type detection).

## License

Just credit me and be kind with others =)