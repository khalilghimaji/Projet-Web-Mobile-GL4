# 🎨 Guide de validation visuelle rapide

## Checklist visuelle (2 minutes)

Utilisez cette checklist pour valider rapidement que les modifications fonctionnent correctement.

---

## 🔍 1. Header (en haut)

```
┌─────────────────────────────────────────┐
│ LINEUPS              4-3-3    4-3-3     │
│ (gris)            (badges blancs)       │
└─────────────────────────────────────────┘
```

**Vérifications :**
- [ ] "LINEUPS" en majuscules, gris, à gauche
- [ ] Deux badges de formation à droite
- [ ] Fond des badges : blanc semi-transparent
- [ ] Espace entre les deux badges

---

## 🏟️ 2. Terrain

```
┌─────────────────────────────────────────┐
│  ╔═══════════════════════════════╗     │
│  ║        ┌─────────┐            ║     │
│  ║        └─────────┘  [Away GK] ║     │ ← Gardien away (jaune)
│  ║    [Away players in red]      ║     │
│  ║────────────────────────────────║     │ ← Ligne médiane
│  ║          ⭕                    ║     │ ← Cercle central
│  ║    [Home players in sky-blue] ║     │
│  ║        ┌─────────┐  [Home GK] ║     │ ← Gardien home (jaune)
│  ║        └─────────┘            ║     │
│  ╚═══════════════════════════════╝     │
└─────────────────────────────────────────┘
```

**Vérifications :**
- [ ] Couleur de fond : Vert foncé (#2a4e3a)
- [ ] Lignes blanches visibles mais subtiles
- [ ] Bordure arrondie avec coins doux
- [ ] Ligne médiane horizontale au milieu
- [ ] Cercle central visible
- [ ] Deux zones de but (rectangles arrondis)

---

## 👤 3. Avatars des joueurs

### Gardien de but (en haut et en bas)
```
    ┌─────┐
    │  1  │  ← Cercle JAUNE (#FACC15)
    └─────┘
    Dupont   ← Texte noir sur jaune
```

**Vérifications :**
- [ ] Cercle jaune (#FACC15)
- [ ] Numéro en noir
- [ ] Bordure blanche
- [ ] Nom en dessous

### Joueur équipe à domicile (moitié basse)
```
    ┌─────┐
    │  10 │  ← Cercle BLEU CIEL (#BAE6FD)
    └─────┘
    Martin   ← Texte noir sur bleu ciel
```

**Vérifications :**
- [ ] Cercle bleu ciel (#BAE6FD)
- [ ] Numéro en noir
- [ ] Bordure blanche
- [ ] Nom en dessous

### Joueur équipe à l'extérieur (moitié haute)
```
    ┌─────┐
    │  9  │  ← Cercle ROUGE (#DC2626)
    └─────┘
    Silva    ← Texte BLANC sur rouge
```

**Vérifications :**
- [ ] Cercle rouge (#DC2626)
- [ ] Numéro en blanc
- [ ] Bordure blanche
- [ ] Nom en dessous

---

## 📏 4. Positionnement

### Formation 4-3-3 (exemple)

```
                  [GK away - jaune]
                        1

        7        5        6        8
        
            10       4       11
        
       9         2         3        
        
                  [GK home - jaune]
                        1
```

**Vérifications :**
- [ ] Gardiens bien collés aux bords (2% et 98%)
- [ ] Lignes de joueurs bien espacées
- [ ] Joueurs répartis équitablement en largeur
- [ ] Pas de chevauchement entre joueurs
- [ ] Formation visible et reconnaissable

---

## 🎨 5. Couleurs exactes à vérifier

| Élément | Couleur HEX | Visuel |
|---------|-------------|---------|
| Terrain | `#2a4e3a` | 🟩 Vert foncé |
| Gardien | `#FACC15` | 🟨 Jaune |
| Home | `#BAE6FD` | 🔵 Bleu ciel |
| Away | `#DC2626` | 🔴 Rouge |
| Lignes terrain | Blanc 20% opacity | ⚪ Blanc subtil |
| Bordure terrain | Blanc 10% opacity | ⚪ Blanc très subtil |

---

## 📱 6. Tests sur différentes tailles

### Téléphone portrait
```
┌──────────┐
│  LINEUPS │  ← Header visible
│ 4-3-3    │
├──────────┤
│          │
│ [Terrain]│  ← Terrain adapté
│          │
│          │
└──────────┘
```
- [ ] Tout est visible
- [ ] Pas de scroll horizontal
- [ ] Joueurs bien positionnés

### Téléphone paysage
```
┌────────────────────────┐
│ LINEUPS    4-3-3       │
├────────────────────────┤
│      [  Terrain  ]     │  ← Terrain plus large
└────────────────────────┘
```
- [ ] Header toujours visible
- [ ] Terrain bien centré
- [ ] Joueurs repositionnés correctement

---

## ⚡ Test rapide en 30 secondes

1. **Ouvrir l'app** et aller sur un match
2. **Scroller** jusqu'à la section "Lineups"
3. **Vérifier** :
   - ✅ Header "LINEUPS" + formations
   - ✅ Terrain vert foncé
   - ✅ Gardiens en jaune (en haut et en bas)
   - ✅ Une équipe en bleu ciel, l'autre en rouge
   - ✅ Formation reconnaissable (ex: 4-3-3)

Si ces 5 points sont ✅, c'est bon ! 🎉

---

## 🔴 Problèmes courants et solutions

### Problème : Gardiens pas en jaune
❌ Mauvais : Gardiens bleus ou rouges
✅ Bon : Gardiens jaunes (#FACC15)
**Solution** : Vérifier que le champ `position` contient "GK"

### Problème : Terrain trop clair
❌ Mauvais : Vert clair ou dégradé
✅ Bon : Vert foncé uni (#2a4e3a)
**Solution** : Vérifier `Color(0xFF2a4e3a)`

### Problème : Joueurs mal centrés
❌ Mauvais : Cercles décalés
✅ Bon : Cercles bien centrés sur leur position
**Solution** : Vérifier `Transform.translate(Offset(-18, -18))`

### Problème : Formations incorrectes
❌ Mauvais : Joueurs en ligne droite
✅ Bon : Joueurs répartis selon formation (4-3-3, etc.)
**Solution** : Vérifier que la formation est bien parsée

---

## 📊 Score de validation

Comptez les ✅ :

- **8-10 ✅** : Parfait ! 🎉
- **5-7 ✅** : Bon, quelques ajustements mineurs
- **< 5 ✅** : Vérifier les modifications

---

## 🎯 Objectif : 10/10 ✅

L'application mobile doit être visuellement identique au front-end Angular.

---

**Temps estimé** : 2-5 minutes  
**Niveau** : Débutant (visuel uniquement)  
**Outils** : Vos yeux 👀

