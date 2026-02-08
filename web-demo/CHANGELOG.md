# Changelog

## [Unreleased] - 2026-02-07

### Added
- **AI Healing Persona**: Integrated a "Warm & Healing" personality for the AI companion.
- **Tool Calling Simulation**: AI now detects "summary" requests and asks for mood before generating a diary card.
- **Journal Page**: New dedicated page for viewing diary cards (moved from Home).

### Changed
- **Navigation Structure**:
    - **Home**: Now points to the **Chat** interface for immediate interaction.
    - **Journal**: Added a book icon for the diary list.
    - Removed **Theme** and **Dialog** (Chat) buttons to simplify the bottom bar.
- **Routing**: Updated application routing to default to the Chat interface.

### Removed
- **Theme Page/Modal**: Removed from bottom navigation (theme switching is now exclusive to Community page).
