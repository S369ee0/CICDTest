﻿# 使用 .NET SDK 镜像来构建应用  
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build  
WORKDIR /src
EXPOSE 80
EXPOSE 443
  
# 复制 csproj 文件并恢复依赖项  
COPY ["./CICDTest/CICDTest.csproj", "./"]  
RUN dotnet restore "CICDTest.csproj"  
  
COPY . .  
  
RUN dotnet build "./CICDTest/CICDTest.csproj" -c Release -o /app/build  
 
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime  
WORKDIR /app  
  

COPY --from=build /app/build .  
  
ENTRYPOINT ["dotnet", "CICDTest.dll"]