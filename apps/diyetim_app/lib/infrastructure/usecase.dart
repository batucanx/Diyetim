/// Usecase girdisi tabanı.
abstract class Input {
  const Input();
}

/// Usecase çıktısı tabanı.
abstract class Output {
  const Output();
}

/// Tek bir iş kuralı. Domain katmanındadır; Flutter'a ve paketlere bağımlı değildir.
abstract class Usecase<I extends Input, O extends Output> {
  const Usecase();
  Future<O> call(I input);
}
