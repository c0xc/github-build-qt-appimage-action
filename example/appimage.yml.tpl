---
name: Build AppImage executable

on:
  - push

jobs:
  build-appimage:

    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2
      - name: Run build container
        uses: c0xc/github-build-qt-appimage-action@debian-8
        with:
          recipe: .build_pipe_vars
      - name: 'Upload Artifact'
        uses: actions/upload-artifact@v3
        with:
          name: executable
          path: |
            bin/*
            *.AppImage

