# Movie Search App with OMDb API

A Flutter application for searching and exploring movies using the OMDb API. The app allows users to search for movies, view movie details, and save favorites.

## Features

- Search for movies using the OMDb API
- View detailed information about movies
- Save favorite movies for later viewing
- Responsive and modern UI with loading animations
- Error handling for API requests and network issues

## Architecture

This project follows a clean architecture approach with a clear separation of concerns:

- **Data Layer**: API calls and data models
- **Domain Layer**: Business logic and entities
- **Presentation Layer**: UI components and state management using Provider

## Packages Used

- **Provider (^6.0.5)**: For state management
- **http (^1.1.0)**: For making API requests
- **dartz (^0.10.1)**: For functional programming and error handling
- **get_it (^7.6.4)**: For dependency injection
- **equatable (^2.0.5)**: For value-based equality comparison
- **shared_preferences (^2.5.3)**: For local storage of favorites
- **cached_network_image (^3.4.1)**: For efficient image loading and caching
- **shimmer (^3.0.0)**: For loading animations

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart  // API URLs and keys
│   │   └── app_constants.dart  // App-wide constants
│   ├── error/
│   │   └── exceptions.dart     // Custom exceptions
│   └── themes/
│       └── app_theme.dart      // App theme configuration
├── features/
│   └── movie_search/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── movie_remote_data_source.dart  // API calls
│       │   ├── models/
│       │   │   ├── movie_detail_model.dart        // Movie detail model
│       │   │   └── movie_search_result_model.dart // Search result model
│       │   └── repositories/
│       │       └── movie_repository_impl.dart     // Repository implementation
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── movie_detail.dart              // Movie detail entity
│       │   │   └── movie_search_result.dart       // Search result entity
│       │   ├── repositories/
│       │   │   └── movie_repository.dart          // Repository interface
│       │   └── usecases/
│       │       ├── get_movie_details.dart         // Get movie details use case
│       │       └── search_movies.dart             // Search movies use case
│       └── presentation/
│           ├── pages/
│           │   ├── favorites_page.dart            // Favorites screen
│           │   ├── home_page.dart                 // Home screen
│           │   ├── movie_detail_page.dart         // Movie details screen
│           │   └── movie_search_page.dart         // Search screen
│           ├── providers/
│           │   ├── favorites_provider.dart        // Favorites state management
│           │   ├── home_provider.dart             // Home screen state management
│           │   ├── movie_detail_provider.dart     // Movie details state management
│           │   └── movie_search_provider.dart     // Search state management
│           └── widgets/
│               └── ...                            // Reusable UI components
├── injection_container.dart                       // Dependency injection setup
└── main.dart                                      // App entry point
```

## Data Flow

1. **User Interaction**: User interacts with the UI (search for a movie, tap on a movie, etc.)
2. **Provider State Management**: The provider classes manage the state and call appropriate use cases
3. **Use Cases**: Business logic is executed in use cases, which call repository methods
4. **Repository**: Abstracts the data source and handles error cases
5. **Data Source**: Makes API calls to the OMDb API and returns data models
6. **Models**: API responses are converted to models and then to domain entities
7. **UI Update**: The UI is updated based on the new state from providers

## API Implementation

The app uses the OMDb API for fetching movie data. The API implementation is found in `movie_remote_data_source.dart`:

- **Search Movies**: Calls the OMDb search endpoint to find movies by title
- **Get Movie Details**: Fetches detailed information about a specific movie by IMDB ID

API URLs are configured in `api_constants.dart` with proper error handling for network issues and API errors.

## How to Run

1. Clone the repository
2. Get dependencies:
   ```
   flutter pub get
   ```
3. Run the app:
   ```
   flutter run
   ```

## Dependencies Setup

You need to have Flutter installed on your machine. This project uses Flutter version compatible with SDK '>=3.0.0 <4.0.0'.

## API Key Configuration

To use the app with your own API key:
1. Sign up for an API key at [OMDb API](https://www.omdbapi.com/apikey.aspx)
2. Replace the `omdbApiKey` value in `lib/core/constants/api_constants.dart`

## License

[Include your license information here]
