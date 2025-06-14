import Foundation
import AppKit
import Darwin

// Classe para encapsular a funcionalidade de obter informações da mídia
class NowPlayingService {
    
    static func getNowPlayingInfo() -> (title: String, album: String, artist: String, appName: String)? {
        // Carregar o framework MediaRemote
        guard let mediaRemoteBundle = Bundle(path: "/System/Library/PrivateFrameworks/MediaRemote.framework/") else {
            return nil
        }
        mediaRemoteBundle.load()
        
        // Obter a classe MRNowPlayingRequest
        guard let MRNowPlayingRequest: AnyClass = NSClassFromString("MRNowPlayingRequest") else {
            return nil
        }
        
        // Função auxiliar para chamar métodos estáticos
        func callMethod(on object: AnyObject, selector: String) -> AnyObject? {
            let sel = NSSelectorFromString(selector)
            guard object.responds(to: sel) else { return nil }
            return object.perform(sel)?.takeUnretainedValue()
        }
        
        // Chamar os métodos (como no AppleScript)
        guard let playerPath = callMethod(on: MRNowPlayingRequest, selector: "localNowPlayingPlayerPath"),
              let client = callMethod(on: playerPath, selector: "client"),
              let appName = callMethod(on: client, selector: "displayName") as? String,
              let nowPlayingItem = callMethod(on: MRNowPlayingRequest, selector: "localNowPlayingItem"),
              let infoDict = callMethod(on: nowPlayingItem, selector: "nowPlayingInfo") as? NSDictionary else {
            return nil
        }
        
        // Extrair as informações
        let title = infoDict.value(forKey: "kMRMediaRemoteNowPlayingInfoTitle") as? String ?? "Unknown Title"
        let album = infoDict.value(forKey: "kMRMediaRemoteNowPlayingInfoAlbum") as? String ?? "Unknown Album"
        let artist = infoDict.value(forKey: "kMRMediaRemoteNowPlayingInfoArtist") as? String ?? "Unknown Artist"
        
        return (title: title, album: album, artist: artist, appName: appName)
    }
}

// Classe para controlar a reprodução de mídia
class MediaControlService {
    
    static func playPause() {
        executeMediaCommand(command: "kMRMediaRemoteCommandTogglePlayPause")
    }
    
    static func nextTrack() {
        executeMediaCommand(command: "kMRMediaRemoteCommandNextTrack")
    }
    
    static func previousTrack() {
        executeMediaCommand(command: "kMRMediaRemoteCommandPreviousTrack")
    }
    
    private static func executeMediaCommand(command: String) {
        // Carregar o framework MediaRemote
        guard let mediaRemoteBundle = Bundle(path: "/System/Library/PrivateFrameworks/MediaRemote.framework/") else {
            print("Erro: Não foi possível carregar o MediaRemote framework")
            return
        }
        mediaRemoteBundle.load()
        
        // Mapear comandos para valores
        let commandValue: UInt32
        switch command {
        case "kMRMediaRemoteCommandTogglePlayPause":
            commandValue = 2  // Valor para play/pause
        case "kMRMediaRemoteCommandNextTrack":
            commandValue = 4  // Valor para próxima faixa
        case "kMRMediaRemoteCommandPreviousTrack":
            commandValue = 5  // Valor para faixa anterior
        default:
            print("Comando não reconhecido: \(command)")
            return
        }
        
        // Usar dlsym para obter a função MRMediaRemoteSendCommand
        guard let handle = dlopen("/System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote", RTLD_LAZY) else {
            print("Erro: Não foi possível abrir MediaRemote")
            return
        }
        
        guard let sendCommandPtr = dlsym(handle, "MRMediaRemoteSendCommand") else {
            print("Erro: Não foi possível encontrar MRMediaRemoteSendCommand")
            dlclose(handle)
            return
        }
        
        // Converter para função tipada
        let sendCommand = unsafeBitCast(sendCommandPtr, to: (@convention(c) (UInt32, UnsafeRawPointer?) -> Void).self)
        
        // Executar comando
        sendCommand(commandValue, nil)
        
        // Fechar handle
        dlclose(handle)
    }
}

