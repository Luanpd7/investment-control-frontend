#!/bin/bash

# Baixa o Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable

# Adiciona o Flutter ao PATH
export PATH="$PWD/flutter/bin:$PATH"

# Verifica se o Flutter está funcionando
flutter --version

# Habilita o Flutter Web
flutter config --enable-web

# Instala as dependências do projeto
flutter pub get

# Faz o build do projeto Web
flutter build web