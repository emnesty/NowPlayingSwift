# NowPlayingCLI

Obtém informações da mídia tocando no macOS usando APIs do MediaRemote framework.

## 🚀 Uso Rápido

```bash
swift main.swift      # CLI (terminal)
swift main_gui.swift  # GUI (interface gráfica)
```

## Requisitos

- macOS 15.4+
- Mídia tocando (Music, Spotify, YouTube, etc.)

## Uso

### Versão CLI (Original):

#### Executar diretamente:

```bash
swift main.swift
```

#### Ou compilar e executar:

```bash
make run
```

## Saída

**CLI:** `Never Gonna Give You Up - Whenever You Need Somebody - Rick Astley | Music`

**GUI:** Interface com campos separados, atualização automática a cada 2s e botão de refresh manual.

## Compilar (Opcional)

```bash
make        # CLI
make gui    # GUI
make run    # Compila e roda CLI
make run-gui # Compila e roda GUI
```

## Problemas?

- Use `swift` diretamente em vez de `make run`
- Certifique-se de que há mídia tocando
- Funciona apenas no macOS 15.4+

## Arquivos

- `main.swift` - CLI
- `main_gui.swift` - GUI  
- `Action_Plan.md` - Documentação original
