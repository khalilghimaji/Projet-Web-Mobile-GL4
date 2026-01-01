# Base path
$base = "src/app/match"

# Helper function to create file if it doesn't exist
function Touch($path) {
    if (!(Test-Path $path)) {
        New-Item -ItemType File -Path $path | Out-Null
    }
}

# Create directories
$dirs = @(
    "$base/pages/match-detail",

    "$base/sections/match-header",
    "$base/sections/prediction-widget",
    "$base/sections/tabs-navigation",
    "$base/sections/match-timeline",
    "$base/sections/lineups-pitch",
    "$base/sections/team-stats",
    "$base/sections/head-to-head",
    "$base/sections/highlights",

    "$base/components/status-badge",
    "$base/components/team-display",
    "$base/components/score-display",
    "$base/components/timeline-event",
    "$base/components/player-position",
    "$base/components/stat-bar",
    "$base/components/form-indicator",
    "$base/components/video-card",

    "$base/services",
    "$base/types",
    "$base/utils"
)

foreach ($dir in $dirs) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

# Pages
Touch "$base/pages/match-detail/match-detail.page.ts"
Touch "$base/pages/match-detail/match-detail.page.html"
Touch "$base/pages/match-detail/match-detail.page.css"

# Sections
Touch "$base/sections/match-header/match-header.section.ts"
Touch "$base/sections/match-header/match-header.section.html"
Touch "$base/sections/match-header/match-header.section.css"

Touch "$base/sections/prediction-widget/prediction-widget.section.ts"
Touch "$base/sections/prediction-widget/prediction-widget.section.html"
Touch "$base/sections/prediction-widget/prediction-widget.section.css"

Touch "$base/sections/tabs-navigation/tabs-navigation.section.ts"
Touch "$base/sections/tabs-navigation/tabs-navigation.section.html"
Touch "$base/sections/tabs-navigation/tabs-navigation.section.css"

Touch "$base/sections/match-timeline/match-timeline.section.ts"
Touch "$base/sections/match-timeline/match-timeline.section.html"
Touch "$base/sections/match-timeline/match-timeline.section.css"

Touch "$base/sections/lineups-pitch/lineups-pitch.section.ts"
Touch "$base/sections/lineups-pitch/lineups-pitch.section.html"
Touch "$base/sections/lineups-pitch/lineups-pitch.section.css"

Touch "$base/sections/team-stats/team-stats.section.ts"
Touch "$base/sections/team-stats/team-stats.section.html"
Touch "$base/sections/team-stats/team-stats.section.css"

Touch "$base/sections/head-to-head/head-to-head.section.ts"
Touch "$base/sections/head-to-head/head-to-head.section.html"
Touch "$base/sections/head-to-head/head-to-head.section.css"

Touch "$base/sections/highlights/highlights.section.ts"
Touch "$base/sections/highlights/highlights.section.html"
Touch "$base/sections/highlights/highlights.section.css"

# Components
Touch "$base/components/status-badge/status-badge.component.ts"
Touch "$base/components/status-badge/status-badge.component.html"
Touch "$base/components/status-badge/status-badge.component.css"

Touch "$base/components/team-display/team-display.component.ts"
Touch "$base/components/team-display/team-display.component.html"
Touch "$base/components/team-display/team-display.component.css"

Touch "$base/components/score-display/score-display.component.ts"
Touch "$base/components/score-display/score-display.component.html"
Touch "$base/components/score-display/score-display.component.css"

Touch "$base/components/timeline-event/timeline-event.component.ts"
Touch "$base/components/timeline-event/timeline-event.component.html"
Touch "$base/components/timeline-event/timeline-event.component.css"

Touch "$base/components/player-position/player-position.component.ts"
Touch "$base/components/player-position/player-position.component.html"
Touch "$base/components/player-position/player-position.component.css"

Touch "$base/components/stat-bar/stat-bar.component.ts"
Touch "$base/components/stat-bar/stat-bar.component.html"
Touch "$base/components/stat-bar/stat-bar.component.css"

Touch "$base/components/form-indicator/form-indicator.component.ts"
Touch "$base/components/form-indicator/form-indicator.component.html"
Touch "$base/components/form-indicator/form-indicator.component.css"

Touch "$base/components/video-card/video-card.component.ts"
Touch "$base/components/video-card/video-card.component.html"
Touch "$base/components/video-card/video-card.component.css"

# Services
Touch "$base/services/live-match.service.ts"
Touch "$base/services/finished-match.service.ts"
Touch "$base/services/match-data.service.ts"

# Types
Touch "$base/types/match.types.ts"
Touch "$base/types/timeline.types.ts"
Touch "$base/types/lineup.types.ts"
Touch "$base/types/stats.types.ts"
Touch "$base/types/h2h.types.ts"
Touch "$base/types/highlight.types.ts"
Touch "$base/types/prediction.types.ts"

# Utils
Touch "$base/utils/computed-stats.util.ts"
Touch "$base/utils/formation.util.ts"

Write-Host "✅ Match feature file tree generated successfully."
