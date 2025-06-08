# NowPlayingCLI - Swift Version

Uma prova de conceito em Swift para obter informações da mídia tocando atualmente no macOS 15.4+.

## Descrição

Esta aplicação Swift replica a funcionalidade do script AppleScript original, usando as mesmas APIs privadas do MediaRemote framework para obter:

- Título da música/vídeo
- Álbum
- Artista
- Aplicativo de origem (Music, Spotify, YouTube, etc.)

## Requisitos

- macOS 15.4+
- Swift (incluído no Xcode Command Line Tools)

## Instalação

1. Clone ou baixe este repositório
2. No terminal, navegue até o diretório do projeto
3. Execute: `make`

## Uso

### Compilar e executar:
```bash
make run
```

### Apenas compilar:
```bash
make
```

### Executar o binário compilado:
```bash
./build/nowplaying-cli
```

### Instalar no sistema:
```bash
make install
```

## Exemplo de Saída

```
Never Gonna Give You Up - Whenever You Need Somebody - Rick Astley | Music
```

## Estrutura do Projeto

- `main.swift` - Código principal da aplicação
- `Makefile` - Scripts de build e instalação
- `Action_Plan.md` - Documentação original do projeto

## Limitações

- Funciona apenas no macOS 15.4+
- Usa APIs privadas do sistema (MediaRemote framework)
- Destinado para uso fora da App Store

## Comparação com o AppleScript Original

Esta versão Swift mantém a mesma funcionalidade do script AppleScript original, mas oferece:
- Melhor performance
- Integração mais fácil com outras aplicações Swift/Objective-C
- Binário standalone compilado
