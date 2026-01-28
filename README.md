# Pokedex App - Flutter Challenge

App multiplataforma (mobile, tablet, web) que consume la PokeAPI para mostrar un listado paginado de Pokemon con detalle y búsqueda local.

## Arquitectura y Escalabilidad

**Patron:** Clean Architecture simplificada con Cubit (flutter_bloc).

```
lib/
├── core/           # Utilidades compartidas (DI, theme, widgets, constants)
├── data/           # Datasources (remote/local), models, repository impl
└── features/
    └── pokedex/
        ├── domain/     # Entities, repository interface, use cases, failures
        ├── cubit/      # Estado y lógica de presentación
        ├── screens/    # Pantallas
        └── widgets/    # Widgets de feature
```

**Por qué escala:**
- **Separación de capas:** UI no conoce Dio ni Hive, solo consume use cases
- **Inyección de dependencias:** `Dependencies.init()` centraliza creación, fácil de reemplazar por get_it/injectable
- **Feature-based:** Cada feature es autónoma, permite equipos paralelos
- **Web-ready:** `ResponsiveLayout` + `ContentContainer` adaptan cualquier pantalla sin duplicar widgets

## Trade-offs por Timebox (1 dia)

| Decisión | Justificación |
|----------|---------------|
| Sin shimmer animation | Menos dependencias, skeletons estáticos suficientes |
| Cache sin versionado/TTL | Hive simple, sin invalidación automática |
| Sin tests de widgets | Bajo ROI vs tests de cubit/repository |
| Offline parcial |  Lectura desde cache disponible, sin write/sync offline  |
| Sin deep linking web | Navigator 1.0 suficiente para el scope |

## Gestión de Estado y Side-Effects

**Flujo UI → Estado → Datos:**

```
[UI] ──onTap──> [Cubit.loadMore()] ──await──> [UseCase] ──> [Repository] ──> [Remote/Local]
                      │
                      └── emit(state.copyWith(...))
                                │
[UI] <──BlocBuilder/Listener────┘
```

**Desacoplamiento:**
- UI solo ve `PokedexState` (status, pokemon, isLoadingMore, failure)
- Cubit solo conoce UseCase, no datasources
- Repository decide si usa remote o cache
- Failures tipados (`NetworkFailure`, `NoCacheFailure`) en lugar de exceptions crudas

**Ejemplo:** `pokedex_cubit.dart:52-71` - loadMore no conoce HTTP ni Hive

## Offline y Cache

**Estrategia:** Cache-aside con fallback

```dart
// pokemon_repository_impl.dart - estrategia simplificada
try {
  final remote = await _remote.getPokemonList(...);
  _local.savePokemonList(remote);  // Actualiza cache
  return remote;
} catch (e) {
  final cached = _local.getPokemonList(...);  // Fallback
  if (cached.isNotEmpty) return cached;
  throw NetworkFailure();
}
```

**Qué se guarda:**
- Lista de Pokemon (Box `pokemon_list`)
- Detalles individuales (Box `pokemon_detail`)

**Invalidación:** Manual (no hay TTL). Trade-off consciente: para un producto real agregaria `cached_at` timestamp y TTL configurable.

**Conflictos:** Los datos siempre se priorizan desde la API. El cache local se utiliza únicamente si no hay conexión.

## Flutter Web

**Decisiones implementadas:**

1. **Responsive grid:** 2 columnas mobile, 3 tablet, 4 desktop (`pokedex_screen.dart:163-194`)
2. **ContentContainer:** Max-width 1000px centrado, evita contenido estirado (`responsive_layout.dart:47-71`)
3. **SearchBar constrained:** Mismo max-width que grid en web (`pokedex_screen.dart:220`)
4. **Spacing adaptivo:** `Spacing.sm/md/lg` segun breakpoint
5. **CachedNetworkImage:** Cache en memoria en web (sin persistencia en disco, comportamiento esperado)

**Limitaciones y mitigaciones:**

| Limitación | Mitigación |
|------------|------------|
| Sin hover states | Agregaria `MouseRegion` + elevation en hover |
| Sin keyboard navigation | Agregaria `FocusTraversalGroup` |
| Sin deep linking | Migraria a GoRouter para URLs semanticas |
| Scroll con mouse wheel | Funciona, pero agregaria scroll momentum tuning |

## Calidad - 3 Decisiones de Código Limpio

**1. Propiedades derivadas en entidades (no en build)**
```dart
// pokemon_detail.dart:14-20
late final String displayName = _capitalize(name);
late final String displayHeight = '${(height / 10).toStringAsFixed(1)} m';
```
Evita recalcular strings en cada rebuild.

**2. Cache de BoxDecoration por colorScheme**
```dart
// card_styles.dart - evita crear objetos en cada build
static final Map<int, BoxDecoration> _cardDecorationCache = {};
static BoxDecoration cardDecoration(BuildContext context) {
  final cacheKey = Theme.of(context).colorScheme.hashCode;
  return _cardDecorationCache.putIfAbsent(cacheKey, () => BoxDecoration(...));
}
```

**3. Barrel exports para imports limpios**
```dart
// Antes (multiples imports)
import '../constants/sizes.dart';
import '../constants/spacing.dart';

// Despues (barrel)
import '../constants/constants.dart';
```

## Testing

**Que se testeó:**

| Capa | Tests | Archivo |
|------|-------|---------|
| Cubit | Estados, transiciones, errores | `pokedex_cubit_test.dart`, `pokemon_detail_cubit_test.dart` |
| Repository | Remote/cache fallback, persistencia | `pokemon_repository_test.dart` |

**Por que estas prioridades:**
- Cubits tienen la lógica de negocio de presentación
- Repository tiene la lógica de sincronización cache/remote
- Son las capas con más probabilidad de bugs y regresiones

**Tests que agregaria (prioridad):**

1. **Widget test de `PokemonCardItem`** - asegurar que renderiza displayId en posicion correcta
2. **Integration test de search** - flujo completo UI → filtrado → resultados
3. **Golden test de `PokemonDetailScreen`** - detectar regresiones visuales

## Git

**Convencion:** Conventional Commits (`feat:`, `fix:`, `refactor:`, `perf:`, `chore:`)

**Granularidad:** Un commit por cambio lógico completo y funcional

```
0e22e59 fix: align SearchBar with grid content on web layout
f057e3e feat: unify cards and add responsive search grid
33d15d9 perf: preload images after frame render to improve infinite scroll
61c46bf refactor: optimize entity and detail screen for performance
386fa7b refactor: add barrel exports for constants and theme
```

**Criterio:** Cada commit compila, pasa tests, y tiene un propósito claro. Facilita cherry-pick, revert, y code review.

## Pendientes (Top 5 Priorizado)

| # | Pendiente | Cómo lo implementaría |
|---|-----------|----------------------|
| 1 | **Deep linking web** | Migrar a GoRouter, rutas `/pokemon/:id` |
| 2 | **Cache con TTL** | Agregar `cachedAt` a modelos, invalidar si > 1 hora |
| 3 | **Favoritos** | Nueva entity + Hive box + toggle en UI |
| 4 | **Keyboard navigation (web)** | `FocusTraversalGroup` + shortcuts para search |
| 5 | **Shimmer loading** | Agregar `shimmer` package a skeletons existentes |

---

## Setup

```bash
flutter pub get
flutter run
```

## Tests

```bash
flutter test
```
