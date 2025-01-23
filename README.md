# AW_Rojo Template
A streamlined template for Roblox development using Rojo, providing a clean project structure with client, server, and shared code organization.

## 📋 Prerequisites
- [Git](https://git-scm.com/downloads)
- [Rojo](https://rojo.space/docs/installation/)
- [Aftman](https://github.com/LPGhatguy/aftman)
- [VS Code](https://code.visualstudio.com/) (recommended)
- [Rojo VS Code Extension](https://marketplace.visualstudio.com/items?itemName=evaera.vscode-rojo) (recommended)

## 🚀 Quick Start

1. Create a new repository using this template:
   - Click "Use this template" at the top of the repository
   - Or clone it directly:
   ```bash
   git clone https://github.com/gh-Constant/AW_rojo.git
   cd AW_rojo
   ```

2. Install dependencies:
   ```bash
   # Install Aftman packages
   aftman install

   # Install Wally packages
   wally install
   ```

3. Start Rojo:
   ```bash
   rojo serve
   ```

4. Connect to Roblox Studio:
   - Open Roblox Studio
   - Install the Rojo plugin if you haven't already
   - Click the Rojo button in Studio and connect to the server

## 📁 Project Structure

```
    AW_rojo/
    ├── src/
    │ ├── client/ # PlayerScripts
    │ ├── server/ # ServerScriptService
    │ └── shared/ # ReplicatedStorage
    ├── default.project.json
    ├── wally.toml
    └── aftman.toml
```

## 📝 Usage

- Place client-side code in `src/client/`
- Place server-side code in `src/server/`
- Place shared code (used by both client and server) in `src/shared/`

## 🛠️ Development Tools

- **Rojo**: Syncs your local files with Roblox Studio
- **Wally**: Package manager for Roblox projects
- **Aftman**: Tool manager for Roblox development

## 📚 Additional Resources

- [Rojo Documentation](https://rojo.space/docs)
- [Wally Package Manager](https://wally.run/)
- [Roblox Developer Hub](https://developer.roblox.com/)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
