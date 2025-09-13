# Mixtral 8x7B macOS DMG

This repository outlines a minimal DMG package for macOS that installs the
[Ollama](https://ollama.ai) runtime, fetches the Mixtral 8x7B model, and launches a
simple web interface. When opened, the page automatically sends an unrestricted
prompt about a cat sitting on a pile of money and displays the model response.

## Quick Setup

Clone the repo and build the DMG in one command:

```bash
git clone https://github.com/yourname/mixtral8x7bmacos.git && cd mixtral8x7bmacos && chmod +x build_dmg.sh install.sh && ./build_dmg.sh
```

## Contents

- `build_dmg.sh` &ndash; creates `mixtral8x7b.dmg` using `hdiutil`.
- `install.sh` &ndash; runs from the DMG to install Ollama, pull the model and open the GUI.
- `webgui/index.html` &ndash; browser client that talks to the local Ollama server.

## Building the DMG

1. Clone this repository on a macOS machine and ensure the build script is
   executable: `chmod +x build_dmg.sh install.sh` (already set in git but
   included here for completeness).
2. Run `./build_dmg.sh` to create the installer image. The script packages
   `install.sh` and the `webgui` folder and outputs
   `dist/mixtral8x7b.dmg`.
3. (Optional) To share the DMG without macOS Gatekeeper warnings, sign and
   notarize it with your Apple Developer ID using `codesign` and
   `xcrun notarytool`.
4. Distribute the resulting `dist/mixtral8x7b.dmg` to end users.

## Automatic DMG Builds with GitHub Actions

### Setup (one time)

1. Ensure the workflow file exists at `.github/workflows/build-dmg.yml` (see
   repository for an example).
2. Make sure `build_dmg.sh` and `install.sh` are executable:
   `chmod +x build_dmg.sh install.sh`.
3. Commit and push to GitHub.

### Every time you want a new DMG

1. Push your code changes to the `main` branch.
2. In your GitHub repository, open the **Actions** tab and wait for the build to
   finish (green checkmark).
3. Click the completed workflow run and download the `mixtral8x7b-dmg`
   artifact.
4. Unzip the artifact to retrieve the DMG.

### For public downloads

1. In your repository, go to **Releases** and choose **Create a new release**.
2. Create a tag (for example, `v1.0.0`) and publish the release.
3. The DMG artifact from the workflow will automatically attach to the
   release for others to download.

## Installing and Running

1. On another macOS machine, double-click the DMG to mount it. If Gatekeeper
   warns about an unsigned script, right-click `install.sh` and choose **Open**.
2. `install.sh` installs Ollama if needed, pulls the Mixtral 8x7B model and
   starts the Ollama service.
3. The default browser opens `webgui/index.html`, automatically issuing the
   example “cat on a pile of money” prompt. You can edit the prompt and send
   new requests from the page.

This setup avoids additional content restrictions; the model output is entirely
controlled by your prompts.

