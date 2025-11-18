# Union Shop Development Checklist

This checklist breaks down the development of the Union Shop Flutter application into clear, actionable steps. Each step includes reasoning and data type suggestions to guide an LLM in implementing the features.

## Basic Features (40%)

### 1. Static Homepage (5%)

-   [ ] **Create `home_page.dart` file:** This file will contain the `HomePage` widget.
    *   **Reasoning:** To separate the homepage UI from other parts of the app, improving modularity.
-   [ ] **Implement `HomePage` as a `StatelessWidget`:**
    *   **Reasoning:** The initial homepage will display static content that doesn't change, so a `StatelessWidget` is sufficient and more performant.
-   [ ] **Build the layout using a `Scaffold` widget:** The `Scaffold` will have an `appBar` and a `body`.
    *   **Reasoning:** `Scaffold` provides a standard visual layout structure for Material Design apps.
-   [ ] **Add a `Column` or `ListView` to the `body` for vertical arrangement of content.**
    *   **Reasoning:** To display promotional banners, featured products, and other sections vertically.
-   [ ] **Create static widgets for different sections:**
    *   **Promotional Banner:** A `Container` with a background image (`Image.asset`) and promotional text (`Text` widget).
    *   **Featured Products:** A `Row` or `GridView` of `ProductCard` widgets. Each `ProductCard` will be a `StatelessWidget` displaying hardcoded data.
        *   **Data:** Use a `Map<String, dynamic>` for each product with keys like `'name': 'T-Shirt'`, `'price': '£15.00'`, `'image': 'assets/images/tshirt.png'`.
    *   **Reasoning:** Using hardcoded data is acceptable for this stage and allows for rapid UI prototyping.

### 2. About Us Page (5%)

-   [ ] **Create `about_us_page.dart` file:** This will contain the `AboutUsPage` widget.
-   [ ] **Implement `AboutUsPage` as a `StatelessWidget`:**
    *   **Reasoning:** The content is static and informational.
-   [ ] **Use a `Scaffold` with an `appBar` titled "About Us".**
-   [ ] **Add a `SingleChildScrollView` to the `body` to ensure content is scrollable.**
-   [ ] **Display company information using `Text` widgets for paragraphs and headings.**
    *   **Data:** Hardcode the text for the company's history, mission, and team.

### 3. Footer (4%)

-   [ ] **Create a `footer.dart` file for a reusable `Footer` widget.**
-   [ ] **Implement `Footer` as a `StatelessWidget`:**
    *   **Reasoning:** The footer content is static.
-   [ ] **Use a `Container` with a distinct background color.**
-   [ ] **Use a `Row` or `Column` to layout dummy links and information.**
    *   **Links:** Use `TextButton` or `InkWell` with `Text` widgets for links like "Contact Us", "FAQ", "Terms of Service". The `onPressed` callbacks can be empty for now.
    *   **Social Media Icons:** Use an icon library like `font_awesome_flutter` and display icons in a `Row`.
-   [ ] **Add the `Footer` widget to the `bottomNavigationBar` or at the bottom of the main content `Column`/`ListView` in at least one page (e.g., `HomePage`).**

### 4. Dummy Collections Page (5%)

-   [ ] **Create `collections_page.dart` for the `CollectionsPage` widget.**
-   [ ] **Implement `CollectionsPage` as a `StatelessWidget`:**
    *   **Reasoning:** Displaying a static list of collections.
-   [ ] **Use a `Scaffold` with an `appBar` titled "Collections".**
-   [ ] **Use a `GridView` or `ListView` to display collection cards.**
-   [ ] **Create a `CollectionCard` widget:**
    *   **Data:** Each card will represent a collection using a `Map<String, dynamic>` with keys like `'name': 'Summer Collection'`, `'image': 'assets/images/summer.png'`.
    *   **UI:** The card should display the collection name and an image.

### 5. Dummy Collection Page (5%)

-   [ ] **Create `collection_page.dart` for the `CollectionPage` widget.**
-   [ ] **Implement `CollectionPage` as a `StatelessWidget`:**
    *   **Reasoning:** The product data within the collection is hardcoded.
-   [ ] **Use a `Scaffold` with an `appBar` showing the collection name.**
-   [ ] **Add non-functional filter and sort widgets:**
    *   **UI:** Use `DropdownButton` widgets for sorting and filtering options. The `onChanged` callbacks can be empty.
    *   **Data:** The dropdown items can be a `List<String>` like `['Price: Low to High', 'Newest']`.
-   [ ] **Display products using a `GridView` of `ProductCard` widgets with hardcoded data.**

### 6. Dummy Product Page (4%)

-   [ ] **Create `product_page.dart` for the `ProductPage` widget.**
-   [ ] **Implement `ProductPage` as a `StatelessWidget`:**
    *   **Reasoning:** All product details are hardcoded.
-   [ ] **Use a `Scaffold` for the page layout.**
-   [ ] **Display product images using a `PageView` or a `Column` of `Image.asset` widgets.**
-   [ ] **Show product details:**
    *   **Name:** `Text` widget with a large font size.
    *   **Price:** `Text` widget.
    *   **Description:** `Text` widget.
