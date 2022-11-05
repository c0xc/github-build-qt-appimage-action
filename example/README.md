Setup
-----

Take the workflow file and the build settings file from this example directory
and make the modifications as explained below.
Then add these files to your Qt project repository:

The workflow file goes into the subdirectory `.github/workflows/`,
for example: `(REPO)/.github/workflows/appimage.yml`

The build settings file goes in the root of your project repository,
but you are free to move it into a subdirectory and set the file path
in the workflow file.

Modifications
-------------

The **build settings file** specifies the desktop file and the icon to be used:

    desktop_file=my_program.desktop
    icon_file=res/my_program.png

Both are required to build an AppImage file. Change these variables so that they point to the desktop and icon files in your project repository.
The icon file must have a valid resolution (like 256x256).

If you specify a font file, it will be included in the AppImage file:

    font_file=res/my_font.ttf

If your application requires additional libraries to be built,
you can specify the Debian package(s) to be installed in the build container:

    INSTALL_DEBIAN=libfoo-dev

The **workflow file** `appimage.yml.tpl` is basically ready to use, just remove the ".tpl" suffix.

This defines when to start the build pipeline. In this case, whenever changed are pushed into any branch:

    on:
      - push

It could be changed to only start the build pipeline whenever something is pushed to the master or to a release branch (excluding test branches):

    on:
      push:
        branches:
          - main
          - 'releases/**'

The `uses` variable points to the path of this Github action.
The suffix "@debian-8" will create a Debian 8 container and build Qt.

    uses: c0xc/github-build-qt-appimage-action@debian-8

This suffix can be replaced with "@master" when a new version of this
build pipeline is available, which could be configured not to build Qt:

    uses: c0xc/github-build-qt-appimage-action@master

The `recipe` variable defines the path to the build settings file:

    recipe: .build_pipe_vars



