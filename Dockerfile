# Skapa en image för att köra en .NET Core applikation
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# för att undvika att alla dependencies laddas om vid varje build
COPY *.csproj ./
RUN dotnet restore

# för att bygga applikationen
COPY . ./
RUN dotnet publish -c Release -o /app

# Kör applikationen
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app .

# Exponera port 5000 för att kunna anropa applikationen
EXPOSE 5000
ENTRYPOINT ["dotnet", "TravelInspirationApp.dll"]
