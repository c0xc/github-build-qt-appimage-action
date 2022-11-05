GITHUB BUILD PIPELINE FOR QT
============================

This is a custom build pipeline for Qt projects.

It can be added to Qt project repositories to build the application
and create a portable AppImage file whenever new code is pushed.
An AppImage file is an executable file which includes requires libraries,
so it will work on almost any modern Linux system without having
to manually install those libraries first.

All the user has to do is mark the AppImage file as executable
which is easily done in any file manager (file properties, permissions).
By default, this pipeline will put this executable file into a tarball
where the executable bit is already set.



How
---

To use it for automatic builds, add a workflow file and a build settings file
to your repository. An example can be found in the `example/` directory.

Workflow file: `(REPO)/.github/workflows/appimage.yml`

Build settings file (if not changed in workflow): `(REPO)/.build_pipe_vars`

See `example/README.md`.



Dependencies
------------

Your Qmake project file must contain an install section:

    target.path = /usr/bin
    INSTALLS += target



Why
---

I have tried a well known build pipeline and was unhappy with it.
It failed in several ways (fuse error, file not found etc.).
I also wanted to add Qt files to the bundled AppImage executable
that may be required to start the application, otherwise it may be missing
fonts depending on how Qt was build and/or it may fail to start due to
missing platform plugins:

    qt.qpa.plugin: Could not find the Qt platform plugin "xcb" in ""
    This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.



What
----

When the build pipeline starts, it creates a Docker container with Debian 8.
If no Qt source tarball is added, it downloads Qt 5.15.2 and builds it.
If the linuxdeploy tool is not added, it's downloaded.
It will then build the Qt project, resulting in a binary file in `bin/`.
This application binary file will then be bundled with its required libraries
and saved as AppImage file.

Note that building Qt will take more than 1-2 hours.
And actually, it may not be necessary to rebuild Qt everytime,
but that's how this pipeline works currently (and how it will work
if you select the "debian-8" branch).
The Debian branch is selected by the "@debian-8" suffix in the workflow file:
`uses: c0xc/github-build-qt-appimage-action@debian-8`

Debian version 8 was selected because it's sufficiently old to have libraries
that are compatible with newer systems. An application binary built on a new
system with recent libraries may not work on older systems.
Debian was selected because it's not Ubuntu.

A different version of this build pipeline which does not rebuild Qt
is available in a test version, but not in this branch.

This pipeline action is somewhat experimental (but for me, it works better
than the other one which wasn't marked as experimental).



