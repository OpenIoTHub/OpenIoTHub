- [Building the Flatpak](#building-the-flatpak)
  - [Build](#build)
    - [Create Flatpak repo of the app](#create-flatpak-repo-of-the-app)
      - [Publish to app store](#publish-to-app-store)
    - [Bundle the Flatpak repo into an installable `.flatpak` file](#bundle-the-flatpak-repo-into-an-installable-flatpak-file)
    - [We now have a `.flatpak` file that we can install on any machine with](#we-now-have-a-flatpak-file-that-we-can-install-on-any-machine-with)
    - [We can see that it is installed:](#we-can-see-that-it-is-installed)


# Building the Flatpak

We imagine this is a separate git repo containing the information specifically
for building the flatpak, as that is how an app is built for FlatHub.

Important configuration files are as follows:

- `com.example.FlutterApp.yml` -- Flatpak manifest, contains the Flatpak
  configuration and information on where to get the build files
- `build-flatpak.sh` -- Shell script that will be called by the manifest to assemble the flatpak


## Build

**This should be built on an older version on Linux so that it will run on the
widest possible set of Linux installations. Recommend docker or a CI pipeline
like GitHub actions using the oldest supported Ubuntu LTS.**

### Create Flatpak repo of the app

This is esentially what will happen when being built by FlatHub.

```bash
flatpak-builder --force-clean build-dir com.example.FlutterApp.yml --repo=repo
```

#### Publish to app store

When this succeeds you can proceed to [submit to an app store like Flathub](https://github.com/flathub/flathub/wiki/App-Submission).


<br>

---

<br>

*The remainder is optional if we want to try installing locally, however only
the first step is needed to succeed in order to publish to FlatHub.*

### Bundle the Flatpak repo into an installable `.flatpak` file

This part is not done when building for FlatHub.

```bash
flatpak build-bundle repo com.example.FlutterApp.flatpak com.example.FlutterApp
```

### We now have a `.flatpak` file that we can install on any machine with
   Flatpak:

```bash
flatpak install --user com.example.FlutterApp.flatpak
```

### We can see that it is installed:

```bash
flatpak list --app | grep com.example.FlutterApp
```

> Flutter App	com.example.FlutterApp	1.0.0	master	flutterapp-origin	user

If we search for "Flutter App" in the system application menu there should be an
entry for the app with the proper name and icon.

We can also uninstall our test flatpak:

```bash
flatpak remove com.example.FlutterApp
```
