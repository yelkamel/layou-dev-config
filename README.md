# layou-dev-config

Config perso pour retrouver le meme setup sur n'importe quelle machine.

## Contenu

| Fichier | Destination | Description |
|---|---|---|
| `next-prayer.sh` | `~/Tech/layou-dev-config/next-prayer.sh` | Prochaine priere (API aladhan.com, cache quotidien) |
| `claude/statusline.sh` | `~/.claude/statusline.sh` | Statusline Claude Code (branche, contexte, priere) |
| `claude/settings.json` | `~/.claude/settings.json` | Settings Claude Code (statusline + hooks) |
| `claude/notify.sh` | `~/.claude/notify.sh` | Notification MGS1 (son + banner) quand Claude attend une action |
| `assets/mgs-alert.mp3` | `~/.claude/sounds/mgs-alert.mp3` | Son d'alerte Metal Gear Solid 1 |
| `assets/mgs-icon.png` | `~/.claude/sounds/mgs-icon.png` | Icone "!" MGS pour les notifications |
| `ghostty/config` | `~/.config/ghostty/config` | Config Ghostty (notifications desktop) |

## Setup sur une nouvelle machine

### Pre-requis

- `jq` (`brew install jq` sur Mac)
- `terminal-notifier` (`brew install terminal-notifier` sur Mac)
- `git`
- `curl` (deja present sur Mac/Linux)
- [Ghostty](https://ghostty.org/) (terminal)

### Installation

```bash
# Cloner le repo
git clone git@github.com:layogtima/layou-dev-config.git ~/Tech/layou-dev-config

# Creer les dossiers
mkdir -p ~/.claude
mkdir -p ~/.claude/sounds
mkdir -p ~/.config/ghostty

# Copier les assets (son + icone MGS1)
cp ~/Tech/layou-dev-config/assets/mgs-alert.mp3 ~/.claude/sounds/mgs-alert.mp3
cp ~/Tech/layou-dev-config/assets/mgs-icon.png ~/.claude/sounds/mgs-icon.png

# Remplacer l'icone de terminal-notifier par le "!" MGS
sips -s format icns ~/.claude/sounds/mgs-icon.png --out /opt/homebrew/Cellar/terminal-notifier/*/terminal-notifier.app/Contents/Resources/Terminal.icns

# Symlinkler les fichiers Claude
ln -s ~/Tech/layou-dev-config/claude/statusline.sh ~/.claude/statusline.sh
ln -s ~/Tech/layou-dev-config/claude/settings.json ~/.claude/settings.json
ln -s ~/Tech/layou-dev-config/claude/notify.sh ~/.claude/notify.sh

# Symlinkler la config Ghostty
ln -s ~/Tech/layou-dev-config/ghostty/config ~/.config/ghostty/config

# Rendre executables
chmod +x ~/Tech/layou-dev-config/next-prayer.sh
chmod +x ~/Tech/layou-dev-config/claude/statusline.sh
chmod +x ~/Tech/layou-dev-config/claude/notify.sh
```

## Si tu changes de ville

Dans `next-prayer.sh` ligne 13, remplace les coordonnees :

| Ville | Coordonnees |
|---|---|
| Paris | `latitude=48.8566&longitude=2.3522` |
| Lyon | `latitude=45.7640&longitude=4.8357` |
| Alger | `latitude=36.7538&longitude=3.0588` |

## Notifications MGS1

Quand Claude Code attend une action (permission, input, plan approval), tu recois :
- Le son d'alerte Metal Gear Solid 1
- Une notification macOS avec l'icone "!" rouge, le contexte de l'attente, et l'heure

> Si les notifications ne s'affichent pas, lance `killall NotificationCenter` pour reset le cache.

## Statusline

La statusline affiche : modele, projet, branche, fichiers modifies, contexte utilise, lignes ajoutees/supprimees, temps de session, et prochaine priere.

```
[Claude] 📁 project | 🌿 main | ✎ 3
██████░░░░ 60% | +42 -10 | ☀️ 12m | 🟢 Dhuhr 1h45
```
