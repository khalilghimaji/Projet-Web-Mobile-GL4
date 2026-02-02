# Guide de test - Affichage des compositions (Lineups)

## Modifications effectuées

Les compositions d'équipe ont été mises à jour pour correspondre exactement à l'implémentation du front-end Angular.

## Comment tester

### 1. Lancer l'application mobile

```bash
cd mobile
flutter run
```

### 2. Naviguer vers un match avec des compositions

- Ouvrir un match qui a des données de composition (lineups)
- Aller à l'onglet "Lineups" dans les détails du match

### 3. Vérifications visuelles

#### Header
- [ ] Le titre "LINEUPS" apparaît en majuscules à gauche, en gris
- [ ] Les formations (ex: "4-3-3") apparaissent à droite dans des badges
- [ ] Les badges ont un fond semi-transparent blanc

#### Terrain
- [ ] Le terrain a une couleur verte foncée (#2a4e3a)
- [ ] Les lignes du terrain sont visibles mais subtiles (opacité faible)
- [ ] Le cercle central est proportionnel à la taille du terrain
- [ ] Les zones de but sont visibles en haut et en bas

#### Joueurs
- [ ] **Gardiens de but** : cercle jaune (#FACC15) avec numéro en noir
- [ ] **Équipe à domicile** : cercles bleu ciel (#BAE6FD) avec numéros en noir
- [ ] **Équipe à l'extérieur** : cercles rouges (#DC2626) avec numéros en blanc
- [ ] Les numéros de maillot sont bien centrés dans les cercles
- [ ] Les noms des joueurs apparaissent sous les cercles sur fond noir semi-transparent
- [ ] Les joueurs sont bien positionnés selon leur formation

### 4. Tests avec différentes formations

Tester avec plusieurs formations pour vérifier le positionnement :
- [ ] 4-3-3 (formation classique)
- [ ] 4-4-2 (formation équilibrée)
- [ ] 3-5-2 (avec 3 défenseurs)
- [ ] 4-2-3-1 (avec milieu défensif)

### 5. Tests de responsivité

- [ ] Tester sur un téléphone en mode portrait
- [ ] Tester sur un téléphone en mode paysage
- [ ] Tester sur une tablette (si disponible)
- [ ] Vérifier que les joueurs restent bien positionnés à toutes les tailles

### 6. Comparaison avec le front-end

Si possible, comparer côte à côte :
- Ouvrir le même match sur le front-end Angular (web)
- Comparer les couleurs, positions et layout
- Vérifier que les formations sont identiques

## Points de comparaison clés

| Élément | Front-end (Angular) | Mobile (Flutter) | Status |
|---------|-------------------|------------------|---------|
| Couleur terrain | #2a4e3a | #2a4e3a | ✅ |
| Gardien | Jaune #FACC15 | Jaune #FACC15 | ✅ |
| Équipe domicile | Bleu ciel #BAE6FD | Bleu ciel #BAE6FD | ✅ |
| Équipe extérieur | Rouge #DC2626 | Rouge #DC2626 | ✅ |
| Position gardien domicile | 2% | 2% | ✅ |
| Position gardien extérieur | 98% | 98% | ✅ |
| Espacement horizontal | 80% largeur | 80% largeur | ✅ |
| Aspect ratio | 2:3 | 2:3 | ✅ |

## Problèmes potentiels et solutions

### Problème : Les joueurs se chevauchent
**Solution** : Vérifier que la formation est bien parsée (ex: "4-3-3" et non "433")

### Problème : Les gardiens ne sont pas jaunes
**Solution** : Vérifier que le champ `position` contient "GK" ou "Goalkeeper"

### Problème : Le terrain est trop petit/grand
**Solution** : Vérifier que `AspectRatio(2/3)` et `maxHeight: 500` sont bien appliqués

### Problème : Les noms sont tronqués
**Solution** : C'est normal, seul le nom de famille est affiché. Vérifier `maxWidth: 70`

## Fichiers modifiés

1. `lib/widgets/match/match_sections_widgets.dart` - Widget de composition
2. `lib/utils/formation_util.dart` - Calculs de position
3. Aucun changement dans les models ou providers

## Pour les développeurs

### Structure du code

```dart
LineupsPitchWidget
├── Header (titre + formations)
├── AspectRatio (2:3)
    └── Container (maxHeight: 500)
        └── LayoutBuilder
            └── Stack
                ├── Pitch lines (CustomPaint)
                ├── Home players (Positioned widgets)
                └── Away players (Positioned widgets)
```

### Points clés de l'implémentation

1. **LayoutBuilder** : Permet d'obtenir les dimensions réelles du conteneur
2. **Transform.translate(-18, -18)** : Centre les avatars de 36x36px
3. **Détection GK** : `position.toLowerCase() == 'gk'`
4. **Calcul positions** : Pourcentage × dimensions du conteneur

## Ressources

- Front-end de référence : `front/src/app/match/sections/lineups-pitch/`
- Utilitaire formation front : `front/src/app/match/utils/formation.util.ts`
- Composant joueur front : `front/src/app/match/components/player-position/`

---

**Date de modification** : 2026-02-02
**Auteur** : GitHub Copilot

