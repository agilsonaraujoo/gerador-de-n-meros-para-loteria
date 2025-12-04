#!/bin/bash

# Script para fazer push da imagem Docker para GHCR
# Uso: ./push-docker-auto.sh <PAT_TOKEN>

if [ -z "$1" ]; then
  echo "Uso: $0 <PAT_TOKEN>"
  echo ""
  echo "Você precisa gerar um PAT no GitHub com os scopes:"
  echo "  - write:packages"
  echo "  - read:packages"
  echo "  - delete:packages"
  echo "  - repo"
  echo ""
  echo "Acesse: https://github.com/settings/tokens"
  echo "Gere um token 'classic' com os scopes acima"
  echo ""
  echo "Exemplo:"
  echo "  $0 ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  exit 1
fi

PAT="$1"
set -e

echo "=========================================="
echo "  Docker Push para GitHub Container Registry"
echo "=========================================="
echo ""

echo "Passo 1: Fazendo login no Docker..."
if echo "$PAT" | docker login ghcr.io -u agilsonaraujoo --password-stdin > /dev/null 2>&1; then
  echo "✓ Login bem-sucedido!"
else
  echo "✗ Falha no login. Token pode estar inválido."
  echo "Verifique se:"
  echo "  - O token foi gerado com os scopes: write:packages, read:packages, delete:packages, repo"
  echo "  - O token não expirou"
  exit 1
fi

echo ""
echo "Passo 2: Fazendo push da imagem..."
echo "(Isso pode levar alguns minutos)"
echo ""

if docker push ghcr.io/agilsonaraujoo/gerador-de-n-meros-para-loteria:v1.0.0; then
  echo ""
  echo "=========================================="
  echo "✓ Push bem-sucedido!"
  echo "=========================================="
  echo ""
  echo "Passo 3: Tornar a imagem pública"
  echo ""
  echo "Acesse: https://github.com/users/agilsonaraujoo/packages/container/gerador-de-n-meros-para-loteria"
  echo ""
  echo "1. Clique em 'Package settings' (ícone de engrenagem)"
  echo "2. Clique em 'Change visibility'"
  echo "3. Selecione 'Public' e confirme"
  echo ""
  echo "Sua imagem estará disponível em:"
  echo "  ghcr.io/agilsonaraujoo/gerador-de-n-meros-para-loteria:v1.0.0"
  echo ""
  echo "Para testar localmente:"
  echo "  docker run -d -p 8080:80 ghcr.io/agilsonaraujoo/gerador-de-n-meros-para-loteria:v1.0.0"
  echo ""
else
  echo "✗ Falha ao fazer push!"
  echo "Verifique se o token foi gerado com os scopes corretos."
  exit 1
fi
