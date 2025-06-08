import Foundation
import AppKit

// Carregar o framework MediaRemote
let mediaRemoteBundle = Bundle(path: "/System/Library/PrivateFrameworks/MediaRemote.framework/")!
mediaRemoteBundle.load()

// Obter a classe MRNowPlayingRequest
let MRNowPlayingRequest: AnyClass = NSClassFromString("MRNowPlayingRequest")!

// Função auxiliar para chamar métodos estáticos
func callMethod(on object: AnyObject, selector: String) -> AnyObject? {
    let sel = NSSelectorFromString(selector)
    guard object.responds(to: sel) else { return nil }
    return object.perform(sel)?.takeUnretainedValue()
}

// Chamar os métodos (como no AppleScript)
let playerPath = callMethod(on: MRNowPlayingRequest, selector: "localNowPlayingPlayerPath")!
let client = callMethod(on: playerPath, selector: "client")!
let appName = callMethod(on: client, selector: "displayName") as! String

let nowPlayingItem = callMethod(on: MRNowPlayingRequest, selector: "localNowPlayingItem")!
let infoDict = callMethod(on: nowPlayingItem, selector: "nowPlayingInfo") as! NSDictionary

// Extrair as informações
let title = infoDict.value(forKey: "kMRMediaRemoteNowPlayingInfoTitle") as? String ?? "Unknown Title"
let album = infoDict.value(forKey: "kMRMediaRemoteNowPlayingInfoAlbum") as? String ?? "Unknown Album"
let artist = infoDict.value(forKey: "kMRMediaRemoteNowPlayingInfoArtist") as? String ?? "Unknown Artist"

// Exibir resultado
print("\(title) - \(album) - \(artist) | \(appName)")