// Classe principal da aplicação GUI
class NowPlayingGUI: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    var titleLabel: NSTextField!
    var albumLabel: NSTextField!
    var artistLabel: NSTextField!
    var appLabel: NSTextField!
    var refreshButton: NSButton!
    var playPauseButton: NSButton!
    var nextTrackButton: NSButton!
    var previousTrackButton: NSButton!
    var timer: Timer?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupWindow()
        updateNowPlayingInfo()
        startAutoRefresh()
    }
    
    func setupWindow() {
        // Criar a janela principal
        window = NSWindow(
            contentRect: NSRect(x: 100, y: 100, width: 450, height: 350),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "Now Playing CLI - GUI"
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        // Container view
        let contentView = NSView(frame: window.contentView!.bounds)
        contentView.wantsLayer = true
        contentView.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        window.contentView = contentView
        
        // Título da aplicação
        let appTitleLabel = NSTextField(frame: NSRect(x: 20, y: 300, width: 410, height: 30))
        appTitleLabel.stringValue = "🎵 Now Playing Information"
        appTitleLabel.font = NSFont.boldSystemFont(ofSize: 18)
        appTitleLabel.alignment = .center
        appTitleLabel.isBezeled = false
        appTitleLabel.isEditable = false
        appTitleLabel.backgroundColor = NSColor.clear
        contentView.addSubview(appTitleLabel)
        
        // Labels para as informações
        let labelY = 250
        let labelHeight = 25
        let labelSpacing = 35
        
        // Título da música
        let titleHeaderLabel = createHeaderLabel(text: "Título:", frame: NSRect(x: 20, y: labelY, width: 80, height: labelHeight))
        contentView.addSubview(titleHeaderLabel)
        
        titleLabel = createInfoLabel(frame: NSRect(x: 110, y: labelY, width: 320, height: labelHeight))
        contentView.addSubview(titleLabel)
        
        // Álbum
        let albumHeaderLabel = createHeaderLabel(text: "Álbum:", frame: NSRect(x: 20, y: labelY - labelSpacing, width: 80, height: labelHeight))
        contentView.addSubview(albumHeaderLabel)
        
        albumLabel = createInfoLabel(frame: NSRect(x: 110, y: labelY - labelSpacing, width: 320, height: labelHeight))
        contentView.addSubview(albumLabel)
        
        // Artista
        let artistHeaderLabel = createHeaderLabel(text: "Artista:", frame: NSRect(x: 20, y: labelY - labelSpacing * 2, width: 80, height: labelHeight))
        contentView.addSubview(artistHeaderLabel)
        
        artistLabel = createInfoLabel(frame: NSRect(x: 110, y: labelY - labelSpacing * 2, width: 320, height: labelHeight))
        contentView.addSubview(artistLabel)
        
        // Aplicativo
        let appHeaderLabel = createHeaderLabel(text: "App:", frame: NSRect(x: 20, y: labelY - labelSpacing * 3, width: 80, height: labelHeight))
        contentView.addSubview(appHeaderLabel)
        
        appLabel = createInfoLabel(frame: NSRect(x: 110, y: labelY - labelSpacing * 3, width: 320, height: labelHeight))
        contentView.addSubview(appLabel)
        
        // Botão de atualizar
        refreshButton = NSButton(frame: NSRect(x: 175, y: 30, width: 100, height: 35))
        refreshButton.title = "🔄 Atualizar"
        refreshButton.bezelStyle = .rounded
        refreshButton.target = self
        refreshButton.action = #selector(refreshButtonClicked)
        contentView.addSubview(refreshButton)
        
        // Botão Play/Pause
        playPauseButton = NSButton(frame: NSRect(x: 20, y: 30, width: 35, height: 35))
        playPauseButton.title = "▶️"
        playPauseButton.bezelStyle = .rounded
        playPauseButton.target = self
        playPauseButton.action = #selector(playPauseButtonClicked)
        contentView.addSubview(playPauseButton)
        
        // Botão Próxima Faixa
        nextTrackButton = NSButton(frame: NSRect(x: 65, y: 30, width: 35, height: 35))
        nextTrackButton.title = "⏭️"
        nextTrackButton.bezelStyle = .rounded
        nextTrackButton.target = self
        nextTrackButton.action = #selector(nextTrackButtonClicked)
        contentView.addSubview(nextTrackButton)
        
        // Botão Faixa Anterior
        previousTrackButton = NSButton(frame: NSRect(x: 110, y: 30, width: 35, height: 35))
        previousTrackButton.title = "⏮️"
        previousTrackButton.bezelStyle = .rounded
        previousTrackButton.target = self
        previousTrackButton.action = #selector(previousTrackButtonClicked)
        contentView.addSubview(previousTrackButton)
        
        // Label de auto-refresh
        let autoRefreshLabel = NSTextField(frame: NSRect(x: 20, y: 10, width: 410, height: 15))
        autoRefreshLabel.stringValue = "Atualização automática a cada 2 segundos"
        autoRefreshLabel.font = NSFont.systemFont(ofSize: 11)
        autoRefreshLabel.textColor = NSColor.secondaryLabelColor
        autoRefreshLabel.alignment = .center
        autoRefreshLabel.isBezeled = false
        autoRefreshLabel.isEditable = false
        autoRefreshLabel.backgroundColor = NSColor.clear
        contentView.addSubview(autoRefreshLabel)
    }
    
    func createHeaderLabel(text: String, frame: NSRect) -> NSTextField {
        let label = NSTextField(frame: frame)
        label.stringValue = text
        label.font = NSFont.boldSystemFont(ofSize: 13)
        label.isBezeled = false
        label.isEditable = false
        label.backgroundColor = NSColor.clear
        label.textColor = NSColor.labelColor
        return label
    }
    
    func createInfoLabel(frame: NSRect) -> NSTextField {
        let label = NSTextField(frame: frame)
        label.stringValue = "Carregando..."
        label.font = NSFont.systemFont(ofSize: 13)
        label.isBezeled = false
        label.isEditable = false
        label.backgroundColor = NSColor.clear
        label.textColor = NSColor.secondaryLabelColor
        label.cell?.truncatesLastVisibleLine = true
        label.cell?.lineBreakMode = .byTruncatingTail
        return label
    }
    
    @objc func refreshButtonClicked() {
        updateNowPlayingInfo()
    }
    
    @objc func playPauseButtonClicked() {
        MediaControlService.playPause()
    }
    
    @objc func nextTrackButtonClicked() {
        MediaControlService.nextTrack()
    }
    
    @objc func previousTrackButtonClicked() {
        MediaControlService.previousTrack()
    }
    
    func updateNowPlayingInfo() {
        if let info = NowPlayingService.getNowPlayingInfo() {
            titleLabel.stringValue = info.title
            albumLabel.stringValue = info.album
            artistLabel.stringValue = info.artist
            appLabel.stringValue = info.appName
        } else {
            titleLabel.stringValue = "Nenhuma mídia tocando"
            albumLabel.stringValue = "-"
            artistLabel.stringValue = "-"
            appLabel.stringValue = "-"
        }
    }
    
    func startAutoRefresh() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.updateNowPlayingInfo()
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        timer?.invalidate()
    }
}

// Configurar e iniciar a aplicação
let app = NSApplication.shared
let delegate = NowPlayingGUI()
app.delegate = delegate

// Fazer a aplicação aparecer na dock e permitir foco
app.setActivationPolicy(.regular)
app.activate(ignoringOtherApps: true)

app.run()
