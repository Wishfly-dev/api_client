# Wishfly API client

[![pub package](https://img.shields.io/pub/v/wishfly_api_client.svg)](https://pub.dev/packages/wishfly_api_client)
[![ci](https://github.com/Wishfly-dev/api_client/actions/workflows/main.yaml/badge.svg)](https://github.com/Wishfly-dev/api_client/actions/workflows/main.yaml)
[![Website](https://img.shields.io/badge/website-wishfly.dev-blue.svg)](https://wishfly.dev/)
[![Twitter](https://img.shields.io/badge/Twitter-@Wishflydev-00c573.svg)](https://twitter.com/Wishflydev)


The Wishfly API Client is a package that enables developers to interact with the Wishfly API. It makes it easy to create, retrieve, update and delete wishes in a simple, programmatic way using Dart language without UI provided. Your design is completely up to. 

## Installation

To add the Wishfly API Client to your Flutter project, add the following line to your `pubspec.yaml` file under the `dependencies:` section:

```yaml
wishfly_api_client: ^<latest version>
```

Then run `flutter pub get` to fetch the package.

## Usage

Before you can use the Wishfly API Client, you need to import it:

```dart
import 'package:wishfly_api_client/wishfly_api_client.dart';
```

Then, create an instance of the client using your API key:

```dart
final client = WishflyApiClient(apiKey: 'your-api-key');
```

Now you can use this instance to interact with the Wishfly API. For example, to get all projects:

```dart
await client.getProjects();
```

or creating feature request in project:

```dart
await client.createWish(
    request: WishRequestDto(
        title: 'My wish',
        description: 'My wish description', // or null
        projectId: 0, // Project ID from Wishfly admin
    ),
);
```



## Contributing

We welcome contributions to the Wishfly API Client. If you have a feature request or bug report, please open an issue on the [Github repository](https://github.com/Wishfly-dev/api_client/issues).

If you're making a larger change, please open an issue first to discuss it before making a pull request.

## Help

If you have any questions about using the Wishfly API Client, please post on the [Github repository](https://github.com/Wishfly-dev/api_client/issues) and the maintainer will do their best to help you.

## License

The Wishfly API Client is licensed under the [MIT License](https://github.com/Wishfly-dev/api_client/blob/dev/LICENSE).