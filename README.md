# Pokédex SwiftUI 📱

[![CI](https://github.com/luanbalves/Pokedex-SwiftUI/actions/workflows/ci.yml/badge.svg)](https://github.com/luanbalves/Pokedex-SwiftUI/actions/workflows/ci.yml)

Um app de Pokédex em **SwiftUI** consumindo a [PokeAPI](https://pokeapi.co), feito como projeto de estudo de boas práticas de arquitetura e testes.

## ✨ Funcionalidades

- **Lista paginada com scroll infinito** — carrega 24 pokémons por página conforme você rola
- **Pull to refresh** para recarregar do zero
- **Tela de detalhes** com artwork oficial em alta resolução, tipos, altura, peso e experiência base
- **Cores dominantes** extraídas da imagem de cada pokémon com Core Image (o fundo do card e da tela de detalhes se adapta ao pokémon)
- **Cache de imagens em dois níveis** — memória (`NSCache`) + disco (`FileManager`), sem baixar tudo de novo a cada sessão
- **Estados de erro amigáveis** com botão "Tentar novamente" (na lista, na paginação e nos detalhes)
- **Dark mode** e **acessibilidade** (labels nos cards)

## 🏗 Arquitetura

O projeto usa uma organização modular simples com navegação baseada em `NavigationStack` + value-based routing:

```
┌─────────────┐
│  PokedexApp │  @main, configura NavigationStack + Environment
└──────┬──────┘
       │
┌──────▼──────┐     ┌────────────────┐
│  AppRouter  │────▶│  PokemonRoute  │  enum de rotas (list / details)
└──────┬──────┘     └────────────────┘
       │
┌──────▼───────────┐
│ AppDependencies  │  factory de services (permite trocar implementações)
└──────┬───────────┘
       │
┌──────▼─────────────────────── Swift Concurrency ──────────────┐
│ Screen (@Observable ViewModel) → Service (async throws)       │
│                                   → Endpoint (URLRequest)     │
│                                   → HTTPClient (URLSession)   │
└───────────────────────────────────────────────────────────────┘
```

**Padrões aplicados:**

- **MVVM com `@Observable`** (iOS 17+) — sem `ObservableObject`/`@Published` boilerplate, tracking por acesso a propriedades
- **Router** central com `NavigationPath` e rotas tipadas (`enum`), sem acoplamento das telas
- **Dependency injection** via `AppDependencies`, services injetáveis nas ViewModels
- **Camada de rede** com `Endpoint` (protocolo) → `URLRequest`, `HTTPClient` com `URLSession` injetável para testes, e erros tipados (`RequestError: LocalizedError`)

## 🧪 Testes

Migrados para o framework nativo **Swift Testing** (`@Test` / `#expect`):

- `HTTPClientTests` — decode, 401, status codes inesperados, com `URLProtocol` mockado (sem rede real)
- `PokemonEndpointTests` — construção de query params, paths e `URLRequest`
- `PokemonListViewModelTests` — paginação, dedupe, scroll infinito, erros e retry
- `PokemonDetailsViewModelTests` — carregamento, erro e reset de estado

```bash
xcodebuild test -project Pokedex/Pokedex.xcodeproj -scheme Pokedex \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

## 🛠 Requisitos

- Xcode 16.2+ (projeto com synchronized groups)
- iOS 18.2+

## 📁 Estrutura

```
Pokedex/
├── Pokedex/
│   ├── Network/          # Endpoint, HTTPClient, Services, Models
│   ├── Pokemon/
│   │   ├── List/         # Lista, grid, scroll infinito
│   │   └── Details/      # Detalhes, background com cor dominante
│   ├── Router/           # AppRouter e rotas tipadas
│   ├── Dependencies/     # AppDependencies (DI)
│   └── Utils/            # Cache de imagens, extensões, ErrorStateView
└── PokedexTests/         # Swift Testing (unit tests + mocks)
```

## 🔮 Próximos passos (roadmap)

- [ ] Swift 6 language mode (strict concurrency)
- [ ] Stats com barras na tela de detalhes
- [ ] Localização (PT/EN) com String Catalog
- [ ] Favoritos locais com SwiftData
