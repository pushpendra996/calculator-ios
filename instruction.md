## 📘 Calculator App — Implementation Guide (MVVM + SOLID)

---

### ✅ Step 1: Setup the UI (View Layer)

* Design the layout matching the reference screen.
* Use a `ConstraintLayout` (Android) or `SwiftUI Stack` (iOS) or similar structure depending on platform.
* Create reusable button components (e.g., `CalcButton`) for digits, operators, and actions.
* Display an input/output `TextView` or `Label` for showing expressions/results.
* Hook UI buttons to `ViewModel` using data binding or `onClick` listeners.

---

### ✅ Step 2: Project Architecture Setup

* Create the following folders: `core/`, `data/`, `model/`, `viewmodel/`, `view/`.
* Create interfaces for core operations: `IOperation`, `IHistoryRepository`.
* Setup DI if needed (Koin/Hilt for Android or manual DI).

---

### ✅ Step 3: Implement Basic Arithmetic UseCases (core/usecases)

#### 🔹 Addition

* `AddUseCase : IOperation`
* Implements: `fun execute(a: Double, b: Double): Double = a + b`

#### 🔹 Subtraction

* `SubtractUseCase : IOperation`
* Implements: `fun execute(a: Double, b: Double): Double = a - b`

#### 🔹 Multiplication

* `MultiplyUseCase : IOperation`
* Implements: `fun execute(a: Double, b: Double): Double = a * b`

#### 🔹 Division

* `DivideUseCase : IOperation`
* Implements:

  ```kotlin
  fun execute(a: Double, b: Double): Double {
      require(b != 0.0) { "Cannot divide by zero" }
      return a / b
  }
  ```

---

### ✅ Step 4: Percentage UseCase

* `PercentageUseCase : IOperation`
* Implements:

  ```kotlin
  fun execute(a: Double, b: Double): Double = (a * b) / 100
  ```

---

### ✅ Step 5: ViewModel Logic (viewmodel/)

* `CalculatorViewModel`
* Handles input string, builds expressions, and triggers correct UseCase.
* Handles operator precedence, user input validation.
* Exposes `LiveData`/`StateFlow` to the UI:

  * `displayText`
  * `historyList`
* Method examples:

  * `onDigitClick("5")`
  * `onOperatorClick("+")`
  * `onEqualsClick()`
  * `onClearClick()`

---

### ✅ Step 6: Expression Parsing Logic (core/parser)

* Optional: Build a simple parser to evaluate expressions like `"5+2*3"`
* Or handle left-to-right basic evaluation manually for now
* Later: Add shunting-yard or infix-to-postfix parser if needed

---

### ✅ Step 7: History Feature (data/)

* `HistoryItemModel(val expression: String, val result: String)`
* `HistoryRepository` (implements `IHistoryRepository`)
* Stores history in in-memory list or shared preferences (or SQLite/Room if needed)
* ViewModel updates `historyList` after each calculation
* UI can show modal/dialog to list previous calculations

---

### ✅ Step 8: Testing

* Write unit tests for each UseCase in isolation
* Write ViewModel tests with mocked UseCases and Repository
* Use test cases like:

  * `5 + 2 = 7`
  * `10 / 0 -> Exception`
  * `% calculation`
  * Repeated operator taps
  * Expression evaluation edge cases

---

### ✅ Step 9: Optional Enhancements

* Long press on history item = re-calculate
* Landscape = scientific mode
* Add vibration on key press
* Theme toggle (dark/light)

---

### 🔁 Recap (Implementation Order)

1. **UI Layout**
2. **Folder Structure + Interfaces (SOLID)**
3. **Addition → Subtraction → Multiplication → Division**
4. **Percentage UseCase**
5. **ViewModel Logic**
6. **Expression Parser (Optional)**
7. **History Management**
8. **Testing**
9. **Enhancements**
