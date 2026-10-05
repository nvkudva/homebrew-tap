# nvkudva/homebrew-tap

Homebrew formulae for [Ollajev](https://github.com/nvkudva/ollajev): run System One decision models
from Hugging Face locally, Ollama style.

```sh
brew install nvkudva/tap/ollajev
ollajev                       # first run: pick a model, then serve
brew services start ollajev   # optional: run the server in the background at login
```

The formula installs the release from PyPI into its own Python 3.12 environment. Use either
`brew services` or `ollajev service install` for the background server, not both.
