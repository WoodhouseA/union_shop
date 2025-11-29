# Union Shop App

A Flutter-based e-commerce application for the University of Portsmouth Union Shop. This application allows students and visitors to browse merchandise, view collections, and personalize items through "The Union Print Shack".

## Features

*   **Product Browsing:** View a wide range of university merchandise, including clothing, accessories, and stationery.
*   **Collections:** Browse products by specific collections (e.g., Hoodies, T-Shirts, Accessories).
*   **The Union Print Shack:** A dedicated section for personalizing merchandise. Users can preview custom text and colors on items before adding them to their cart.
*   **Shopping Cart:** Manage items in the cart, update quantities, and remove items.
*   **Simulated Checkout:** A demonstration of the checkout process.
*   **Responsive Design:** The application is designed to work seamlessly on both mobile and desktop web/native platforms.
*   **Sale Section:** Dedicated view for discounted items.
*   **Authentication UI:** Interactive Login and Sign Up forms.
*   **Print Shack Information:** Detailed service information, pricing, and terms for the Print Shack.
*   **Search Functionality:** Quickly find products by name or keyword using the search bar in the header or footer.

## Installation and Setup

### Prerequisites

*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (Version >= 3.0.0)
*   [Dart SDK](https://dart.dev/get-dart)
*   An IDE (VS Code, Android Studio, or IntelliJ) with Flutter and Dart plugins installed.

### Installation Steps

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/WoodhouseA/union_shop.git
    cd union_shop
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the application:**
    *   **Debug Mode:**
        ```bash
        flutter run
        ```
    *   **Release Mode:**
        ```bash
        flutter run --release
        ```

## Usage

### Main Features

1.  **Home Page:** The landing page displays featured products and a hero section highlighting current sales.
2.  **Navigation:** Use the top navigation bar (desktop) or the hamburger menu (mobile) to navigate between Home, Collections, Sale, Print Shack, and About Us.
3.  **Search:**
    *   Use the search bar in the navigation menu (desktop) or click the search icon (mobile).
    *   Enter keywords (e.g., "hoodie", "mug") to filter products.
    *   View results on the dedicated Search Results page.
4.  **Print Shack:**
    *   Navigate to "Print Shack" from the menu.
    *   Enter your custom text in the text field.
    *   Select a print color from the dropdown.
    *   See a live preview of your text.
    *   Click "Add to Cart" to include the personalized item in your order.
5.  **Cart:**
    *   Click the cart icon in the top right corner.
    *   Review your items, including any custom text/color details.
    *   Adjust quantities or remove items.
    *   Proceed to checkout (simulated).
6.  **Authentication:**
    *   Access the login/signup page via the "Login" button in the navigation bar.
    *   Toggle between Login and Sign Up forms.
7.  **Print Shack Info:**
    *   View detailed information about the Print Shack service via the "About Print Shack" link.

### Running Tests

To run the unit and widget tests included in the project:

```bash
flutter test
```

## Project Structure

The project follows a standard Flutter feature-based architecture:

*   **`lib/`**: Contains the main source code.
    *   **`main.dart`**: The entry point of the application.
    *   **`router.dart`**: Configuration for application routing using `go_router`.
    *   **`models/`**: Data models (e.g., `Product`, `CartItem`).
    *   **`services/`**: Business logic and data fetching (e.g., `CartService`, `ProductService`).
    *   **`views/`**: Screen widgets (e.g., `HomeScreen`, `ProductPage`, `CartPage`, `AuthPage`, `PrintShackPage`, `PrintShackAboutPage`, `SaleCollectionPage`, `SearchResultsPage`).
    *   **`widgets/`**: Reusable UI components (e.g., `ProductCard`, `Footer`, `AppBar`, `LoginForm`, `SignupForm`).
*   **`assets/`**: Contains static assets like images and JSON data files (`products.json`, `collections.json`).
*   **`test/`**: Contains unit and widget tests.

### Key Technologies

*   **Flutter:** UI Toolkit.
*   **Provider:** State management for the shopping cart.
*   **GoRouter:** Declarative routing package.
*   **JSON:** Used for mocking product data.

## Known Issues & Limitations

*   **Mock Data:** The application currently uses local JSON files (`assets/products.json`) to simulate a backend database. Changes to products are not persisted.
*   **Simulated Checkout:** The checkout process is purely visual and does not process actual payments.
*   **Authentication:** The authentication flow is a placeholder and does not connect to a real user database.

## Contact Information

**Aaron Woodhouse**

*   **GitHub:** [WoodhouseA](https://github.com/WoodhouseA)
