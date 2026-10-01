# Leonteq Task – GitHub Repo Search

Small iOS app for the Leonteq interview task.

You can search GitHub repositories by keyword, see the results in a list (name, description, stars, owner avatar), and open a detail screen with more info plus a link to the repo in Safari.

## What I used

- SwiftUI
- MVVM
- GitHub REST API (`/search/repositories`)
- async/await
- URLSession

## Features

- Search with debounce so we don’t hit the API on every keystroke
- List + detail
- Async avatar loading with an in-memory cache
- Pull to refresh
- Dark mode (system colors)
- Basic error handling (no network, empty results, rate limit / failed requests)
- Unit tests for decoding, the view model, and the GitHub service

## Architecture

Rough layout:

- `App` – dependency setup
- `Features/Search` – search screen + view model
- `Features/RepositoryDetail` – detail screen
- `Network` – generic HTTP client
- `GitHub` – GitHub-specific request/response + service
- `ImageLoading` – image download + cache
- `Models` – `Repository`

The view model talks to a `RepositorySearchService` protocol. The real implementation is `GitHubRepositoryService`, which uses the shared `HTTPClient`. Makes it easy to stub in tests.

## How to run

1. Open `leonteq task.xcodeproj` in Xcode
2. Pick an iPhone simulator
3. Run

Try searching for something like `swift`.

Note: unauthenticated GitHub search has a low rate limit, so don’t spam different queries too fast.

## Tests

Run the `leonteq taskTests` target in Xcode.
