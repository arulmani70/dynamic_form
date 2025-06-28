# 📱 Dynamic Form & Paginated Users – Flutter Demo

> **Author :** Arulmani  
> **Target Flutter :** 3.22.5 + (stable)  
> **State :** POC / interview assignment ✅

---

## ✨ What’s inside?

| Module                    | Highlights                                                                                             |
| ------------------------- | ------------------------------------------------------------------------------------------------------ |
| **Dynamic Form Renderer** | Reads any JSON, builds a form on the fly (text / number / dropdown), validates, returns map on submit. |
| **Demo Hub**              | Two buttons that open: **Employee On‑Boarding** and **Basic Profile** JSON forms.                      |
| **Splash Screen**         | Small animated logo ➜ routes to `/demoform`. Uses `go_router`.                                         |

---

## 🏗 Folder structure (condensed)

lib/
├─ src/
│ ├─ app/ ← MaterialApp.router, GoRouter setup
│ ├─ common/ ← shared constants, models, utils, DI
│ ├─ form_manager/
│ │ ├─ form_renderer/ ← Dynamic JSON → UI
│ │ └─ demo/ ← Demo page w/ buttons to open sample forms
│ └─ ... ← (future modules can slot in here)
└─ main.dart ← registers get_it, bootstraps App

---

## ✨ What can I do with it?

| ➜ Feature                              | Where                                            | Packages                                                          |
| -------------------------------------- | ------------------------------------------------ | ----------------------------------------------------------------- |
| **Splash Screen** with micro‑animation | `common/widgets/splashscreen.dart`               | —                                                                 |
| **Demo Hub** (open two sample forms)   | `form_manager/demo/demo_page.dart`               | `go_router`                                                       |
| **Dynamic Form Renderer**              | `form_manager/form_renderer/*`                   | `flutter_bloc`, `flutter_form_builder`, `form_builder_validators` |
| **Reusable Field Model**               | `common/models/dynamic_field.dart`               | `equatable`                                                       |
| **Form JSON loader**                   | `form_renderer/repo/form_loader_repository.dart` | `rootBundle`                                                      |
| **Dependency Injection**               | `common/services/services_locator.dart`          | `get_it`                                                          |

---

## 🔧 Getting started

1. **Clone + get packages**

   ```bash
   git clone https://github.com/arulmani70/dynamic_form.git
   cd dynamic_form
   flutter pub get
   ```