-   [ ] **Add non-functional UI widgets:**
    *   **Size/Color Dropdowns:** `DropdownButton` with hardcoded `List<String>` options.
    *   **Quantity Selector:** A `Row` with `IconButton`s for increment/decrement and a `Text` widget to show the quantity.
    *   **Add to Cart Button:** An `ElevatedButton` with an empty `onPressed` callback.

### 7. Sale Collection Page (4%)

-   [ ] **Create `sale_collection_page.dart` for the `SaleCollectionPage` widget.**
-   [ ] **Implement `SaleCollectionPage` as a `StatelessWidget`:**
    *   **Reasoning:** Displaying a static list of sale items.
-   [ ] **Use a `Scaffold` with an `appBar` titled "Sale".**
-   [ ] **Display sale products using a `GridView` of `ProductCard` widgets.**
-   [ ] **Modify the `ProductCard` to show discounted prices:**
    *   **Data:** The product `Map` should include `'original_price'` and `'sale_price'`.
    *   **UI:** Display the original price with a strikethrough and the sale price prominently. Use `Text` with `TextDecoration.lineThrough`.
-   [ ] **Add promotional messaging using `Container` and `Text` widgets.**

### 8. Authentication UI (3%)

-   [ ] **Create `auth_page.dart` for the `AuthPage` widget.**
-   [ ] **Implement `AuthPage` as a `StatefulWidget` to toggle between Login and Signup forms.**
    *   **State Variable:** `bool _showLoginPage = true;`
-   [ ] **Create `login_form.dart` and `signup_form.dart` for the respective form widgets.**
-   [ ] **Implement forms using the `Form` widget and `TextFormField` for email and password fields.**
    *   **Reasoning:** `Form` provides validation capabilities.
-   [ ] **Add `ElevatedButton` for form submission. The `onPressed` callbacks can be empty.**
-   [ ] **Add a `TextButton` to switch between the login and signup views.**

### 9. Static Navbar (5%)

-   [ ] **Create `navbar.dart` for a reusable `NavBar` widget.**
-   [ ] **Implement `NavBar` as a `StatelessWidget`:**
-   [ ] **Use a `LayoutBuilder` to create a responsive navigation bar.**
    *   **Reasoning:** `LayoutBuilder` provides the constraints of the parent widget, which can be used to decide whether to show the desktop or mobile layout.
-   [ ] **Desktop View:**
    *   **Condition:** `if (constraints.maxWidth > 600)`
    *   **UI:** A `Row` of `TextButton`s for navigation links (e.g., "Home", "Collections", "About Us"). Links do not need to function yet.
-   [ ] **Mobile View:**
    *   **Condition:** `else`
    *   **UI:** An `IconButton` with a menu icon (`Icons.menu`). The `onPressed` can open a `Drawer` for navigation links.
-   [ ] **Integrate the `NavBar` into the `appBar` of the `Scaffold` on the main pages.**

## Intermediate Features (35%)

### 1. Dynamic Collections Page (6%)

-   [ ] **Create a `Collection` data model (`collection_model.dart`):**
    *   **Class:** `class Collection { final String id; final String name; final String imageUrl; }`
-   [ ] **Create a `CollectionService` (`collection_service.dart`):**
    *   **Method:** `Future<List<Collection>> getCollections()` that returns a `Future` with a list of `Collection` objects (can be from a mock JSON file or a simple `List`).
-   [ ] **Convert `CollectionsPage` to a `StatefulWidget`:**
    *   **Reasoning:** To manage the state of the fetched collections, sorting, and filtering.
-   [ ] **Fetch data in `initState` using the `CollectionService`.**
    *   **State Variable:** `late Future<List<Collection>> _collectionsFuture;`
-   [ ] **Use a `FutureBuilder` to display a loading indicator and then the `GridView` of collections.**
-   [ ] **Implement sorting and filtering logic:**
    *   **State Variables:** `String _sortOption;`, `Map<String, bool> _filterOptions;`
    *   **Logic:** Update the list of collections displayed based on the selected options and call `setState`.

### 2. Dynamic Collection Page (6%)

-   [ ] **Create a `Product` data model (`product_model.dart`):**
    *   **Class:** `class Product { final String id; final String name; final double price; final String imageUrl; ... }`
-   [ ] **Create a `ProductService` (`product_service.dart`):**
    *   **Method:** `Future<List<Product>> getProductsByCollection(String collectionId)`
-   [ ] **Convert `CollectionPage` to a `StatefulWidget`:**
-   [ ] **Fetch products in `initState` based on the `collectionId` passed to the widget.**
-   [ ] **Use a `FutureBuilder` to handle the async data fetching.**
-   [ ] **Implement functional sorting, filtering, and pagination widgets:**
    *   **Pagination:** Use a `ScrollController` to detect when the user reaches the end of the list and fetch more products.

### 3. Functional Product Pages (6%)

-   [ ] **Convert `ProductPage` to a `StatefulWidget`:**
    *   **Reasoning:** To manage the state of selected options (size, color) and quantity.
