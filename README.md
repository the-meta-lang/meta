<a name="readme-top"></a>
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<br />
<div align="center">
  <a href="https://continuum-ai.de/meta">
    <img src="images/logo-light.svg" width="300">
  </a>

<h3 align="center">META</h3>

  <p align="center">
    The META Compiler writing language
    <br />
    <a href="https://continuum-ai.de/meta/docs"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/the-meta-lang/meta">View Demo</a>
    ·
    <a href="https://github.com/the-meta-lang/meta/issues">Report Bug</a>
    ·
    <a href="https://github.com/the-meta-lang/meta/issues">Request Feature</a>
  </p>
</div>

- [About The Project](#about-the-project)
- [Getting Started](#getting-started)
	- [Prerequisites](#prerequisites)
	- [Installation](#installation)
	- [Using JavaScript](#using-javascript)
	- [Using CLI](#using-cli)
- [Contributing](#contributing)
- [License](#license)


<!-- ABOUT THE PROJECT -->
## About The Project
META is a compiler writing language inspired by the META-II Metacompiler from the seminal paper "[META II a syntax-oriented compiler writing language](https://dl.acm.org/doi/10.1145/800257.808896)" written by Val Schorre in 1963. META allows for the creation of compilers and interpreters for programming languages using a concise and powerful syntax.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites

To use the @metalang package, you must first have Node.js installed on your system. If you don't already have it, please download and install the latest version from the [official Node.js website](https://nodejs.org/en/).


### Installation

If you want to use META as a JavaScript/TypeScript dependency and customize its behavior follow [this guide](#using-javascript).
If you only want to use the command line application follow [this guide instead](#using-cli)

### Using JavaScript

After installing Node.js, create a new directory for your project, navigate to the directory in the terminal, and run the following command:
```sh
npm init
```

This command will initialize your project with a package.json file which will track all the dependencies of your project.

have created a Node.js project, you can now install the `@metalang/core` package.

```sh
npm install @metalang/core --save
```

In your JavaScript you can now import `@metalang/core` like this:

```js
import { compile } from "@metalang/core";
```

Now you can compile any META file just like you would with our cli.

```js
import * as fs from "fs";

const content = fs.readFileSync("<source");
compile(content, {
	debug: false,
	performanceMetrics: true
})
```

Congratulations, you've just compiled your first program with `meta`.

_For more examples, please refer to the [Documentation](https://continuum-ai.de/meta/docs)_

### Using CLI

```sh
npm install @metalang/cli -g
```

This will install the command line interface globally and will expose the following command to your terminal:

```sh
meta <command> <...options>
```

Once you have `@metalang/cli` installed, you can start compiling your META programs.

To compile a META program, open up a terminal or command prompt and navigate to the directory containing your META program source file. Then, run the following command:

```sh
meta compile <source>
```

Replace `<source>` with the actual filename of your META program source file. The meta command will then generate a compiler for your program.

Congratulations! You've just compiled your first META program using `@metalang/cli`.

Note that the above command is just a basic example. `@metalang` provides many more options for optimizing and customizing your META compiler.

_For more examples, please refer to the [Documentation](https://continuum-ai.de/meta/docs)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>


## License

Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


[contributors-shield]: https://img.shields.io/github/contributors/the-meta-lang/meta.svg?style=for-the-badge
[contributors-url]: https://github.com/the-meta-lang/meta/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/the-meta-lang/meta.svg?style=for-the-badge
[forks-url]: https://github.com/the-meta-lang/meta/network/members
[stars-shield]: https://img.shields.io/github/stars/the-meta-lang/meta.svg?style=for-the-badge
[stars-url]: https://github.com/the-meta-lang/meta/stargazers
[issues-shield]: https://img.shields.io/github/issues/the-meta-lang/meta.svg?style=for-the-badge
[issues-url]: https://github.com/the-meta-lang/meta/issues
[license-shield]: https://img.shields.io/github/license/the-meta-lang/meta.svg?style=for-the-badge
[license-url]: https://github.com/the-meta-lang/meta/blob/master/LICENSE.txt