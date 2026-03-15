<div align="center">

# 🖥️ tmux config

**A modular, themed and keyboard-friendly tmux setup**  
**Uma configuração tmux modular, temática e amigável ao teclado**

![tmux](https://img.shields.io/badge/tmux-3.x+-1BB91F?style=flat-square&logo=tmux&logoColor=white)
![Shell](https://img.shields.io/badge/shell-zsh-89DCEB?style=flat-square&logo=zsh&logoColor=white)
![Theme](https://img.shields.io/badge/theme-Catppuccin%20Macchiato-c6a0f6?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-cba6f7?style=flat-square)

</div>

---

## 🌐 Language / Idioma

- [🇺🇸 English](#-english)
- [🇧🇷 Português](#-português)

---

# 🇺🇸 English

## 📋 Overview

This is a clean, modular tmux configuration with a beautiful [Catppuccin Macchiato](https://github.com/catppuccin/tmux) theme. Settings are split into focused files inside `conf.d/` — making it easy to read, customize and maintain.

## ✨ Features

- 🎨 **Catppuccin Macchiato** theme with truecolor (24-bit) support
- 🧩 **Modular config** — each concern in its own file under `conf.d/`
- 🖱️ **Mouse support** enabled
- 🔄 **Auto-reload** on config file changes via `tmux-autoreload`
- 🐚 **Zsh** as the default shell
- ⌨️ **Custom keybindings** for intuitive pane navigation and buffer scrolling
- 📦 **TPM** (Tmux Plugin Manager) for easy plugin management
- 📊 **Status bar** showing: session name · current application · user · hostname

## 📁 Directory Structure

```
~/.config/tmux/
├── tmux.conf              # Entry point — loads conf.d/* and initializes TPM
├── conf.d/
│   ├── keybinds.conf      # Custom keyboard shortcuts
│   ├── misc.conf          # Mouse, default shell and general settings
│   ├── plugins.conf       # TPM plugin declarations
│   └── theme.conf         # Catppuccin theme and status bar layout
└── plugins/               # Managed by TPM
    ├── tpm/               # Tmux Plugin Manager
    ├── tmux-sensible/     # Sensible tmux defaults
    ├── tmux-autoreload/   # Auto-reloads config on save
    └── catppuccin/        # Catppuccin color theme
```

## 🔌 Plugins

| Plugin | Description |
|--------|-------------|
| [tpm](https://github.com/tmux-plugins/tpm) | Tmux Plugin Manager |
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible defaults everyone can agree on |
| [tmux-autoreload](https://github.com/b0o/tmux-autoreload) | Automatically reloads tmux config on file change |
| [catppuccin/tmux](https://github.com/catppuccin/tmux) | Beautiful Catppuccin color theme |

## ⌨️ Keybindings

| Key | Action |
|-----|--------|
| `Ctrl + Alt + ←` | Select pane to the left |
| `Home` | Send `Home` key sequence to the terminal |
| `End` | Send `End` key sequence to the terminal |
| `Ctrl + Home` | Jump to beginning of terminal buffer |
| `Ctrl + End` | Jump to end of terminal buffer |
| `PageUp` | Enter copy mode and scroll up |
| `PageDown` | Enter copy mode and scroll down |
| `Shift + Delete` | Clear the current line (`Ctrl + U`) |

## 🎨 Status Bar

```
[ session ] [ app ]          [ user ] [ host ]
```

The left side shows the **session name** and the **current application**.  
The right side shows the logged-in **user** and the **hostname**.

## 🚀 Installation

### Prerequisites

- tmux 3.x or higher
- Zsh (configured as default shell in `misc.conf`)
- A [Nerd Font](https://www.nerdfonts.com/) for proper icon rendering

### Steps

```bash
# 1. Clone this repository
git clone https://github.com/<your-username>/tmux-config ~/.config/tmux

# 2. Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# 3. Start tmux
tmux

# 4. Install plugins
# Press: prefix + I  (capital i)
```

> **Tip:** The default prefix is `Ctrl + B`.

---

# 🇧🇷 Português

## 📋 Visão Geral

Esta é uma configuração tmux limpa e modular com o lindo tema [Catppuccin Macchiato](https://github.com/catppuccin/tmux). As configurações são divididas em arquivos focados dentro de `conf.d/` — facilitando a leitura, personalização e manutenção.

## ✨ Funcionalidades

- 🎨 Tema **Catppuccin Macchiato** com suporte a truecolor (24 bits)
- 🧩 **Configuração modular** — cada aspecto em seu próprio arquivo dentro de `conf.d/`
- 🖱️ Suporte a **mouse** habilitado
- 🔄 **Recarregamento automático** das configurações via `tmux-autoreload`
- 🐚 **Zsh** como shell padrão
- ⌨️ **Atalhos personalizados** para navegação intuitiva entre painéis e scroll do buffer
- 📦 **TPM** (Tmux Plugin Manager) para gerenciamento fácil de plugins
- 📊 **Barra de status** exibindo: nome da sessão · aplicação atual · usuário · hostname

## 📁 Estrutura de Diretórios

```
~/.config/tmux/
├── tmux.conf              # Ponto de entrada — carrega conf.d/* e inicializa o TPM
├── conf.d/
│   ├── keybinds.conf      # Atalhos de teclado personalizados
│   ├── misc.conf          # Mouse, shell padrão e configurações gerais
│   ├── plugins.conf       # Declaração dos plugins TPM
│   └── theme.conf         # Tema Catppuccin e layout da barra de status
└── plugins/               # Gerenciados pelo TPM
    ├── tpm/               # Tmux Plugin Manager
    ├── tmux-sensible/     # Padrões sensatos para o tmux
    ├── tmux-autoreload/   # Recarrega o config automaticamente ao salvar
    └── catppuccin/        # Tema de cores Catppuccin
```

## 🔌 Plugins

| Plugin | Descrição |
|--------|-----------|
| [tpm](https://github.com/tmux-plugins/tpm) | Gerenciador de plugins do tmux |
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Padrões sensatos que todos concordam |
| [tmux-autoreload](https://github.com/b0o/tmux-autoreload) | Recarrega automaticamente a config ao salvar o arquivo |
| [catppuccin/tmux](https://github.com/catppuccin/tmux) | Lindo tema de cores Catppuccin |

## ⌨️ Atalhos de Teclado

| Tecla | Ação |
|-------|------|
| `Ctrl + Alt + ←` | Selecionar painel à esquerda |
| `Home` | Envia a sequência da tecla `Home` ao terminal |
| `End` | Envia a sequência da tecla `End` ao terminal |
| `Ctrl + Home` | Ir para o início do buffer do terminal |
| `Ctrl + End` | Ir para o fim do buffer do terminal |
| `PageUp` | Entrar no modo de cópia e rolar para cima |
| `PageDown` | Entrar no modo de cópia e rolar para baixo |
| `Shift + Delete` | Apagar a linha atual (`Ctrl + U`) |

## 🎨 Barra de Status

```
[ sessão ] [ aplicação ]          [ usuário ] [ host ]
```

O lado esquerdo exibe o **nome da sessão** e a **aplicação atual**.  
O lado direito exibe o **usuário** logado e o **hostname** da máquina.

## 🚀 Instalação

### Pré-requisitos

- tmux 3.x ou superior
- Zsh (configurado como shell padrão em `misc.conf`)
- Uma [Nerd Font](https://www.nerdfonts.com/) para renderização correta dos ícones

### Passos

```bash
# 1. Clone este repositório
git clone https://github.com/<seu-usuario>/tmux-config ~/.config/tmux

# 2. Instale o TPM
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# 3. Inicie o tmux
tmux

# 4. Instale os plugins
# Pressione: prefix + I  (i maiúsculo)
```

> **Dica:** O prefix padrão é `Ctrl + B`.

---

<div align="center">

Made with 🩷 using [Catppuccin](https://catppuccin.com/) · Feito com 🩷 usando [Catppuccin](https://catppuccin.com/)

</div>