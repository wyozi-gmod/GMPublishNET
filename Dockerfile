FROM microsoft/dotnet:sdk AS build-env
ENV CONFIGURATION Release
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY GMPublishNetCore/*.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY GMPublishNetCore/ ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/dotnet:runtime
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "GMPublishNetCore.dll"]