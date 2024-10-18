   FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
   WORKDIR /src
   COPY ["CICDTest.csproj", "./"]
   RUN dotnet restore "CICDTest.csproj"
   COPY . .
   WORKDIR "/src/."
   RUN dotnet build "CICDTest.csproj" -c Release -o /app/build

   FROM build AS publish
   RUN dotnet publish "CICDTest.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CICDTest.dll"]