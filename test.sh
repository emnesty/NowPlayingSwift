#!/bin/bash

echo "🎵 NowPlayingCLI - Teste das Funcionalidades"
echo "==========================================="
echo ""

echo "1. Testando compilação da versão CLI..."
make clean > /dev/null 2>&1
if make > /dev/null 2>&1; then
    echo "✅ CLI compilada com sucesso!"
else
    echo "❌ Erro na compilação da CLI"
    exit 1
fi

echo ""
echo "2. Testando compilação da versão GUI..."
if make gui > /dev/null 2>&1; then
    echo "✅ GUI compilada com sucesso!"
else
    echo "❌ Erro na compilação da GUI"
    exit 1
fi

echo ""
echo "3. Binários criados:"
ls -la build/

echo ""
echo "🚀 Para usar:"
echo "   CLI: ./build/nowplaying-cli"
echo "   GUI: ./build/nowplaying-gui"
echo ""
echo "📝 Para mais opções: make info"
