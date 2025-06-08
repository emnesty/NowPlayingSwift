# NowPlaying CLI — História do Usuário e Plano Técnico

## Definição do Problema de Negócio

### História do Usuário

**Como** desenvolvedor/power user do macOS 15.4+  
**Eu quero** consultar via aplicação swift as informações da mídia atualmente tocando  
**Para que** eu possa integrar essas informações em uma aplicação maior
**Limitado a** uma prova de conceito provando a funcionalidade

### Requisitos Funcionais

O utilitário deve exibir:

- **Título** da música/vídeo
- **Álbum**
- **Artista**
- **Aplicativo de origem** (Music, Spotify, YouTube, etc.)
- **Estado de reprodução** (tocando/pausado)

### Contexto Técnico e Restrições

- **Plataforma Alvo:** macOS 15.4+ exclusivamente
- **Problema:** Após a atualização do macOS para o 15.4 essa funcionalidade passou a não funcionar mais com a implementação feita por APIs tradicionalmente
- **A aplicação gerada** é dsiponibilizada por fora da App Store, não se limitando as restrições impostas por padrão

## O que funciona?

Esses scripts foram validados e funcionam exatamente como preciso:

- sample_script.scpt

```
use framework "AppKit"

on run
	set MediaRemote to current application's NSBundle's bundleWithPath:"/System/Library/PrivateFrameworks/MediaRemote.framework/"
	MediaRemote's load()

	set MRNowPlayingRequest to current application's NSClassFromString("MRNowPlayingRequest")

	set appName to MRNowPlayingRequest's localNowPlayingPlayerPath()'s client()'s displayName()
	set infoDict to MRNowPlayingRequest's localNowPlayingItem()'s nowPlayingInfo()

	set title to (infoDict's valueForKey:"kMRMediaRemoteNowPlayingInfoTitle") as text
	set album to (infoDict's valueForKey:"kMRMediaRemoteNowPlayingInfoAlbum") as text
	set artist to (infoDict's valueForKey:"kMRMediaRemoteNowPlayingInfoArtist") as text

	return title & " - " & album & " - " & artist & " | " & appName
end run
```

comando utilizado no terminal:

> osascript ./now_playing.scpt
