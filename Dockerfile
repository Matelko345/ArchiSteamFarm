FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build-dotnet
FROM docker.io/library/node:lts AS build-node

# Ustawienie katalogu roboczego dla .NET
WORKDIR /app

# Kopiowanie plików projektu .NET
COPY --link ArchiSteamFarm ArchiSteamFarm
COPY --link ArchiSteamFarm.OfficialPlugins.ItemsMatcher ArchiSteamFarm.OfficialPlugins.ItemsMatcher
COPY --link ArchiSteamFarm.OfficialPlugins.MobileAuthenticator ArchiSteamFarm.OfficialPlugins.MobileAuthenticator
COPY --link ArchiSteamFarm.OfficialPlugins.SteamTokenDumper ArchiSteamFarm.OfficialPlugins.SteamTokenDumper
COPY --link resources resources
COPY --link Directory.Build.props Directory.Build.props
COPY --link Directory.Packages.props Directory.Packages.props
COPY --link .editorconfig .editorconfig
COPY --link LICENSE.txt LICENSE.txt

# Sekcja Node.js do budowania ASF-ui
WORKDIR /app/ASF-ui
COPY --link ASF-ui .

# Naprawa problemu z .git — usuwam linię, która psuła build
# Nie potrzebujemy kopiować .git/modules

# Budowanie interfejsu
RUN npm install && npm run build

# Uruchomienie finalnego obrazu
CMD ["dotnet", "ArchiSteamFarm.dll"]
