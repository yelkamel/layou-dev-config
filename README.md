# layou-dev-config

Config perso pour retrouver le meme setup sur n'importe quelle machine.

## Contenu

| Fichier | Destination | Description |
|---|---|---|
| `next-prayer.sh` | `~/Tech/layou-dev-config/next-prayer.sh` | Prochaine priere (API aladhan.com, cache quotidien) |
| `claude/statusline.sh` | `~/.claude/statusline.sh` | Statusline Claude Code (branche, contexte, priere) |
| `claude/settings.json` | `~/.claude/settings.json` | Settings Claude Code |

## Setup sur une nouvelle machine

### Pre-requis

- `jq` (`brew install jq` sur Mac)
- `git`
- `curl` (deja present sur Mac/Linux)

### Installation

```bash
# Cloner le repo
git clone git@github.com:layogtima/layou-dev-config.git ~/Tech/layou-dev-config

# Creer le dossier Claude
mkdir -p ~/.claude

# Copier les fichiers Claude
cp ~/Tech/layou-dev-config/claude/statusline.sh ~/.claude/statusline.sh
cp ~/Tech/layou-dev-config/claude/settings.json ~/.claude/settings.json

# Rendre executables
chmod +x ~/Tech/layou-dev-config/next-prayer.sh
chmod +x ~/.claude/statusline.sh
```

## Si tu changes de ville

Dans `next-prayer.sh` ligne 13, remplace les coordonnees :

| Ville | Coordonnees |
|---|---|
| Paris | `latitude=48.8566&longitude=2.3522` |
| Lyon | `latitude=45.7640&longitude=4.8357` |
| Alger | `latitude=36.7538&longitude=3.0588` |

## Statusline

La statusline affiche : modele, projet, branche, fichiers modifies, contexte utilise, lignes ajoutees/supprimees, temps de session, et prochaine priere.

```
[Claude] 📁 project | 🌿 main | ✎ 3
██████░░░░ 60% | +42 -10 | ☀️ 12m | 🟢 Dhuhr 1h45
```
