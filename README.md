# Mixtral 8x7B macOS DMG

This repository outlines a minimal DMG package for macOS that installs the [Ollama](https://ollama.ai) runtime, fetches the Mixtral 8x7B model, and launches a simple web interface. When opened, the page automatically sends an unrestricted prompt about a cat sitting on a pile of money and displays the model response.

## Contents

- `build_dmg.sh` – creates `mixtral8x7b.dmg` using `hdiutil`.
- `install.sh` – copied as `install.command` in the DMG to install Ollama, pull the model and open the GUI.
- `webgui/index.html` – browser client that talks to the local Ollama server.

## Download

Pre-built installers are available on the [releases page](https://github.com/your-org/mixtral8x7bmacos/releases). Download `mixtral8x7b.dmg` and follow the installation steps below.

## Building the DMG

1. Clone this repository on a macOS machine and ensure the scripts are executable: `chmod +x build_dmg.sh install.sh` (already set in git but included here for completeness).
2. Run `./build_dmg.sh` to create the installer image. The script copies `install.sh` as `install.command`, bundles `README.txt` and the `webgui` folder and outputs `dist/mixtral8x7b.dmg`.
3. (Optional) To share the DMG without macOS Gatekeeper warnings, sign and notarize it with your Apple Developer ID using `codesign` and `xcrun notarytool`.
4. Distribute the resulting `dist/mixtral8x7b.dmg` to end users.

## Installing and Running

1. On another macOS machine, double-click the DMG to mount it. If Gatekeeper warns about an unsigned script, right-click `install.command` and choose **Open**.
2. `install.command` installs Ollama if needed, pulls the Mixtral 8x7B model and starts the Ollama service.
3. The default browser opens `webgui/index.html`, automatically issuing the example “cat on a pile of money” prompt. You can edit the prompt and send new requests from the page.

This setup avoids additional content restrictions; the model output is entirely controlled by your prompts.

## System Requirements

- macOS 13 or later
- At least 20 GB of free disk space
- Internet connection for downloading the Ollama runtime and model

## Troubleshooting

- **Script blocked by Gatekeeper:** right-click `install.command` and choose **Open**.
- **Ollama service fails to start:** open the Ollama app manually and retry the installer.
- **Model download issues:** ensure your internet connection is stable and sufficient disk space is available.


