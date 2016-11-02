whiz
==============

[![Build Status](https://travis-ci.org/aotarola/whiz.svg?branch=master)](https://travis-ci.org/aotarola/whiz)

Elm POS


# Development

### Installation

```
npm install
```
It will also download Electron runtime, and install dependencies for second `package.json` file inside `app` folder.

### Starting the app

```
npm start
```

# Testing

### Unit tests

Using [electron-mocha](https://github.com/jprichardson/electron-mocha) test runner with the [chai](http://chaijs.com/api/assert/) assertion library. To run the tests go with standard:
```
npm test
```
Test task searches for all files in `src` directory which respect pattern `*.spec.js`.

### End to end tests

Using [mocha](https://mochajs.org/) test runner and [spectron](http://electron.atom.io/spectron/). Run with command:
```
npm run e2e
```
The task searches for all files in `e2e` directory which respect pattern `*.e2e.js`.


# Making a release

```
npm run release
```

# License

Released under the MIT license.
