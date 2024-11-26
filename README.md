# Carry-first
---

# Carry1st E-commerce App Prototype

A Swift-based e-commerce app prototype that showcases product listing, cart management, and network handling functionality. Built as part of the Carry1st iOS developer assessment.

---

## 🚀 Technologies Used

### **Programming Language**
- Swift

### **Frameworks and Libraries**
- **Combine**: For managing asynchronous tasks and reactive programming.
- **SwiftUI**: For building the app's UI components.
- **Resolver**: For handling Dependency Injection.
- **Kingfisher**: For ImageCache and loading from URL
- **XCTest**: For writing and running unit tests.

---

## 🏛️ Architecture

The app is built using the **MVVM (Model-View-ViewModel)** architecture, ensuring separation of concerns and testability.

### Layers
1. **Models**:
    - Core structures like `Product` and `CartItem` define the app's data model.
2. **ViewModels**:
    - Responsible for business logic, including fetching data from repositories and managing state.
    - Examples: `CartViewModel`, `ProductListViewModel`.
3. **Views**:
    - SwiftUI components bind directly to the ViewModels, rendering the app's UI dynamically.
4. **Repositories**:
    - Handle data persistence, including interacting with local storage (`UserDefaults`) and the network.
    - Examples: `CartRepository`, `ProductRepository`.

### Supporting Components
- **Network Manager**:
    - Handles API requests using `Combine` and provides strongly-typed decodable responses.
- **UserDefaultsManager**:
    - Facilitates saving and retrieving `Codable` objects locally.
- **Mock Implementations**:
    - Ensures unit tests can simulate real-world behaviors for various components.

---

## 🤔 Considerations

### **Scalability**
- Designed with modular components, allowing the app to scale by adding new features without major refactoring.

### **Testability**
- Dependencies are injected into ViewModels and Repositories, making them easier to mock and test independently.
- Thorough unit tests are implemented for:
  - ViewModels.
  - Network operations using a mock URL session.
  - UserDefaults handling.

### **Error Handling**
- Comprehensive error management, ensuring robust handling of network issues, decoding errors, and empty states.

### **UI Responsiveness**
- Built with SwiftUI, ensuring a responsive and adaptive design across devices, including dark mode compatibility.

---

## 🛠️ Steps to Run the App

### Prerequisites
- macOS with Xcode 15 or later installed.
- Basic understanding of Swift and SwiftUI.

---

### Running the App

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/UgoValPrime/Carry-first.git
   ```
2. **Open the Project**:
   ```bash
   open Carry1stEcommerceApp.xcodeproj
   ```
3. **Install Dependencies Using Swift Package Manager**:
   - Open the project in Xcode.
   - Navigate to the **Project Navigator** and select the top-level project file.
   - Go to the **Package Dependencies** tab under your project settings.
   - Click the **+** button at the bottom-left corner.
   - Add the following dependencies:
     - **Resolver**:
       - URL: `https://github.com/hmlongco/Resolver.git`
       - Select the latest version and click **Add Package**.
     - **Kingfisher**:
       - URL: `https://github.com/onevcat/Kingfisher.git`
       - Select the latest version and click **Add Package**.

4. **Link Dependencies with Your Target**:
   - Go to the **Build Phases** tab in your project settings.
   - Expand the **Link Binary with Libraries** section.
   - Add the following:
     - `Resolver.framework`
     - `Kingfisher.framework`
   - Ensure they are correctly listed under your app's build target.

5. **Build and Run the App**:
   - Select a simulator or connected device.
   - Use the **play button** in Xcode or press `Cmd + R`.

---

### Running Tests

1. Open the **Test Navigator** in Xcode (`Cmd + 6`).
2. Run all tests by pressing the **play button** next to the "Carry1stEcommerceAppTests" group.
3. Alternatively, use the following shortcut to run all tests:
   - `Cmd + U`.

---

### Running Tests
1. Open the **Test Navigator** in Xcode (`Cmd + 6`).
2. Run all tests by pressing the **play button** next to the "Carry1stEcommerceAppTests" group.
3. Alternatively, use the following shortcut to run all tests:
   - `Cmd + U`.

---

## 🌟 Features Implemented
1. **Product Listing**:
   - Fetch and display a list of products from an API.
2. **Cart Management**:
   - Add, remove, and update quantities of products in the cart.
   - Persist cart state using `UserDefaults`.
3. **Network Requests**:
   - Fetch data using a reusable `NetworkManager` with `Combine`.
4. **Unit Testing**:
   - Mock repositories, protocols, and network operations for complete test coverage.

---

