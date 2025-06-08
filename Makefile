# Makefile para NowPlayingCLI

# Configurações
TARGET = nowplaying-cli
SOURCE = main.swift
BUILD_DIR = build

# Compilador Swift
SWIFTC = swiftc

# Flags de compilação
SWIFT_FLAGS = -framework Foundation -framework AppKit

# Targets
.PHONY: all clean run install

all: $(BUILD_DIR)/$(TARGET)

$(BUILD_DIR)/$(TARGET): $(SOURCE)
	@mkdir -p $(BUILD_DIR)
	$(SWIFTC) $(SWIFT_FLAGS) -o $(BUILD_DIR)/$(TARGET) $(SOURCE)

run: $(BUILD_DIR)/$(TARGET)
	./$(BUILD_DIR)/$(TARGET)

clean:
	rm -rf $(BUILD_DIR)

install: $(BUILD_DIR)/$(TARGET)
	cp $(BUILD_DIR)/$(TARGET) /usr/local/bin/$(TARGET)
	@echo "Instalado em /usr/local/bin/$(TARGET)"

# Target para testar a compilação
test: $(BUILD_DIR)/$(TARGET)
	@echo "Testando a aplicação..."
	./$(BUILD_DIR)/$(TARGET)

# Informações sobre o projeto
info:
	@echo "NowPlayingCLI - Prova de Conceito"
	@echo "Plataforma: macOS 15.4+"
	@echo "Linguagem: Swift"
	@echo ""
	@echo "Comandos disponíveis:"
	@echo "  make        - Compila a aplicação"
	@echo "  make run    - Compila e executa"
	@echo "  make clean  - Remove arquivos de build"
	@echo "  make install- Instala no sistema"
	@echo "  make test   - Testa a aplicação"
