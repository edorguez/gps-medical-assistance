# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /src

COPY src/GpsMedicalAssistanceBack/ ./
RUN dotnet restore GpsMedicalAssistanceBack.sln
RUN dotnet publish GpsMedicalAssistanceBack/GpsMedicalAssistanceBack.csproj \
    --configuration Release \
    --no-restore \
    --output /app/publish \
    /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

WORKDIR /app

COPY --from=build /app/publish ./

ENV ASPNETCORE_URLS=http://+:8080 \
    ASPNETCORE_ENVIRONMENT=Production \
    DOTNET_RUNNING_IN_CONTAINER=true

EXPOSE 8080

ENTRYPOINT ["dotnet", "GpsMedicalAssistanceBack.dll"]