-   [ ] **Fetch product data using `ProductService` based on a `productId`.**
-   [ ] **Populate the UI with data from the `Product` object.**
-   [ ] **Implement functional dropdowns and counters:**
    *   **State Variables:** `String? _selectedSize;`, `Color? _selectedColor;`, `int _quantity = 1;`
    *   **Logic:** Update these state variables in the `onChanged` and `onPressed` callbacks of the respective widgets and call `setState`.

### 4. Shopping Cart (6%)

-   [ ] **Create a `CartItem` model (`cart_model.dart`):**
    *   **Class:** `class CartItem { final Product product; int quantity; }`
-   [ ] **Create a `CartService` (`cart_service.dart`) using a state management solution (e.g., `Provider`, `Riverpod`):**
    *   **Reasoning:** To manage the global state of the shopping cart.
    *   **State:** `List<CartItem> _items = [];`
    *   **Methods:** `void addToCart(Product product)`, `void removeFromCart(String productId)`, `void updateQuantity(String productId, int quantity)`.
-   [ ] **Implement "Add to Cart" functionality on the `ProductPage`.**
-   [ ] **Create `cart_page.dart`:**
    *   **UI:** Display a `ListView` of `CartItem` widgets, showing product details, quantity, and a total price.
-   [ ] **Implement a checkout button that simulates placing an order (e.g., shows a confirmation dialog and clears the cart).**

### 5. Print Shack (3%)

-   [ ] **Create `print_shack_page.dart` and `print_shack_about_page.dart`.**
-   [ ] **Implement the `PrintShackPage` as a `StatefulWidget`:**
    *   **Reasoning:** The form fields will dynamically update the UI.
-   [ ] **Create a form for text personalization:**
    *   **Fields:** `TextFormField` for custom text, `DropdownButton` for font, `ColorPicker` for color.
    *   **State Variables:** `String _customText;`, `String _selectedFont;`, `Color _selectedColor;`
-   [ ] **Create a preview widget that updates in real-time as the user types or selects options.**
    *   **Logic:** Use the `onChanged` callbacks of the form fields to call `setState` and rebuild the preview widget with the new styles.

### 6. Navigation (3%)

-   [ ] **Set up a routing solution (e.g., `Navigator 2.0` with `Router`, or a package like `go_router`).**
    *   **Reasoning:** To handle named routes and URL-based navigation.
-   [ ] **Define routes for all pages (e.g., `/`, `/collections`, `/product/:id`).**
-   [ ] **Update all navigation logic (`onPressed` callbacks for buttons, links) to use the router for navigation.**
    *   **Example:** `context.go('/product/123')` with `go_router`.

### 7. Responsiveness (5%)

-   [ ] **Review all pages and ensure they are adaptive.**
-   [ ] **Use `LayoutBuilder`, `MediaQuery`, and responsive widgets like `Wrap`, `FittedBox`, and `AspectRatio`.**
-   [ ] **Test the layout on different screen sizes by resizing the window in desktop mode.**
    *   **Focus Areas:** `GridView` column counts, text sizes, padding, and margin adjustments.

## Advanced Features (25%)

### 1. Authentication System (8%)

-   [ ] **Choose an authentication provider (e.g., Firebase Authentication, Auth0).**
-   [ ] **Create an `AuthService` (`auth_service.dart`):**
    *   **Methods:** `Future<User?> signUp(String email, String password)`, `Future<User?> signIn(String email, String password)`, `Future<void> signOut()`, `Stream<User?> get authStateChanges`.
-   [ ] **Integrate the `AuthService` with the `AuthPage` forms.**
-   [ ] **Implement a stream-based approach in `main.dart` to show the `HomePage` or `AuthPage` based on the user's authentication state.**
-   [ ] **Create an `account_dashboard_page.dart`:**
    *   **UI:** Display user information (email, name), order history, and saved addresses.
    *   **Functionality:** Allow users to update their profile and password.
-   [ ] **Protect routes that require authentication using the router.**

### 2. Cart Management (6%)

-   [ ] **Enhance the `CartService`:**
    *   **Quantity Editing:** Implement `updateQuantity` in the `CartPage`.
    *   **Removal:** Implement `removeFromCart` for each item in the cart.
    *   **Price Calculations:** Add a getter for the total price that calculates `sum(item.price * item.quantity)`.
-   [ ] **Implement persistence for the cart:**
    *   **Logic:** When the cart changes, save it to local storage (e.g., `shared_preferences`). When the app starts, load the cart from local storage.
    *   **Reasoning:** To ensure the user's cart is not lost when they close the app.

### 3. Search System (4%)

-   [ ] **Add a search bar (`TextField` or `SearchBar` widget) to the `NavBar` and `Footer`.**
-   [ ] **Create `search_results_page.dart`.**
-   [ ] **Implement search functionality in the `ProductService`:**
    *   **Method:** `Future<List<Product>> searchProducts(String query)`
-   [ ] **When the user submits a search, navigate to the `SearchResultsPage` and display the results.**
    *   **UI:** Use a `FutureBuilder` to show a loading state and then the list of matching products.
    *   **Bonus:** Implement a live search that updates results as the user types.