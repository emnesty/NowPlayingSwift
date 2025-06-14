#!/bin/bash

# Script para executar o NowPlayingSwift

echo "🎵 NowPlayingSwift - Controle de Mídia"
echo "======================================"
echo ""

# Verificar se existe música tocando
echo "Verificando se há mídia tocando..."
if ! swift main.swift 2>/dev/null | grep -v "Unknown" > /dev/null; then
    echo "⚠️  Nenhuma mídia detectada. Inicie uma música no Spotify, Apple Music, YouTube, etc."
    echo ""
fi

echo "Escolha uma opção:"
echo "1) Executar GUI (Interface Gráfica) - Recomendado"
echo "2) Executar CLI (Terminal)"
echo "3) Compilar GUI para uso posterior"
echo ""

read -p "Digite sua escolha (1-3): " choice

case $choice in
    1)
        echo ""
        echo "🚀 Iniciando interface gráfica..."
        echo "💡 Use os botões ▶️⏭️⏮️ para controlar a música"
        swiftc main_gui.swift -o NowPlayingGUI && ./NowPlayingGUI
        ;;
    2)
        echo ""
        echo "📱 Executando versão CLI..."
        swift main.swift
        ;;
    3)
        echo ""
        echo "🔨 Compilando..."
        swiftc main_gui.swift -o NowPlayingGUI
        echo "✅ Compilado! Execute com: ./NowPlayingGUI"
        ;;
    *)
        echo "Opção inválida. Executando GUI por padrão..."
        swiftc main_gui.swift -o NowPlayingGUI && ./NowPlayingGUI
        ;;
esac
