# air_bnb_clone

A new Flutter project.

## Realm code generation

To regenerate Realm model code (after changing `@RealmModel()` classes), run from the project root:

```bash
dart run realm generate
```

In Flutter projects, if that fails with SDK resolution errors, use instead:

```bash
flutter pub run realm generate
```

Do **not** use `flutter run realm generate` — Flutter treats `realm` as an app target and reports "Target file 'realm' not found."
