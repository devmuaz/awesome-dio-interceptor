## Awesome Dio Interceptor

A simple dio log interceptor (mainly inspired by the built-in dio **`LogInterceptor`**), which has coloring features and json formatting so you can have a better readable output.

## Features

- Customizable, minimizable, and colorful output 🔥
- Json formatting 💪
- Pretty FormData support (fields & files) output ⚡️

## Output Samples

The last two images have been minimized, so we can have better look at the most important logs (can be enabled and disabled, enabled by default)

<div align="center">
	<img
		src='https://github.com/devmuaz/awesome_dio_interceptor/blob/master/images/response.png?raw=true'
		width='1024'
	/>
    </br>
	<img
		src='https://github.com/devmuaz/awesome_dio_interceptor/blob/master/images/minimized-response.png?raw=true'
		width='1024'
	/>
    </br>
	<img
		src='https://github.com/devmuaz/awesome_dio_interceptor/blob/master/images/minimized-error.png?raw=true'
		width='1024'
	/>
</div>

## Usage

Just add the **AwesomeDioInterceptor** to your dio interceptors like so:

```dart
dio.interceptors.add(
    AwesomeDioInterceptor(
        // Disabling headers and timeout would minimize the logging output.
        // Optional, defaults to true
        logRequestTimeout: false,
        logRequestHeaders: false,
        logResponseHeaders: false,

        // Optional, defaults to the 'log' function in the 'dart:developer' package.
        logger: debugPrint,
    ),
);
```

## Medium articles by the author

You can always read the articles I write on my [devmuaz](https://devmuaz.medium.com/) account which I write pretty great flutter content out there.

## Contributions & Support

Issues and pull requests are always welcome 😄

If you find this package useful for you and liked it, give it a like ❤️ and star the repo ⭐️ it would mean a lot!

## License

**MIT**
