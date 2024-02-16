# assignment-template-typst

This repository provides a simple Typst template for writing your Assignments at UiT (The Arctic University of Norway). The template is _supercharged_ with the [typst](https://typst.app/home) language, which is a simple and powerful language for writing scientific documents.

> [!NOTE]
> This is only a template. You have to adapt the template to your current assignment!

## Installation

To use this template, you need to have the `typst` language installed on your computer. There are several ways to install `typst`:

- Use your OS package manager like `apt` or `brew` to install Typst. Take note that these could be several versions behind the latest release.

- You can also download the latest release from the [GitHub releases page](https://github.com/typst/typst/releases), which provides precompiled binaries for Windows, Linux, and macOS.

- Nix users can use the provided flake, which contains the `typst`, `typstfmt` and `typst-lsp` packages. It can be activated using `direnv allow` or simply `nix flake build`.

For more information on how to install `typst`, please refer to the [official documentation](https://github.com/typst/typst?tab=readme-ov-file#installation).

## Usage

### Set up the assignments metadata

Fill in your assignment details in the `uit_template` function, it should contain the following:

- Your name, Email (abc@uit.no) and GitHub user
- Assignment title
- Your Index Terms
- An Abstract

### Build PDFs locally

Once you have installed Typst, you can use it like this:

```console
# Creates `main.pdf` in working directory.
typst compile main.typ

# Creates PDF file at the desired path.
typst compile main.typ path/to/output.pdf
```

You can also watch source files and automatically recompile on changes. This is
faster than compiling from scratch each time because Typst has incremental compilation.

```console
# Watches source files and recompiles on changes.
typst watch main.typ
```

If the `typstfmt` is installed, then the text can be formatted using:

```console
typstfmt main.typ
```


### Working in the Typst Web Editor

If you prefer an Overleaf-like experience with autocompletion, preview and (soon)spellchecking, then the Typst web editor is for you. It allows you to import files directly into a new or existing document. Here's a step-by-step guide:

1. Navigate to the [Typst Web Editor](https://typst.app/).

2. Create or Sign in to your Account.

3. Create a new blank document.

4. Click on "File" on the top left menu, then "Upload File".

5. Select all `.typ` and `.bib` files along with the figures (svg and png) provided in this template repository.

> [!NOTE]
> You can select multiple files to import at the same time. The editor will import and arrange all the files accordingly. Watch out if your figures are in a directory, the may end up in root.

# Resources 

Other resources that may be helpful to new and experienced Typsters alike.

- [The Typst Book](https://sitandr.github.io/typst-examples-book/book/basics/index.html)
- [Typst Guide for LaTeX Users](https://typst.app/docs/guides/guide-for-latex-users/)
- [Typst Documentation](https://typst.app/docs/)

