# NowPlayingSwift

Obtém informações da mídia tocando no macOS usando APIs do MediaRemote framework e controla a reprodução de música.

## Funcionalidades

- ✅ Exibir informações da música atual (título, álbum, artista, aplicativo)
- ✅ Controles de mídia (Play/Pause, Próxima, Anterior)
- ✅ Interface gráfica moderna com atualização automática
- ✅ Versão CLI para terminal

## Uso

### Compilar e Executar

```bash
# GUI (Interface Gráfica) - Recomendado
swiftc main_gui.swift -o NowPlayingGUI && ./NowPlayingGUI

# CLI (Terminal) - Apenas informações
swift main.swift
```

### Controles Disponíveis (GUI)

- **▶️** - Play/Pause
- **⏭️** - Próxima música
- **⏮️** - Música anterior
- **🔄** - Atualizar informações manualmente

## Requisitos

- macOS 15.4+
- Mídia tocando (Music, Spotify, YouTube, etc.)
- Permissões de acessibilidade (o sistema pode solicitar)

## Saída

**CLI:** `Never Gonna Give You Up - Whenever You Need Somebody - Rick Astley | Music`

**GUI:** Interface com campos separados, controles de mídia e atualização automática a cada 2s

## Arquivos

- `main.swift` - Versão CLI (terminal)
- `main_gui.swift` - Versão GUI (interface gráfica) **com controles de mídia**
- `run.sh` - Script de execução interativo
- `sample_script.scpt` - Script AppleScript original
- `Action_Plan.md` - Documentação do desenvolvimento

## Como Executar o Projeto

### Método 1: Script Interativo (Mais Fácil)

```bash
cd /Users/lucianosilva/dev/NowPlayingSwift
./run.sh
```

### Método 2: Comandos Diretos

```bash
cd /Users/lucianosilva/dev/NowPlayingSwift

# Para GUI com controles de mídia
swiftc main_gui.swift -o NowPlayingGUI && ./NowPlayingGUI

# Para CLI simples
swift main.swift
```

### Método 3: Compilar uma vez e usar várias vezes

```bash
cd /Users/lucianosilva/dev/NowPlayingSwift
swiftc main_gui.swift -o NowPlayingGUI
./NowPlayingGUI  # Execute quantas vezes quiser
```

## Dicas de Uso

1. **Inicie uma música** no Spotify, Apple Music, YouTube ou qualquer player antes de executar
2. **A interface gráfica** inclui controles ▶️⏭️⏮️ para controlar a reprodução
3. **Atualização automática** a cada 2 segundos na GUI
4. **Permissões**: O macOS pode solicitar permissões de acessibilidade na primeira execução

## Troubleshooting

- Se não aparecer informações: Verifique se há mídia tocando
- Se os controles não funcionarem: Aceite as permissões de acessibilidade
- Se houver erro de compilação: Verifique se está no macOS 15.4+
