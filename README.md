:ramen: :nail_care: `miso-ui`
====================

`miso-ui` is a component library that uses [Basecoat](https://basecoatui.com/) to deliver [ShadCN](https://ui.shadcn.com) styling. It uses [Tailwind CSS](https://tailwindcss.com/) utility classes under the hood.

<a href="https://ui.haskell-miso.org">
<img width="841" height="567" alt="image" src="https://github.com/user-attachments/assets/9bea5783-848f-48fa-b2e0-7489c70ab821" />
</a>

### Installation

To install and use [Basecoat](https://basecoatui.com/) see the [Installation](https://basecoatui.com/installation/) docs.

### Development

Call `nix develop` to enter a shell with [GHC 9.12.2](https://haskell.org/ghc)

```bash
$ nix develop
```

Once in the shell, you can call `cabal run` to start the development server and view the application at http://localhost:8080

### Build (Web Assembly)

```bash
$ nix develop .#wasm --command bash -c "make"
```

### Build (MicroHs)

```bash
$ nix develop .#mhs --command bash -c "make mhs"
```

### Serve

To host the built application you can call `serve`

```bash
$ nix develop --command bash -c "make serve"
```

This comes with a GitHub action that builds and auto hosts the example.
