﻿# 使用 .NET SDK 镜像来构建应用  
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build  
WORKDIR /src  
  
# 复制 csproj 文件并恢复依赖项  
COPY ["CICDTest.csproj", "./"]  
RUN dotnet restore "CICDTest.csproj"  
  
# 复制剩余的应用源代码  
COPY . .  
  
# 构建应用为发布版本  
RUN dotnet build "CICDTest.csproj" -c Release -o /app/build  
  
# 使用 .NET 运行时镜像来运行应用  
# 注意：这里应该使用与 SDK 版本兼容的运行时镜像  
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime  
WORKDIR /app  
  
# 从构建阶段复制发布输出  
COPY --from=build /app/build .  
  
# 设置入口点来运行应用  
# 注意：确保 CICDTest.dll 是在 /app/build 目录下生成的  
# 如果不是，请调整 COPY 指令或构建输出路径  
ENTRYPOINT ["dotnet", "CICDTest.dll"]