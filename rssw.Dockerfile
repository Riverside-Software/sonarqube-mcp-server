FROM mcp/sonarqube:latest
ADD build/libs/sonarqube-mcp-server-1.3-SNAPSHOT.jar ./sonarqube-mcp-server.jar
