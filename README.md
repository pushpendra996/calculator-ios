# 🔢 Calculator App

A clean and modern Calculator application built using the **MVVM architecture** and **SOLID principles**.

This project includes basic and percentage arithmetic operations, along with a history feature for previous calculations.

---

## ✨ Features

- ✅ Simple, intuitive UI
- ➕ Addition
- ➖ Subtraction
- ✖️ Multiplication
- ➗ Division (with divide-by-zero check)
- 📉 Percentage calculation
- 🧾 Calculation History
- 🧪 Unit-tested UseCases
- 🧠 MVVM + Clean Architecture

---

## 🏗️ Architecture Overview

Presentation (View)
↕
ViewModel (State management)
↕
UseCases (Business logic)
↕
Repositories (Data sources)
↕
Model (Entities)

---

## 🚀 Getting Started

### Prerequisites
- Android Studio / Xcode / Flutter (based on platform)
- Kotlin / Swift / Dart configured

### Folder Structure

├── core/
│ ├── usecases/
│ └── parser/
├── data/
│ └── history/
├── model/
├── view/
├── viewmodel/
└── utils/

---

## ✅ How It Works

### 1. User Interface
- Buttons for numbers and operations
- Display screen for expression/result
- History modal or expandable list

### 2. ViewModel
- Handles input building & operations
- Uses injected UseCases
- Emits updated state to UI

### 3. UseCases
- Pure functions for each operation
- SOLID-compliant: single responsibility

### 4. History Feature
- Stores each result in memory / local storage
- Displays calculation history

---

## 🧪 Testing

- UseCase unit tests
- ViewModel logic tests
- Expression parsing tests (if included)

---

## 🧠 Design Patterns & Principles

- MVVM Architecture
- Dependency Injection
- SOLID Principles
- Single Responsibility for UseCases

---

## 📌 Future Enhancements

- Scientific mode in landscape
- Long press history to re-use
- Light/Dark Theme toggle
- Save history in local DB

---

## 🙌 Credits

Developed by Pushpendra Saini
Design inspired by modern calculator UI trends

---

## 📄 License

This project is open-source and free to use under the [MIT License](LICENSE).

