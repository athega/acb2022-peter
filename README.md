# acb2022-peter

An experiment written in [Zig](https://ziglang.org/) for the [WASM-4](https://wasm4.org) fantasy console.

## Building

Build the cart by running:

```shell
zig build -Drelease-small=true
```

Then run it with:

```shell
w4 run zig-out/lib/cart.wasm
```

Or run a watcher:

```shell
w4 watch
```

For more info about setting up WASM-4, see the [quickstart guide](https://wasm4.org/docs/getting-started/setup?code-lang=zig#quickstart).

## Links

- [Documentation](https://wasm4.org/docs): Learn more about WASM-4.
- [GitHub](https://github.com/aduros/wasm4): Submit an issue or PR. Contributions are welcome!
